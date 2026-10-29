require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
    console.log("🚀 Recherche des utilisateurs sans code de parrainage...");

    // 1. FILTRE : On ne prend QUE ceux qui n'ont rien (null ou vide)
    const usersToUpdate = await prisma.user.findMany({ 
        where: {
            OR: [
                { referralCode: null },
                { referralCode: "" }
            ]
        }
    });

    if (usersToUpdate.length === 0) {
        console.log("✅ Tous les utilisateurs ont déjà un code. Rien à faire !");
        return;
    }

    console.log(`🔍 ${usersToUpdate.length} utilisateurs à mettre à jour sur 158 au total.`);

    // 2. Fonction de traitement par lot (Batch) pour éviter de fatiguer la connexion Pour faire en sorte que sa marche bien 
    const chunkSize = 10; // On traite 10 par 10
    for (let i = 0; i < usersToUpdate.length; i += chunkSize) {
        const chunk = usersToUpdate.slice(i, i + chunkSize);
        
        await Promise.all(chunk.map(async (u) => {
            // Génération du code
            const firstName = u.fullName ? u.fullName.split(' ')[0] : "PROP";
            const prefix = firstName.toUpperCase().substring(0, 4);
            const randomDigits = Math.floor(1000 + Math.random() * 9000);
            const newCode = `${prefix}${randomDigits}`;

            try {
                await prisma.user.update({
                    where: { id: u.id },
                    data: { referralCode: newCode }
                });
            } catch (err) {
                console.error(`❌ Erreur pour ${u.fullName}:`, err.message);
            }
        }));

        console.log(`✅ Progression : ${i + chunk.length}/${usersToUpdate.length}`);
    }

    console.log("✨ Opération terminée avec succès !");
}

main()
  .catch((e) => console.error("❌ Erreur critique:", e))
  .finally(async () => {
      await prisma.$disconnect();
  });