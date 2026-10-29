const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("🧹 Nettoyage de la base de données...");
 
  // On supprime dans l'ordre pour éviter les erreurs de clés étrangères
  await prisma.standing.deleteMany({});
  await prisma.matchComment.deleteMany({});
  await prisma.match.deleteMany({});
  await prisma.asc.deleteMany({});
  await prisma.zone.deleteMany({});
  await prisma.department.deleteMany({});
  await prisma.region.deleteMany({});
  await prisma.competition.deleteMany({});

  console.log("✅ Base de données nettoyée.");

  console.log("🇸🇳 Remplissage de la hiérarchie Dakar Élite...");

  const competition = await prisma.competition.create({
    data: { name: "Navétane ProPulse", year: "2026", season: "Régulière" }
  });

  const region = await prisma.region.create({
    data: { name: "Dakar", competitionId: competition.id }
  });

  const dakarDepts = [
    { name: "Dakar Plateau", zones: ["Zone 1", "Zone 2", "Zone 3"] },
    { name: "Pikine", zones: ["Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5"] },
    { name: "Guédiawaye", zones: ["Zone A", "Zone B", "Zone C"] },
    { name: "Rufisque", zones: ["Zone Nord", "Zone Sud"] },
    { name: "Keur Massar", zones: ["Zone 1", "Zone 2", "Zone 3"] },
    { name: "Parcelles Assainies", zones: ["Zone 12", "Zone 13"] }
  ];

  for (const dept of dakarDepts) {
    const d = await prisma.department.create({
      data: { name: dept.name, regionId: region.id }
    });
   
    for (const zoneName of dept.zones) {
      await prisma.zone.create({
        data: { name: zoneName, departmentId: d.id }
      });
    }
  }

  console.log(`🚀 TERMINÉ : ${dakarDepts.length} départements et des dizaines de zones créés !`);
}

main().catch(console.error).finally(() => prisma.$disconnect());