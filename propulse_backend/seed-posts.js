// seed-posts.js
// Ajoute 50 posts réalistes dans Neon, liés aux users existants
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// ═══════════════════════════════════════════════════════
// 🖼️ CATALOGUE D'IMAGES (Pexels - gratuites)
// ═══════════════════════════════════════════════════════
const IMAGES = [
  'https://images.pexels.com/photos/40136696/pexels-photo-40136696.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/31783554/pexels-photo-31783554.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/30899009/pexels-photo-30899009.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/17595273/pexels-photo-17595273.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/12600444/pexels-photo-12600444.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/32600343/pexels-photo-32600343.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/32101293/pexels-photo-32101293.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/38011351/pexels-photo-38011351.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/33827014/pexels-photo-33827014.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/260447/pexels-photo-260447.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/7045552/pexels-photo-7045552.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/1263426/pexels-photo-1263426.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/6740764/pexels-photo-6740764.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/260598/pexels-photo-260598.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/274506/pexels-photo-274506.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/114296/pexels-photo-114296.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/364308/pexels-photo-364308.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/1263348/pexels-photo-1263348.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/7045551/pexels-photo-7045551.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/2872871/pexels-photo-2872871.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/1595385/pexels-photo-1595385.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/863988/pexels-photo-863988.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/28054/pexels-photo-28054.jpg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/1171084/pexels-photo-1171084.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/1267315/pexels-photo-1267315.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/6077802/pexels-photo-6077802.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/1459518/pexels-photo-1459518.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/8287143/pexels-photo-8287143.jpeg?auto=compress&cs=tinysrgb&h=900',
  'https://images.pexels.com/photos/3757942/pexels-photo-3757942.jpeg?auto=compress&cs=tinysrgb&h=900',
];

// ═══════════════════════════════════════════════════════
// 🎬 CATALOGUE DE VIDÉOS (Google sample bucket)
// ═══════════════════════════════════════════════════════
const VIDEOS = [
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    poster: 'https://images.pexels.com/photos/32600343/pexels-photo-32600343.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    poster: 'https://images.pexels.com/photos/32101293/pexels-photo-32101293.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    poster: 'https://images.pexels.com/photos/38011351/pexels-photo-38011351.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    poster: 'https://images.pexels.com/photos/33827014/pexels-photo-33827014.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    poster: 'https://images.pexels.com/photos/12600444/pexels-photo-12600444.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    poster: 'https://images.pexels.com/photos/17595273/pexels-photo-17595273.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
];

// ═══════════════════════════════════════════════════════
// 📝 CAPTIONS + TAGS par sport
// ═══════════════════════════════════════════════════════
const CAPTIONS_BY_SPORT = {
  football: [
    'Le travail paie toujours ⚽️',
    'Séance du jour terminée 💪',
    'Objectif atteint ✅',
    'Technique, vitesse, mental 🧠',
    'Sprint final avant la reprise 🏃',
    'Le ballon rond, ma passion ⚽️',
    'On lâche rien 💯',
    'Fier de représenter mon club 💙',
    'Top 10 buts de la semaine 🎯',
    'Match de quartier, ambiance de fou 🔥',
  ],
  basketball: [
    'Session street ball 🏀',
    'Le geste se répète jusqu\'à la perfection 🎯',
    'Crochet fixe + finish au cercle 🔥',
    'Rien sans travail ⚒️',
    'Training day 💪',
    'Focus, discipline, results 🏀',
    'Chaque tir compte 🎯',
    'Ready for the game 🔥',
  ],
  volleyball: [
    'Smash du jour 🏐',
    'Service puissant ⚡',
    'Travail de réception 🎯',
    'Belle victoire d\'équipe 🏆',
    'Volley, ma passion 🏐',
  ],
  handball: [
    'Séance de tirs 🤾',
    'Défense solide aujourd\'hui 💪',
    'Hand, ma passion 🤾‍♂️',
    'Objectif championnat 🏆',
  ],
  default: [
    'Entraînement du jour 💪',
    'Toujours plus haut 🚀',
    'Discipline & focus',
    'Objectif : progresser',
    'Passion & persévérance',
  ],
};

const TAGS_BY_SPORT = {
  football: ['football', 'propulse', 'sport'],
  basketball: ['basketball', 'hoops', 'propulse'],
  volleyball: ['volleyball', 'propulse', 'sport'],
  handball: ['handball', 'propulse', 'sport'],
  default: ['sport', 'propulse'],
};

const LOCATIONS = [
  'Stade de France, Paris',
  'Playground Pigalle',
  'Iron Gym, Lyon',
  'Allianz Riviera, Nice',
  'Centre Sportif, Marseille',
  'Gymnase Calmette',
  'Parc des Princes',
  'CrossFit Box, Toulouse',
  'Stade Vélodrome',
  'Dakar Arena',
  'Stade Iba Mar Diop',
  'Complexe Léopold Sédar Senghor',
];

const SPORTS = ['football', 'basketball', 'volleyball', 'handball'];

// ═══════════════════════════════════════════════════════
// 🎲 HELPERS
// ═══════════════════════════════════════════════════════
const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
const randInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
const formatCount = (n) => (n >= 1000 ? `${(n / 1000).toFixed(1)}k` : String(n));

// ═══════════════════════════════════════════════════════
// 🚀 SCRIPT PRINCIPAL
// ═══════════════════════════════════════════════════════
async function main() {
  console.log('\n╔══════════════════════════════════════════╗');
  console.log('║  📸 SEED POSTS - Ajout de 50 posts        ║');
  console.log('╚══════════════════════════════════════════╝\n');

  // 1. Récupérer les users existants (joueurs seulement)
  const users = await prisma.user.findMany({
    where: { role: 'joueur' },
    select: { id: true, fullName: true, sport: true, city: true },
  });

  if (users.length === 0) {
    console.error('❌ Aucun user trouvé. Lance d\'abord seed-test-users.js');
    process.exit(1);
  }

  console.log(`✅ ${users.length} users trouvés\n`);

  // ═══════════════════════════════════════════════════════
  // 2. NETTOYAGE COMPLET (enfants → parents)
  // ═══════════════════════════════════════════════════════
  console.log('🧹 Nettoyage des posts et de leurs dépendances...');

  await prisma.kudos.deleteMany({});
  await prisma.ratingLike.deleteMany({});
  await prisma.rating.deleteMany({});
  await prisma.like.deleteMany({});
  await prisma.savedPost.deleteMany({});
  await prisma.hiddenPost.deleteMany({});
  await prisma.report.deleteMany({ where: { postId: { not: null } } });
  await prisma.notification.deleteMany({ where: { postId: { not: null } } });
  await prisma.postMention.deleteMany({});
  await prisma.postMedia.deleteMany({});
  await prisma.pollVote.deleteMany({});
  await prisma.userPostView.deleteMany({});

  await prisma.post.deleteMany({});
  console.log('✅ Posts et dépendances nettoyés\n');

  // 3. Créer 50 posts
  console.log('📸 Création de 50 posts...');
  const POSTS_COUNT = 50;
  const created = [];

  for (let i = 0; i < POSTS_COUNT; i++) {
    const author = pick(users);
    const sport = author.sport || pick(SPORTS);
    const captions = CAPTIONS_BY_SPORT[sport] || CAPTIONS_BY_SPORT.default;
    const caption = pick(captions);
    const tags = (TAGS_BY_SPORT[sport] || TAGS_BY_SPORT.default).join(',');

    const isVideo = Math.random() < 0.4;

    let imageUrl, mediaType, width, height, thumbnailUrl;

    if (isVideo) {
      const video = pick(VIDEOS);
      imageUrl = video.src;
      thumbnailUrl = video.poster;
      mediaType = 'VIDEO';
      width = 1080;
      height = 1350;
    } else {
      imageUrl = pick(IMAGES);
      mediaType = 'IMAGE';
      width = 1080;
      height = 1350;
    }

    try {
      const post = await prisma.post.create({
        data: {
          userId: author.id,
          imageUrl,
          thumbnailUrl: thumbnailUrl || null,
          description: caption,
          tags,
          sport,
          location: author.city || pick(LOCATIONS),
          width,
          height,
          mediaType,
          views: randInt(50, 12000),
        },
      });
      created.push(post);

      if ((i + 1) % 10 === 0) {
        console.log(`   ✓ ${i + 1}/${POSTS_COUNT} posts créés`);
      }
    } catch (e) {
      console.error(`   ✗ Erreur post ${i + 1}:`, e.message);
    }
  }

  console.log(`\n✅ ${created.length} posts créés\n`);

  // 4. Résumé
  console.log('╔══════════════════════════════════════════╗');
  console.log('║  ✅ SEED POSTS TERMINÉ                    ║');
  console.log('╚══════════════════════════════════════════╝\n');
  console.log(`📊 Total en BDD : ${await prisma.post.count()} posts`);
  console.log(`👥 Users : ${await prisma.user.count()}\n`);

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error('❌ Erreur fatale :', e);
  process.exit(1);
});