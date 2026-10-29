const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("🧹 Début du nettoyage profond...");

  // 1. Récupérer les IDs de tous les comptes de test
  const testUsers = await prisma.user.findMany({
    where: {
      OR: [
        { email: { endsWith: '@propulse-community.sn' } },
        { email: { endsWith: '@propulse-seed.sn' } }
      ]
    },
    select: { id: true }
  });

  const testIds = testUsers.map(u => u.id);

  if (testIds.length === 0) {
    console.log("ℹ️ Aucun compte de test trouvé.");
    return;
  }

  console.log(`⚠️ ${testIds.length} comptes identifiés. Nettoyage des dépendances...`);

  try {
    // 2. Suppression manuelle dans l'ordre pour éviter les erreurs de clé étrangère
    await prisma.$transaction([
      // Supprimer les relations de suivi (Follow)
      prisma.follow.deleteMany({
        where: {
          OR: [
            { followerId: { in: testIds } },
            { followingId: { in: testIds } }
          ]
        }
      }),
      // Supprimer les notifications liées
      prisma.notification.deleteMany({
        where: {
          OR: [
            { senderId: { in: testIds } },
            { receiverId: { in: testIds } }
          ]
        }
      }),
      // Supprimer les likes
      prisma.like.deleteMany({
        where: { userId: { in: testIds } }
      }),
      // Supprimer les blocs
      prisma.block.deleteMany({
        where: {
          OR: [
            { blockerId: { in: testIds } },
            { blockedId: { in: testIds } }
          ]
        }
      }),
      // Enfin, supprimer les utilisateurs
      prisma.user.deleteMany({
        where: { id: { in: testIds } }
      })
    ]);

    console.log(`✅ Succès ! ${testIds.length} utilisateurs et toutes leurs interactions ont été supprimés.`);
  } catch (error) {
    console.error("❌ Erreur lors de la transaction de nettoyage :", error);
  }
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });