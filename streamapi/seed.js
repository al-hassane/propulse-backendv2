// seed.js
// Script de seed ProPulse - Test avec Neon
// Usage:
//   node seed.js small    → 10 users, 10 posts
//   node seed.js          → 100 users, 50 posts (défaut)
//   node seed.js big      → 300 users, 500 posts

require("dotenv").config();
const { PrismaClient } = require("@prisma/client");
const bcrypt = require("bcrypt");
const { USERS, pick, randInt } = require("./seed-data/names");
const { generateCaption, generateComment, generateScore } = require("./seed-data/captions");

const prisma = new PrismaClient();

// ==========================================
// CONFIGURATION DES MODES
// ==========================================
const MODES = {
  small:  { users: 10,  posts: 10,  likes: 50,   comments: 20,  follows: 30  },
  normal: { users: 100, posts: 50,  likes: 400,  comments: 150, follows: 300 },
  big:    { users: 300, posts: 500, likes: 5000, comments: 2000, follows: 3000 },
};

// ==========================================
// UTILITAIRES
// ==========================================
const log = {
  info: (msg) => console.log(`\x1b[36m[INFO]\x1b[0m ${msg}`),
  ok:   (msg) => console.log(`\x1b[32m[OK]\x1b[0m ${msg}`),
  warn: (msg) => console.log(`\x1b[33m[WARN]\x1b[0m ${msg}`),
  err:  (msg) => console.log(`\x1b[31m[ERR]\x1b[0m ${msg}`),
  step: (msg) => console.log(`\n\x1b[35m━━━ ${msg} ━━━\x1b[0m`),
};

// ==========================================
// 1. NETTOYAGE (IDEMPOTENT)
// ==========================================
async function cleanDatabase() {
  log.step("Nettoyage de la base");
  
  // Ordre critique : enfants → parents
  const tables = [
    "kudos",
    "pollVote",
    "ratingLike",
    "rating",
    "like",
    "savedPost",
    "hiddenPost",
    "report",
    "notification",
    "storySliderVote",
    "storyPollVote",
    "storySlider",
    "storyPoll",
    "storyComment",
    "storyLike",
    "storyFlame",
    "storyView",
    "storyMention",
    "story",
    "postMention",
    "postMedia",
    "post",
    "follow",
    "block",
    "mute",
    "profileView",
    "userPostView",
    "userBehavior",
    "suggestionDismiss",
    "share",
    "playerCertification",
    "certificationPayment",
    "cvPayment",
    "careerStep",
    "trophy",
    "careerTeaserInteraction",
    "eventParticipant",
    "eventPayout",
    "eventTicketPayment",
    "event",
    "targetPlayer",
    "communityRequest",
    "communityCertification",
    "community",
    "kudosPurchase",
    "kudosConversion",
    "propulseAdImpression",
    "propulseAdClick",
    "userSession",
    "broadcastView",
    "broadcast",
    "adminNotification",
    "newsReaction",
    "savedNews",
    "newsArticle",
    "savedStory",
    "contactMessage",
    "supportTicket",
    "storyAudioLike",
    "storyAudio",
    "searchHistory",
    "chatTab",
    "messageReaction",
    "messageDeletion",
    "messageReport",
    "message",
    "conversation",
    "trainingFeedback",
    "trainingTarget",
    "trainingReaction",
    "trainingSession",
    "proximityAlert",
    "duelVote",
    "duel",
    "systemConfig",
    "user",
  ];

  for (const t of tables) {
    try {
      // Utilise $executeRawUnsafe car certains modèles n'existent pas
      await prisma.$executeRawUnsafe(`TRUNCATE TABLE "${t}" RESTART IDENTITY CASCADE;`);
    } catch (e) {
      // Ignore les tables qui n'existent pas
    }
  }

  log.ok("Base vidée");
}

// ==========================================
// 2. CRÉATION DES USERS
// ==========================================
async function createUsers(count) {
  log.step(`Création de ${count} utilisateurs`);
  
  const hashedPassword = await bcrypt.hash("Test1234!", 10);
  const users = [];

  for (let i = 0; i < count; i++) {
    const userData = USERS[i];
    try {
      const user = await prisma.user.create({
        data: {
          fullName: userData.fullName,
          firstName: userData.firstName,
          lastName: userData.lastName,
          email: userData.email,
          password: hashedPassword,
          role: userData.role,
          sport: userData.sport,
          position: userData.position,
          city: userData.city,
          country: userData.country,
          club: userData.club,
          bio: userData.bio,
          avatarUrl: userData.avatarUrl,
          coverUrl: userData.coverUrl,
          xp: userData.xp,
          level: userData.level,
          isVerified: userData.isVerified,
          isEmailVerified: userData.isEmailVerified,
          latitude: userData.latitude,
          longitude: userData.longitude,
          acceptedTermsAt: userData.acceptedTermsAt,
          username: userData.username,
          // Champs obligatoires avec défauts
          kudosBalance: 15,
        },
      });
      users.push(user);
      
      if ((i + 1) % 10 === 0) {
        log.info(`${i + 1}/${count} users créés`);
      }
    } catch (e) {
      log.warn(`Skip user ${i + 1}: ${e.message}`);
    }
  }

  log.ok(`${users.length} users créés`);
  return users;
}

// ==========================================
// 3. CRÉATION DES POSTS
// ==========================================
async function createPosts(users, count) {
  log.step(`Création de ${count} posts`);
  
  const posts = [];

  for (let i = 0; i < count; i++) {
    const author = pick(users);
    const { caption, tags } = generateCaption(author.sport);
    
    // Image (picsum) ou vidéo placeholder (même image)
    const isVideo = Math.random() < 0.4; // 40% vidéos
    const seed = `post${i + 1}`;
    const imageUrl = isVideo
      ? `https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4`
      : `https://picsum.photos/seed/${seed}/1080/1350`;

    try {
      const post = await prisma.post.create({
        data: {
          userId: author.id,
          imageUrl,
          description: caption,
          tags,
          sport: author.sport,
          location: author.city,
          width: 1080,
          height: 1350,
          mediaType: isVideo ? "VIDEO" : "IMAGE",
          views: randInt(10, 5000),
        },
      });
      posts.push(post);
      
      if ((i + 1) % 10 === 0) {
        log.info(`${i + 1}/${count} posts créés`);
      }
    } catch (e) {
      log.warn(`Skip post ${i + 1}: ${e.message}`);
    }
  }

  log.ok(`${posts.length} posts créés`);
  return posts;
}

// ==========================================
// 4. CRÉATION DES LIKES
// ==========================================
async function createLikes(users, posts, count) {
  log.step(`Création de ${count} likes`);
  
  let created = 0;
  const usedPairs = new Set(); // Éviter les doublons

  for (let i = 0; i < count; i++) {
    const user = pick(users);
    const post = pick(posts);
    
    const key = `${user.id}-${post.id}`;
    if (usedPairs.has(key)) continue;
    usedPairs.add(key);

    try {
      await prisma.like.create({
        data: { userId: user.id, postId: post.id },
      });
      created++;
    } catch (e) {
      // Doublon ignoré
    }
  }

  log.ok(`${created} likes créés`);
}

// ==========================================
// 5. CRÉATION DES COMMENTAIRES (RATINGS)
// ==========================================
async function createComments(users, posts, count) {
  log.step(`Création de ${count} commentaires`);
  
  let created = 0;

  for (let i = 0; i < count; i++) {
    const user = pick(users);
    const post = pick(posts);

    try {
      await prisma.rating.create({
        data: {
          userId: user.id,
          postId: post.id,
          score: generateScore(),
          comment: generateComment(),
        },
      });
      created++;
    } catch (e) {
      // Ignore
    }
  }

  log.ok(`${created} commentaires créés`);
}

// ==========================================
// 6. CRÉATION DES FOLLOWS
// ==========================================
async function createFollows(users, count) {
  log.step(`Création de ${count} follows`);
  
  let created = 0;
  const usedPairs = new Set();

  for (let i = 0; i < count; i++) {
    const follower = pick(users);
    const following = pick(users);
    
    if (follower.id === following.id) continue;
    
    const key = `${follower.id}-${following.id}`;
    if (usedPairs.has(key)) continue;
    usedPairs.add(key);

    try {
      await prisma.follow.create({
        data: {
          followerId: follower.id,
          followingId: following.id,
          status: "ACCEPTED",
          notifLevel: "ALL",
        },
      });
      created++;
    } catch (e) {
      // Ignore
    }
  }

  log.ok(`${created} follows créés`);
}

// ==========================================
// 7. CRÉATION DES KUDOS
// ==========================================
async function createKudos(users, posts, count) {
  log.step(`Création de ${count} kudos`);
  
  const tiers = ["bronze", "argent", "or", "couronne", "diamant"];
  const costs = { bronze: 1, argent: 3, or: 5, couronne: 50, diamant: 30 };
  let created = 0;
  const usedPairs = new Set();

  for (let i = 0; i < count; i++) {
    const user = pick(users);
    const post = pick(posts);
    
    if (user.id === post.userId) continue; // Pas de kudos à soi-même
    
    const key = `${user.id}-${post.id}`;
    if (usedPairs.has(key)) continue;
    usedPairs.add(key);

    const tier = pick(tiers);

    try {
      await prisma.kudos.create({
        data: {
          userId: user.id,
          postId: post.id,
          tier,
          cost: costs[tier],
        },
      });
      created++;
    } catch (e) {
      // Ignore
    }
  }

  log.ok(`${created} kudos créés`);
}

// ==========================================
// FONCTION PRINCIPALE
// ==========================================
async function main() {
  const mode = process.argv[2] || "normal";
  const config = MODES[mode];

  if (!config) {
    log.err(`Mode inconnu : "${mode}". Utilise : small | normal | big`);
    process.exit(1);
  }

  console.log("\n╔══════════════════════════════════════════╗");
  console.log(`║  🌱 SEED PROPPULSE - Mode: ${mode.padEnd(16)} ║`);
  console.log("╚══════════════════════════════════════════╝\n");

  log.info(`Database: ${process.env.DATABASE_URL?.substring(0, 60)}...`);

  const startTime = Date.now();

  try {
    // 1. Nettoyer
    await cleanDatabase();

    // 2. Créer les users
    const users = await createUsers(config.users);
    if (users.length === 0) throw new Error("Aucun user créé");

    // 3. Créer les posts
    const posts = await createPosts(users, config.posts);

    // 4. Créer les interactions
    await createLikes(users, posts, config.likes);
    await createComments(users, posts, config.comments);
    await createFollows(users, config.follows);
    await createKudos(users, posts, Math.min(50, config.likes));

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log("\n╔══════════════════════════════════════════╗");
    console.log(`║  ✅ SEED TERMINÉ en ${duration.padEnd(20)}s ║`);
    console.log("╚══════════════════════════════════════════╝\n");

    log.ok(`Total: ${users.length} users, ${posts.length} posts`);
    log.info(`Vérifie avec: npx prisma studio\n`);

  } catch (e) {
    log.err(`Erreur fatale: ${e.message}`);
    console.error(e);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

main();