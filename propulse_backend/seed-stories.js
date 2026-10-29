// seed-stories.js
// Crée 20 stories réalistes dans Neon
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// ═══════════════════════════════════════════════════════
// 📸 IMAGES Pexels (sport, lifestyle, paysages)
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
  'https://images.pexels.com/photos/1263426/pexels-photo-1263426.jpeg?auto=compress&cs=tinysrgb&h=900',
];

const VIDEOS = [
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    poster: 'https://images.pexels.com/photos/32600343/pexels-photo-32600343.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
  {
    src: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    poster: 'https://images.pexels.com/photos/32101293/pexels-photo-32101293.jpeg?auto=compress&cs=tinysrgb&h=900',
  },
];

// ═══════════════════════════════════════════════════════
// 📝 CAPTIONS
// ═══════════════════════════════════════════════════════
const CAPTIONS = [
  'Journée parfaite pour s\'entraîner 🔥',
  'Le travail paie toujours 💪',
  'Objectif atteint ✅ On continue !',
  'Ambiance de fou aujourd\'hui ⚽️',
  'Séance terminée, prêt pour la suite 🏃',
  'Technique + mental = victoire 🧠',
  'On lâche rien 💯',
  'Merci à tous pour le soutien 🙏',
  'Vibes positives uniquement ✨',
  'On progresse chaque jour 📈',
];

const TEXT_CONTENTS = [
  'Bonjour tout le monde 👋',
  'Objectif du jour : TOP 10',
  'Question sérieuse en dessous 👇',
  'Ce soir c\'est match 🔥',
  'Nouveau record ce matin ⚡',
];

const POLLS = [
  { q: 'Tu penses que je vais gagner ?', a: 'OUI 🔥', b: 'NON 😅' },
  { q: 'Match ce soir ?', a: 'Je regarde', b: 'Je dors' },
  { q: 'Mon niveau actuel ?', a: 'TOP', b: 'À améliorer' },
];

const SLIDERS = [
  { emoji: '🔥', q: 'Note ma séance' },
  { emoji: '💪', q: 'Mon niveau ce mois-ci' },
  { emoji: '⚽️', q: 'Prêt pour le prochain match ?' },
];

const BACKGROUNDS = [
  ['#00c6ff', '#0072ff'],
  ['#ff6b9d', '#ff3b30'],
  ['#ffd700', '#ff8c00'],
  ['#8a3ab9', '#4a148c'],
  ['#34c759', '#0e7c3a'],
];

const FONT_STYLES = ['classic', 'modern', 'neon', 'luxury', 'elegant'];

// ═══════════════════════════════════════════════════════
// 🎲 HELPERS
// ═══════════════════════════════════════════════════════
const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
const randInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

// ═══════════════════════════════════════════════════════
// 🚀 SCRIPT PRINCIPAL
// ═══════════════════════════════════════════════════════
async function main() {
  console.log('\n╔══════════════════════════════════════════╗');
  console.log('║  📸 SEED STORIES - 20 stories réalistes    ║');
  console.log('╚══════════════════════════════════════════╝\n');

  // 1. Récupérer les users existants
  const users = await prisma.user.findMany({
    where: { role: { in: ['joueur', 'coach', 'manager', 'autres'] } },
    select: { id: true, fullName: true, avatarUrl: true },
    take: 50,
  });

  if (users.length === 0) {
    console.error('❌ Aucun user trouvé. Lance d\'abord seed-test-users.js');
    process.exit(1);
  }

  console.log(`✅ ${users.length} users disponibles\n`);

  // 2. Récupérer les sons si disponibles (optionnel)
  const audios = await prisma.storyAudio.findMany({
    where: { isPublic: true },
    take: 5,
    select: { id: true, title: true, duration: true },
  });
  console.log(`🎵 ${audios.length} sons disponibles\n`);

  // 3. Nettoyer les stories existantes
  console.log('🧹 Nettoyage des stories existantes...');
  await prisma.storyPollVote.deleteMany({});
  await prisma.storySliderVote.deleteMany({});
  await prisma.storyPoll.deleteMany({});
  await prisma.storySlider.deleteMany({});
  await prisma.storyComment.deleteMany({});
  await prisma.storyLike.deleteMany({});
  await prisma.storyFlame.deleteMany({});
  await prisma.storyView.deleteMany({});
  await prisma.storyMention.deleteMany({});
  await prisma.savedStory.deleteMany({});
  await prisma.story.deleteMany({});
  console.log('✅ Stories nettoyées\n');

  // 4. Créer les 20 stories
  console.log('📸 Création des stories...\n');
  const created = [];

  // Plan : 6 image simple, 3 image+texte, 3 image+sondage, 3 image+slider, 3 texte pur, 2 vidéo
  const plan = [
    ...Array(6).fill('image'),
    ...Array(3).fill('image+text'),
    ...Array(3).fill('image+poll'),
    ...Array(3).fill('image+slider'),
    ...Array(3).fill('text'),
    ...Array(2).fill('video'),
  ];

  for (let i = 0; i < 20; i++) {
    const kind = plan[i];
    const author = pick(users);
    const createdAt = new Date(Date.now() - randInt(0, 6) * 60 * 60 * 1000); // entre 0 et 6h
    const expiresAt = new Date(createdAt.getTime() + 24 * 60 * 60 * 1000);

    // Musique (1 chance sur 3 si dispo)
    const storyAudioId = audios.length > 0 && Math.random() < 0.33
      ? pick(audios).id
      : null;

    let type = 'IMAGE';
    let mediaUrl = null;
    let content = null;
    let background = null;
    let fontStyle = 'classic';
    let textColor = '#FFFFFF';
    let textScale = '1';
    let textOffsetX = '0';
    let textOffsetY = '0';

    let pollData = null;
    let sliderData = null;

    if (kind === 'image') {
      mediaUrl = pick(IMAGES);
      content = pick(CAPTIONS);
    } 
    else if (kind === 'image+text') {
      mediaUrl = pick(IMAGES);
      content = pick(TEXT_CONTENTS);
      fontStyle = pick(FONT_STYLES);
      textScale = (randInt(80, 120) / 100).toString();
      textOffsetY = randInt(-100, 100).toString();
    } 
    else if (kind === 'image+poll') {
      mediaUrl = pick(IMAGES);
      content = pick(CAPTIONS);
      const poll = pick(POLLS);
      pollData = {
        question: poll.q,
        optionA: poll.a,
        optionB: poll.b,
        x: 0,
        y: 100,
        scale: 1,
        rotation: 0,
      };
    } 
    else if (kind === 'image+slider') {
      mediaUrl = pick(IMAGES);
      content = pick(CAPTIONS);
      const slider = pick(SLIDERS);
      sliderData = {
        emoji: slider.emoji,
        question: slider.q,
        x: 0,
        y: 100,
        scale: 1,
        rotation: 0,
      };
    } 
    else if (kind === 'text') {
      type = 'TEXT';
      content = pick(TEXT_CONTENTS);
      const bg = pick(BACKGROUNDS);
      background = bg.join(',');
      fontStyle = pick(FONT_STYLES);
      textColor = Math.random() < 0.5 ? '#FFFFFF' : '#000000';
    } 
    else if (kind === 'video') {
      const video = pick(VIDEOS);
      type = 'VIDEO';
      mediaUrl = video.src;
      content = pick(CAPTIONS);
    }

    try {
      const story = await prisma.story.create({
        data: {
          userId: author.id,
          type,
          mediaUrl,
          content,
          background,
          fontStyle,
          textColor,
          textScale,
          textOffsetX,
          textOffsetY,
          storyAudioId,
          expiresAt,
          createdAt,
          mediaBgMode: 'blur',
          mediaBgColor: '#000000',
          mediaScale: '1',
          mediaOffsetX: '0',
          mediaOffsetY: '0',
        },
      });

      // Sondage
      if (pollData) {
        await prisma.storyPoll.create({
          data: {
            storyId: story.id,
            question: pollData.question,
            optionA: pollData.optionA,
            optionB: pollData.optionB,
            x: pollData.x,
            y: pollData.y,
            scale: pollData.scale,
            rotation: pollData.rotation,
          },
        });
      }

      // Slider
      if (sliderData) {
        await prisma.storySlider.create({
          data: {
            storyId: story.id,
            emoji: sliderData.emoji,
            question: sliderData.question,
            x: sliderData.x,
            y: sliderData.y,
            scale: sliderData.scale,
            rotation: sliderData.rotation,
          },
        });
      }

      created.push(story);
      console.log(`   ✓ #${i + 1} [${kind}] → ${author.fullName}`);
    } catch (e) {
      console.error(`   ✗ Erreur story ${i + 1}:`, e.message);
    }
  }

  // 5. Résumé
  console.log('\n╔══════════════════════════════════════════╗');
  console.log('║  ✅ SEED STORIES TERMINÉ                  ║');
  console.log('╚══════════════════════════════════════════╝\n');
  console.log(`📊 Total : ${created.length} stories créées`);
  console.log(`🎁 Sondages : ${await prisma.storyPoll.count()}`);
  console.log(`🎚️ Sliders : ${await prisma.storySlider.count()}`);
  console.log(`\n💡 Test : ouvre le web, clique sur une story dans la barre du haut\n`);

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error('❌ Erreur fatale :', e);
  process.exit(1);
});