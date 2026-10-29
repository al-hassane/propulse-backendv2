// seed-test-users.js
// Crée 5 users de test pour valider le flow d'auth web
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

const PASSWORD = 'Test1234!';

const TEST_USERS = [
  {
    fullName: 'Moussa Sport',
    email: 'joueur.sport@propulse-test.sn',
    username: 'moussa',
    role: 'joueur',
    sport: 'football',
    position: 'Attaquant',
    city: 'Dakar',
  },
  {
    fullName: 'Fatou Sans Sport',
    email: 'joueur.sans-sport@propulse-test.sn',
    username: 'fatou',
    role: 'joueur',
    sport: null, // ← Important : pas de sport
    position: null,
    city: 'Thiès',
  },
  {
    fullName: 'Karim Coach',
    email: 'coach@propulse-test.sn',
    username: 'karim',
    role: 'coach',
    sport: null, // ← Le coach doit aussi choisir son sport
    city: 'Saint-Louis',
  },
  {
    fullName: 'Sofia Manager',
    email: 'manager@propulse-test.sn',
    username: 'sofia',
    role: 'manager',
    sport: null,
    isManagerVerified: false, // ← Doit passer par onboarding
    city: 'Dakar',
  },
  {
    fullName: 'Amadou Autre',
    email: 'autre@propulse-test.sn',
    username: 'amadou',
    role: 'autres', // ← Doit passer par select-other-type
    sport: null,
    city: 'Mbour',
  },
];

async function main() {
  console.log('\n╔══════════════════════════════════════════╗');
  console.log('║  🧪 SEED TEST USERS - Auth Flow Web       ║');
  console.log('╚══════════════════════════════════════════╝\n');

  const hashedPassword = await bcrypt.hash(PASSWORD, 10);

  for (const userData of TEST_USERS) {
    try {
      // On supprime d'abord si existe (pour idempotence)
      await prisma.user.deleteMany({
        where: { email: userData.email },
      });

      const user = await prisma.user.create({
        data: {
          ...userData,
          password: hashedPassword,
          isEmailVerified: true, // ✅ CRUCIAL : évite la vérification email
          isVerified: false,
          xp: 0,
          level: 1,
          kudosBalance: 15,
          avatarUrl: `https://i.pravatar.cc/400?u=${userData.username}`,
          coverUrl: `https://picsum.photos/seed/${userData.username}/1200/400`,
          acceptedTermsAt: new Date(),
          country: 'Sénégal',
          latitude: 14.6928,
          longitude: -17.4467,
        },
      });

      console.log(`✅ ${userData.role.padEnd(8)} → ${userData.email}`);
    } catch (e) {
      console.error(`❌ Erreur pour ${userData.email}:`, e.message);
    }
  }

  console.log('\n╔══════════════════════════════════════════╗');
  console.log('║  ✅ TOUS LES COMPTES DE TEST CRÉÉS       ║');
  console.log('╚══════════════════════════════════════════╝\n');

  console.log('📋 Comptes disponibles (password: Test1234!) :\n');
  TEST_USERS.forEach((u) => {
    console.log(`   📧 ${u.email.padEnd(40)} → rôle: ${u.role}`);
  });

  console.log('\n🎯 Scénarios à tester après login :\n');
  console.log('   1. joueur.sport         → 🏠 Feed direct');
  console.log('   2. joueur.sans-sport    → ⚽ /select-sport');
  console.log('   3. coach                → ⚽ /select-sport');
  console.log('   4. manager              → 💼 /manager-onboarding');
  console.log('   5. autre                → 🎙️ /select-other-type\n');

  await prisma.$disconnect();
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});