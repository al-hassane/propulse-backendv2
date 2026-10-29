// fix-avatars.js
require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

const NEW_DEFAULT = "https://d21bhgmu32o7ny.cloudfront.net/propulse_app/default-avatar.png";

async function fix() {
  console.log("🛠️ Mise à jour des profils vides...");
  
  const result = await prisma.user.updateMany({
    where: {
      OR: [
        { avatarUrl: null },
        { avatarUrl: "" },
        { avatarUrl: "https://d21bhgmu32o7ny.cloudfront.net/propulse_app/default-avatar.png"} // Optionnel : remplace aussi l'ancienne icône flaticon
      ]
    },
    data: {
      avatarUrl: NEW_DEFAULT
    }
  });

  console.log(`✅ Terminé ! ${result.count} utilisateurs mis à jour.`);
}

fix()
  .catch(e => console.error(e))
  .finally(() => prisma.$disconnect());