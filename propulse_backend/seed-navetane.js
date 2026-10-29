const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("🚀 Début du remplissage des données Navétane...");

  // 1. Créer la Compétition
  const competition = await prisma.competition.create({
    data: {
      name: "Navétane ProPulse",
      year: "2026",
      season: "Saison Régulière",
    }
  });

  // 2. Créer la Région (Dakar)
  const region = await prisma.region.create({
    data: {
      name: "Dakar",
      competitionId: competition.id
    }
  });

  // 3. Créer le Département (Pikine)
  const dept = await prisma.department.create({
    data: {
      name: "Pikine",
      regionId: region.id
    }
  });

  // 4. Créer la Zone (Zone 1)
  const zone = await prisma.zone.create({
    data: {
      name: "Zone 1",
      departmentId: dept.id
    }
  });

  // 5. Créer les ASC (Équipes)
  const team1 = await prisma.asc.create({
    data: { name: "ASC Jeanne d'Arc", zoneId: zone.id, foundedIn: "1980" }
  });

  const team2 = await prisma.asc.create({
    data: { name: "ASC Wallidaan", zoneId: zone.id, foundedIn: "1985" }
  });

  const team3 = await prisma.asc.create({
    data: { name: "ASC Jaraaf", zoneId: zone.id, foundedIn: "1975" }
  });

  const team4 = await prisma.asc.create({
    data: { name: "ASC Grand Yoff", zoneId: zone.id, foundedIn: "1992" }
  });

  // 6. Créer des Matchs
  // Match 1 : Terminé (2-1)
  await prisma.match.create({
    data: {
      date: new Date(),
      stadium: "Stade Alassane Djigo",
      status: "FINISHED",
      homeTeamId: team1.id,
      homeScore: 2,
      awayTeamId: team2.id,
      awayScore: 1,
      zoneId: zone.id
    }
  });

  // Match 2 : À venir (Demain)
  let tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  await prisma.match.create({
    data: {
      date: tomorrow,
      stadium: "Stade Amadou Barry",
      status: "SCHEDULED",
      homeTeamId: team3.id,
      awayTeamId: team4.id,
      zoneId: zone.id
    }
  });

  // 7. Initialiser le Classement (Standing)
  // On met team1 premier car il a gagné le match 1
  await prisma.standing.createMany({
    data: [
      { ascId: team1.id, zoneId: zone.id, played: 1, won: 1, points: 3, goalsFor: 2, goalsAgainst: 1 },
      { ascId: team2.id, zoneId: zone.id, played: 1, won: 0, points: 0, goalsFor: 1, goalsAgainst: 2 },
      { ascId: team3.id, zoneId: zone.id, played: 0, won: 0, points: 0 },
      { ascId: team4.id, zoneId: zone.id, played: 0, won: 0, points: 0 },
    ]
  });

  console.log("✅ Données de test Navétane Dakar injectées avec succès !");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
