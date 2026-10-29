const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("🧹 NETTOYAGE DES DONNÉES DE COMPÉTITION...");
 
  await prisma.matchComment.deleteMany({});
  await prisma.matchEvent.deleteMany({});
  await prisma.matchLineup.deleteMany({});
  await prisma.matchStats.deleteMany({});
  await prisma.standing.deleteMany({});
  await prisma.match.deleteMany({});
  await prisma.asc.deleteMany({});
  await prisma.zone.deleteMany({});
  await prisma.department.deleteMany({});
  await prisma.region.deleteMany({});
  await prisma.competition.deleteMany({});

  console.log("👤 PRÉPARATION DE L'UTILISATEUR TEST...");
  const testUser = await prisma.user.upsert({
    where: { email: "fan@propulse.sn" },
    update: {},
    create: {
      fullName: "Supporter ProPulse",
      email: "fan@propulse.sn",
      password: "password123",
      role: "joueur",
      sport: "football"
    }
  });

  console.log("🇸🇳 CRÉATION DE LA HIÉRARCHIE COMPLÈTE DE DAKAR...");
  const competition = await prisma.competition.create({
    data: { name: "Navétane ProPulse", year: "2026", season: "Régulière" }
  });

  const region = await prisma.region.create({
    data: { name: "Dakar", competitionId: competition.id }
  });

  const dakarStructure = [
    { name: "Dakar Plateau", zones: ["Zone 1", "Zone 2", "Zone 3"] },
    { name: "Pikine", zones: ["Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5"] },
    { name: "Guédiawaye", zones: ["Zone A", "Zone B", "Zone C"] },
    { name: "Rufisque", zones: ["Zone Nord", "Zone Sud", "Zone Est", "Zone Ouest"] },
    { name: "Keur Massar", zones: ["Zone 1", "Zone 2", "Zone 3"] },
    { name: "Parcelles Assainies", zones: ["Zone 12", "Zone 13"] }
  ];

  let savedZoneNordId = null;

  for (const deptData of dakarStructure) {
    const dept = await prisma.department.create({
      data: { name: deptData.name, regionId: region.id }
    });
    for (const zoneName of deptData.zones) {
      const zone = await prisma.zone.create({
        data: { name: zoneName, departmentId: dept.id }
      });
      if (deptData.name === "Rufisque" && zoneName === "Zone Nord") {
        savedZoneNordId = zone.id;
      }
    }
  }

  console.log("⚽️ INJECTION DES ÉQUIPES POULE A...");
  const walidane = await prisma.asc.create({ data: { name: "ASC Walidane", logo: null, zoneId: savedZoneNordId } });
  const mbollo = await prisma.asc.create({ data: { name: "ASC Mbollo", logo: null, zoneId: savedZoneNordId } });
  const medine = await prisma.asc.create({ data: { name: "ASC Médine", logo: null, zoneId: savedZoneNordId } });
  const jad = await prisma.asc.create({ data: { name: "ASC JAD", logo: null, zoneId: savedZoneNordId } });

  console.log("🏁 MATCH 1 : TERMINÉ (MÉDINE VS JAD)...");
  await prisma.match.create({
    data: {
      date: new Date(Date.now() - 172800000), // Il y a 2 jours
      stadium: "Stade Ngalandou Diouf",
      status: "FINISHED",
      homeTeamId: medine.id,
      awayTeamId: jad.id,
      homeScore: 2,
      awayScore: 0,
      zoneId: savedZoneNordId,
      stats: {
        create: {
          homePossession: 52, awayPossession: 48,
          homeShots: 10, awayShots: 4,
          homeOnTarget: 4, awayOnTarget: 1,
          homeCorners: 3, awayCorners: 2
        }
      },
      events: {
        create: [
          { type: "GOAL", minute: 15, playerName: "A. Gomis", teamId: medine.id },
          { type: "GOAL", minute: 78, playerName: "M. Ndiaye", teamId: medine.id },
          { type: "YELLOW_CARD", minute: 40, playerName: "S. Mane", teamId: jad.id }
        ]
      }
    }
  });

  // --- NOUVEAU MATCH POUR LES STATS ---
  console.log("🏁 MATCH 3 : TERMINÉ (WALIDANE VS JAD)...");
  await prisma.match.create({
    data: {
      date: new Date(Date.now() - 86400000), // Hier
      stadium: "Terrain Santhiaba",
      status: "FINISHED",
      homeTeamId: walidane.id,
      awayTeamId: jad.id,
      homeScore: 3,
      awayScore: 1,
      zoneId: savedZoneNordId,
      stats: {
        create: {
          homePossession: 60, awayPossession: 40,
          homeShots: 18, awayShots: 7,
          homeOnTarget: 9, awayOnTarget: 3,
          homeCorners: 8, awayCorners: 1
        }
      },
      events: {
        create: [
          { type: "GOAL", minute: 10, playerName: "Nicolas Jackson", teamId: walidane.id },
          { type: "GOAL", minute: 34, playerName: "Sadio Mané", teamId: walidane.id },
          { type: "GOAL", minute: 60, playerName: "B. Sarr", teamId: jad.id },
          { type: "GOAL", minute: 88, playerName: "Ismaila Sarr", teamId: walidane.id }
        ]
      }
    }
  });

  // --- NOUVEAU MATCH POUR LES STATS ---
  console.log("🏁 MATCH 4 : TERMINÉ (MBOLLO VS MÉDINE)...");
  await prisma.match.create({
    data: {
      date: new Date(Date.now() - 259200000), // Il y a 3 jours
      stadium: "Stade Ngalandou Diouf",
      status: "FINISHED",
      homeTeamId: mbollo.id,
      awayTeamId: medine.id,
      homeScore: 1,
      awayScore: 1,
      zoneId: savedZoneNordId,
      stats: {
        create: {
          homePossession: 45, awayPossession: 55,
          homeShots: 8, awayShots: 12,
          homeOnTarget: 4, awayOnTarget: 5,
          homeCorners: 2, awayCorners: 6
        }
      },
      events: {
        create: [
          { type: "GOAL", minute: 44, playerName: "Boulaye Dia", teamId: mbollo.id },
          { type: "GOAL", minute: 70, playerName: "A. Gomis", teamId: medine.id }
        ]
      }
    }
  });

  console.log("🔥 MATCH 2 : LIVE ÉLITE (WALIDANE VS MBOLLO)...");
  await prisma.match.create({
    data: {
      date: new Date(),
      stadium: "Terrain Santhiaba",
      status: "LIVE",
      homeTeamId: walidane.id,
      awayTeamId: mbollo.id,
      homeScore: 1,
      awayScore: 1,
      zoneId: savedZoneNordId,
      stats: {
        create: {
          homePossession: 55, awayPossession: 45,
          homeShots: 14, awayShots: 9,
          homeOnTarget: 6, awayOnTarget: 4,
          homeCorners: 5, awayCorners: 3
        }
      },
      lineups: {
        create: [
          // WALIDANE (11 Titulaires + 8 Remplaçants)
          { playerName: "Oumar Sène", number: 1, posX: 50, posY: 92, teamId: walidane.id, isStarter: true },
          { playerName: "Moussa Fall", number: 2, posX: 85, posY: 80, teamId: walidane.id, isStarter: true },
          { playerName: "Baye Diop", number: 4, posX: 65, posY: 82, teamId: walidane.id, isStarter: true },
          { playerName: "Abdoulaye Seck", number: 5, posX: 35, posY: 82, teamId: walidane.id, isStarter: true },
          { playerName: "Modou Gueye", number: 3, posX: 15, posY: 80, teamId: walidane.id, isStarter: true },
          { playerName: "Pape Matar", number: 6, posX: 50, posY: 70, teamId: walidane.id, isStarter: true },
          { playerName: "Idrissa Gana", number: 8, posX: 70, posY: 66, teamId: walidane.id, isStarter: true },
          { playerName: "Cheikhou Kouyate", number: 10, posX: 30, posY: 66, teamId: walidane.id, isStarter: true },
          { playerName: "Ismaila Sarr", number: 7, posX: 80, posY: 56, teamId: walidane.id, isStarter: true },
          { playerName: "Nicolas Jackson", number: 9, posX: 50, posY: 55, teamId: walidane.id, isStarter: true },
          { playerName: "Sadio Mané", number: 11, posX: 20, posY: 56, teamId: walidane.id, isStarter: true },
          { playerName: "S. Dieng", number: 16, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "F. Mendy", number: 17, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "K. Koulibaly", number: 18, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "P. Gueye", number: 19, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "N. Mendy", number: 20, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "L. Camara", number: 21, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "I. Sarr", number: 22, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },
          { playerName: "B. Dia", number: 23, posX: 0, posY: 0, teamId: walidane.id, isStarter: false },

          // MBOLLO (11 Titulaires + 8 Remplaçants) sa donne une postion co,plet
          { playerName: "Edouard Mendy", number: 1, posX: 50, posY: 8, teamId: mbollo.id, isStarter: true },
          { playerName: "Kalidou K.", number: 3, posX: 35, posY: 18, teamId: mbollo.id, isStarter: true },
          { playerName: "Abdou Diallo", number: 4, posX: 65, posY: 18, teamId: mbollo.id, isStarter: true },
          { playerName: "Youssouf Sabaly", number: 2, posX: 15, posY: 20, teamId: mbollo.id, isStarter: true },
          { playerName: "Fodé Ballo", number: 5, posX: 85, posY: 20, teamId: mbollo.id, isStarter: true },
          { playerName: "Gana Gueye", number: 6, posX: 50, posY: 30, teamId: mbollo.id, isStarter: true },
          { playerName: "Pape Sarr", number: 8, posX: 30, posY: 34, teamId: mbollo.id, isStarter: true },
          { playerName: "Lamine C.", number: 11, posX: 70, posY: 34, teamId: mbollo.id, isStarter: true },
          { playerName: "Boulaye Dia", number: 9, posX: 50, posY: 45, teamId: mbollo.id, isStarter: true },
          { playerName: "Habib Diallo", number: 10, posX: 20, posY: 44, teamId: mbollo.id, isStarter: true },
          { playerName: "Iliman Ndiaye", number: 7, posX: 80, posY: 44, teamId: mbollo.id, isStarter: true },
          { playerName: "M. Name", number: 16, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "M. Loum", number: 17, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "I. Ciss", number: 18, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "B. Dieng", number: 19, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "F. Diedhiou", number: 20, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "S. Lopy", number: 21, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "A. Seck", number: 22, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
          { playerName: "M. Niakhate", number: 23, posX: 0, posY: 0, teamId: mbollo.id, isStarter: false },
        ]
      },
      events: {
        create: [
          { type: "GOAL", minute: 22, playerName: "Nicolas Jackson", teamId: walidane.id },
          { type: "YELLOW_CARD", minute: 40, playerName: "Baye Diop", teamId: walidane.id },
          { type: "GOAL", minute: 55, playerName: "Boulaye Dia", teamId: mbollo.id },
          { type: "YELLOW_CARD", minute: 72, playerName: "Gana Gueye", teamId: mbollo.id },
          { type: "YELLOW_CARD", minute: 89, playerName: "Nicolas Jackson", teamId: walidane.id },
        ]
      },
      liveChat: {
        create: [
          { text: "Match de feu à Rufisque ! 🔥", userId: testUser.id },
          { text: "Walidane joue très bien tactiquement", userId: testUser.id },
          { text: "L'arbitre laisse un peu trop jouer...", userId: testUser.id },
          { text: "Mbollo va pousser en fin de match !", userId: testUser.id },
          { text: "Quel arrêt de Edouard Mendy !!! 🧤", userId: testUser.id },
          { text: "Est-ce qu'il y aura des prolongations ?", userId: testUser.id },
          { text: "Le public de Rufisque est incroyable", userId: testUser.id },
          { text: "ProPulse Live c'est du lourd ! 🇸🇳", userId: testUser.id },
        ]
      }
    }
  });

  console.log("📊 MISE À JOUR DU CLASSEMENT (COHÉRENT AVEC LES MATCHES TERMINÉS)...");
  await prisma.standing.createMany({
    data: [
      // Médine : 1 Win (M1) + 1 Draw (M4) = 4 Pts
      { ascId: medine.id, zoneId: savedZoneNordId, played: 2, won: 1, drawn: 1, lost: 0, points: 4, goalsFor: 3, goalsAgainst: 1 },
      // Walidane : 1 Win (M3) = 3 Pts (M2 en live ne compte pas encore)
      { ascId: walidane.id, zoneId: savedZoneNordId, played: 1, won: 1, drawn: 0, lost: 0, points: 3, goalsFor: 3, goalsAgainst: 1 },
      // Mbollo : 1 Draw (M4) = 1 Pt
      { ascId: mbollo.id, zoneId: savedZoneNordId, played: 1, won: 0, drawn: 1, lost: 0, points: 1, goalsFor: 1, goalsAgainst: 1 },
      // JAD : 2 Losses (M1, M3) = 0 Pts
      { ascId: jad.id, zoneId: savedZoneNordId, played: 2, won: 0, drawn: 0, lost: 2, points: 0, goalsFor: 1, goalsAgainst: 5 },
    ]
  });

  console.log("🚀 MISSION RÉUSSIE : Tout est prêt avec des statistiques riches !");
}

main().catch(console.error).finally(() => prisma.$disconnect());