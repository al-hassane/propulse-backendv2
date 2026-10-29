// clean-now.js
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function clean() {
  console.log("🧹 Nettoyage manuel en cours...");
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  const deleted = await prisma.userBehavior.deleteMany({
    where: {
      createdAt: { lt: thirtyDaysAgo }
    }
  });

  console.log(`✅ Terminé ! ${deleted.count} lignes supprimées.`);
  process.exit();
}

clean();