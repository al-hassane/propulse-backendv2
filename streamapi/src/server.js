const os = require('node:os');
const express = require('express');
const cors = require('cors');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const redis = require('redis');
const { PrismaClient } = require('@prisma/client');

const PORT = Number(process.env.PORT || 3010);
const INSTANCE = os.hostname();
const JWT_SECRET = process.env.JWT_SECRET || 'propulse_super_secret_key_2026_elite';
const AI_ENGINE_URL = process.env.AI_ENGINE_URL || 'http://77.42.24.179:8001';
const CLOUDFRONT_URL = process.env.CLOUDFRONT_URL || null;
const REDIS_URL = process.env.REDIS_URL || 'redis://localhost:6380';

const prisma = new PrismaClient();
const app = express();

let redisClient = null;
let activeAiCalls = 0;
const MAX_PARALLEL_AI_CALLS = 20;

(async () => {
  try {
    redisClient = redis.createClient({ url: REDIS_URL });
    redisClient.on('error', (err) => console.log('Redis error:', err.message));
    await redisClient.connect();
    console.log('Redis connected');
  } catch (error) {
    console.log('Redis unavailable:', error.message);
    redisClient = null;
  }
})();

function toCdnUrl(s3Url) {
  if (!CLOUDFRONT_URL || !s3Url) return s3Url;
  if (!s3Url.includes('propulse-media-final-storage.s3')) return s3Url;
  return s3Url.replace(/^https:\/\/[^/]+\.s3\.[^/]+\.amazonaws\.com/, CLOUDFRONT_URL);
}

function videoUrl(url) {
  if (!url) return url;
  if (url.includes('cloudinary')) {
    return url.replace('/upload/', '/upload/f_auto,q_auto:good,vc_h264,w_720/');
  }
  return toCdnUrl(url);
}

async function waitForAiSlot() {
  while (activeAiCalls >= MAX_PARALLEL_AI_CALLS) {
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
  activeAiCalls += 1;
}

function releaseAiSlot() {
  activeAiCalls -= 1;
}

function recommendationTtl() {
  const hour = new Date().getHours();
  if (hour >= 22 || hour <= 6) return 14400;
  return 1800;
}

async function getAiRecommendations(userId) {
  await waitForAiSlot();
  try {
    if (redisClient) {
      try {
        const cached = await redisClient.get(`ai:user:${userId}`);
        if (cached) {
          await redisClient.expire(`ai:user:${userId}`, recommendationTtl());
          return JSON.parse(cached);
        }
      } catch (error) {
        console.log('Redis read failed:', error.message);
      }
    }

    try {
      const response = await axios.get(`${AI_ENGINE_URL}/ai/feed/${userId}`, { timeout: 2000 });
      const postIds = response.data && response.data.post_ids;
      if (postIds && postIds.length > 0) {
        if (redisClient) {
          const ttl = recommendationTtl();
          await redisClient.setEx(`ai:user:${userId}`, ttl, JSON.stringify(postIds));
        }
        return postIds;
      }
    } catch (error) {
      console.log(`AI unavailable for user ${userId}: ${error.message}`);
    }
    return null;
  } finally {
    releaseAiSlot();
  }
}

function attachUser(req, _res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) return next();
  const token = authHeader.split(' ')[1];
  const apply = (decoded) => {
    if (req.query && req.query.userId) req.query.userId = decoded.userId;
    req.user = decoded;
  };
  try {
    apply(jwt.verify(token, JWT_SECRET));
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      try {
        const decoded = jwt.verify(token, JWT_SECRET, { ignoreExpiration: true });
        const expiredAt = new Date(decoded.exp * 1000);
        if (Date.now() - expiredAt.getTime() < 30 * 24 * 60 * 60 * 1000) apply(decoded);
      } catch {
        // Ignore tokens that cannot be decoded.
      }
    }
  }
  next();
}

const reelsInclude = {
  user: {
    include: {
      certification: true,
      followedBy: {
        take: 3,
        include: { follower: { select: { id: true, fullName: true, avatarUrl: true } } },
      },
    },
  },
  likes: { include: { user: { select: { id: true, fullName: true, avatarUrl: true } } } },
  audio: { include: { author: true } },
  votes: true,
  ratings: { select: { score: true } },
  _count: { select: { ratings: true, votes: true, likes: true } },
};

function presentReel(reel, currentUserId) {
  const myVote = reel.votes?.find((vote) => vote.userId === currentUserId);
  const validRatings = (reel.ratings || []).filter((rating) => rating.score > 0);
  const avg = validRatings.length > 0
    ? (validRatings.reduce((sum, rating) => sum + rating.score, 0) / validRatings.length).toFixed(1)
    : '0.0';
  return {
    ...reel,
    imageUrl: videoUrl(reel.imageUrl),
    avgRating: avg,
    ratingsCount: reel._count?.ratings || 0,
    userVote: myVote ? myVote.option : null,
    pollStats: {
      YES: reel.votes?.filter((vote) => vote.option === 'YES').length || 0,
      NO: reel.votes?.filter((vote) => vote.option === 'NO').length || 0,
    },
  };
}

app.use((_req, res, next) => {
  res.set('x-instance', INSTANCE);
  next();
});
app.use(cors());
app.use(attachUser);
app.use((_req, res, next) => {
  res.set('Cache-Control', 'public, max-age=30');
  next();
});

app.get('/health', async (_req, res) => {
  res.set('Cache-Control', 'no-store');
  let database = 'UP';
  let cache = redisClient ? 'UP' : 'DOWN';
  try {
    await prisma.$queryRaw`SELECT 1`;
  } catch {
    database = 'DOWN';
  }
  if (redisClient) {
    try {
      cache = (await redisClient.ping()) === 'PONG' ? 'UP' : 'DOWN';
    } catch {
      cache = 'DOWN';
    }
  }
  const status = database === 'UP' ? 'UP' : 'DOWN';
  res.status(status === 'UP' ? 200 : 503).json({
    status,
    service: 'streamapi',
    instance: INSTANCE,
    checks: { database, cache },
  });
});

app.get('/reels', async (req, res) => {
  const currentUserId = req.query.userId ? parseInt(req.query.userId, 10) : null;
  const sportFilter = req.query.sport;
  const page = parseInt(req.query.page, 10) || 1;
  const limit = parseInt(req.query.limit, 10) || 30;
  const skip = (page - 1) * limit;

  try {
    let mutedUserIds = [];
    let seenPostIds = [];
    if (currentUserId) {
      const [mutes, likes, ratings] = await Promise.all([
        prisma.mute.findMany({ where: { muterId: currentUserId, mutePosts: true }, select: { mutedId: true } }),
        prisma.like.findMany({ where: { userId: currentUserId }, select: { postId: true } }),
        prisma.rating.findMany({ where: { userId: currentUserId }, select: { postId: true } }),
      ]);
      mutedUserIds = mutes.map((mute) => mute.mutedId);
      seenPostIds = [...new Set([...likes.map((like) => like.postId), ...ratings.map((rating) => rating.postId)])];
    }

    const baseConditions = {
      isArchived: false,
      communityId: null,
      mediaType: 'VIDEO',
      userId: { notIn: mutedUserIds },
      user: {
        AND: [
          { blockedBy: { none: { blockerId: currentUserId || 0 } } },
          { blockedUsers: { none: { blockedId: currentUserId || 0 } } },
        ],
      },
    };
    if (sportFilter && sportFilter !== 'ALL' && sportFilter !== 'Tous') {
      baseConditions.sport = sportFilter;
    }

    let finalReels = [];
    if (currentUserId && page === 1) {
      const aiIds = await getAiRecommendations(currentUserId);
      if (aiIds && aiIds.length > 0) {
        const aiReels = await prisma.post.findMany({
          where: { ...baseConditions, id: { in: aiIds } },
          include: reelsInclude,
        });
        finalReels = aiIds.map((id) => aiReels.find((post) => post.id === id)).filter(Boolean);
      }
    }

    if (finalReels.length < limit) {
      const unseenReels = await prisma.post.findMany({
        where: {
          ...baseConditions,
          id: { notIn: [...finalReels.map((reel) => reel.id), ...seenPostIds] },
        },
        include: reelsInclude,
        take: limit - finalReels.length,
        skip,
        orderBy: { createdAt: 'desc' },
      });
      finalReels = [...finalReels, ...unseenReels];
    }

    if (finalReels.length < limit && seenPostIds.length > 0) {
      const seenFiller = await prisma.post.findMany({
        where: {
          ...baseConditions,
          id: { in: seenPostIds, notIn: finalReels.map((reel) => reel.id) },
        },
        include: reelsInclude,
        take: limit - finalReels.length,
        orderBy: { createdAt: 'asc' },
      });
      finalReels = [...finalReels, ...seenFiller];
    }

    res.json(finalReels.map((reel) => presentReel(reel, currentUserId)));
  } catch (error) {
    console.error('GET /reels failed:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.get('/reels/:id', async (req, res) => {
  const postId = parseInt(req.params.id, 10);
  const currentUserId = req.query.userId ? parseInt(req.query.userId, 10) : null;
  try {
    const reel = await prisma.post.findUnique({
      where: { id: postId },
      include: reelsInclude,
    });
    if (!reel) return res.status(404).json({ error: 'Reel introuvable' });
    res.json(presentReel(reel, currentUserId));
  } catch (error) {
    console.error('GET /reels/:id failed:', error);
    res.status(500).json({ error: 'Erreur serveur' });
  }
});

app.use((_req, res) => res.status(404).json({ error: 'Route not found', service: 'streamapi' }));

app.listen(PORT, '0.0.0.0', () => {
  console.log(JSON.stringify({ message: 'Reels stream API listening', port: PORT, instance: INSTANCE }));
});
