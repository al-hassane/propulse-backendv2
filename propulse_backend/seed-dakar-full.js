const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("🇸🇳 Remplissage de tout Dakar...");

  // On récupère ou crée la compétition
  const competition = await prisma.competition.upsert({
    where: { id: 1 },
    update: {},
    create: { name: "Navétane ProPulse", year: "2026", season: "Régulière" }
  });

  const region = await prisma.region.create({
    data: { name: "Dakar", competitionId: competition.id }
  });

  const departments = [
    { name: "Dakar Plateau", zones: ["Zone 1", "Zone 2", "Zone 3"] },
    { name: "Pikine", zones: ["Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5"] },
    { name: "Guédiawaye", zones: ["Zone A", "Zone B", "Zone C"] },
    { name: "Rufisque", zones: ["Zone Nord", "Zone Sud"] },
    { name: "Keur Massar", zones: ["Zone 1", "Zone 2"] }
  ];

  for (const dept of departments) {
    const d = await prisma.department.create({
      data: { name: dept.name, regionId: region.id }
    });
    for (const zoneName of dept.zones) {
      await prisma.zone.create({
        data: { name: zoneName, departmentId: d.id }
      });
    }
  }

  console.log("✅ Dakar est maintenant complet avec 5 départements et 15 zones !");
}

main().catch(console.error).finally(() => prisma.$disconnect());