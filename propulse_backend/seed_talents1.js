const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const prisma = new PrismaClient();

async function main() {
  console.log("🚀 Lancement du Grand Seeding ProPulse : 600 Talents & Coachs...");

  const password = await bcrypt.hash('password123', 10);

  // DATES : 19, 20 et 21 Janvier 2026
  const dates = [
    new Date('2026-01-19T10:00:00'),
    new Date('2026-01-20T10:00:00'),
    new Date('2026-01-21T10:00:00')
  ];

  const firstNames = {
    senegal: ["Moussa", "Ibrahima", "Cheikh", "Modou", "Samba", "Abdoulaye", "Ousmane", "Babacar", "Lamine", "Pape", "Idrissa", "Boubacar", "Moustapha", "Amadou", "Sidy", "Kalidou", "Sadio", "Edouard", "Mame", "Aliou", "Mamadou", "El Hadji", "Birane", "Souleymane", "Maguette", "Assane", "Mor", "Serigne", "Massamba", "Mbaye"],
    international: ["James", "Lucas", "Raphael", "David", "Michael", "Kevin", "Thomas", "Daniel", "Paul", "Victor", "Alexander", "Marco", "Luis", "Carlos", "Jean", "Pierre", "Mohamed", "Youssef", "Ibrahim", "John", "Christopher", "Matthew", "Andrew", "Joshua", "Brandon", "Ryan", "Nicholas", "Jonathan", "Stephen", "Anthony"]
  };
  
  const lastNames = {
    senegal: ["Ndiaye", "Diop", "Fall", "Gueye", "Faye", "Diallo", "Sarr", "Sow", "Kane", "Thiam", "Ba", "Cissé", "Camara", "Wade", "Dramé", "Mendy", "Touré", "Sy", "Diagne", "Mbaye", "Seck", "Niang", "Diouf", "Beye", "Ndour", "Diatta", "Coly", "Sagna", "Gassama"],
    international: ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Walker", "Hall", "Young", "King", "Wright", "Scott", "Green", "Adams", "Baker"]
  };

  const sportsData = {
    football: { positions: ["Attaquant", "Milieu", "Défenseur", "Gardien"], strongFoot: ["Droit", "Gauche", "Ambidextre"] },
    basketball: { positions: ["Meneur", "Arrière", "Ailier", "Ailier Fort", "Pivot"], strongFoot: null },
    handball: { positions: ["Gardien", "Ailier", "Arrière", "Demi-centre", "Pivot"], strongFoot: null },
    volleyball: { positions: ["Passeur", "Réceptionneur", "Pointu", "Central", "Libéro"], strongFoot: null }
  };

  const getRandom = (arr) => arr[Math.floor(Math.random() * arr.length)];
  const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

  const getRandomTime = (date) => {
    const newDate = new Date(date);
    newDate.setHours(getRandomInt(8, 22), getRandomInt(0, 59), getRandomInt(0, 59));
    return newDate;
  };

  const bioTemplates = [
    "🎯 Objectif {goal} dans les {timeline} mois. {motivation}",
    "⚡ Spécialisé dans {skill}, j'ai une vision de jeu hors norme. Prêt à relever de nouveaux défis !",
    "🌟 Révélation {year}, espoir prometteur. Vitesse {speed}/10, Technique {technique}/10.",
    "🧠 Joueur/Coach intelligent avec QI Sport {iq}/100. Discipline et rigueur.",
    "💪 Né pour travailler dur. Premier arrivé, dernier parti. La réussite est au bout de l'effort.",
    "📊 Dernière saison : {goals} buts/victoires, {assists} passes décisives. Ratio : {ratio}%."
  ];

  const generateSmartBio = (sport, role) => {
    const template = getRandom(bioTemplates);
    const replacements = {
      goal: getRandom(["le haut niveau", "signer pro", "gagner le championnat", "former les élites"]),
      timeline: getRandom([6, 12, 24]),
      motivation: getRandom(["L'échec n'est pas une option.", "Le travail paie toujours.", "Rêver plus grand."]),
      skill: getRandom(["la tactique", "le dribble", "la finition", "le leadership"]),
      year: 2025,
      speed: getRandomInt(7, 10),
      technique: getRandomInt(7, 10),
      iq: getRandomInt(80, 98),
      goals: getRandomInt(5, 25),
      assists: getRandomInt(2, 15),
      ratio: getRandomInt(70, 95)
    };
    let bio = template.replace(/{(\w+)}/g, (_, key) => replacements[key]);
    if(role === 'coach') bio = "👨‍🏫 Coach passionné. " + bio;
    return bio;
  };

  const createdUserIds = [];

  console.log("👥 Phase 1 : Création des 600 profils...");

  for (let i = 0; i < 600; i++) {
    const isSenegalese = Math.random() < 0.6;
    const fName = getRandom(isSenegalese ? firstNames.senegal : firstNames.international);
    const lName = getRandom(isSenegalese ? lastNames.senegal : lastNames.international);
    const role = Math.random() < 0.15 ? 'coach' : 'joueur'; // 15% de coachs
    const sport = getRandom(Object.keys(sportsData));
    const position = getRandom(sportsData[sport].positions);
    
    const email = `${fName.toLowerCase()}.${lName.toLowerCase()}${i}${getRandomInt(1, 999)}@propulse-community.sn`;
    const username = `${fName.toLowerCase()}${lName.toLowerCase().substring(0,3)}${i}`;

    // Répartition sur les 3 jours (200 par jour environ)
    const baseDate = dates[Math.floor(i / 200)];
    const createdAt = getRandomTime(baseDate);

    const user = await prisma.user.create({
      data: {
        fullName: `${fName} ${lName}`,
        username: username,
        email: email,
        password: password,
        role: role,
        sport: sport,
        position: position,
        level: 1,
        xp: getRandomInt(0, 150),
        isVerified: false, // Force False
        isEmailVerified: true,
        bio: generateSmartBio(sport, role),
        club: null, // Aucun club
        ascId: null, // Aucun lien ASC
        strongFoot: sportsData[sport].strongFoot ? getRandom(sportsData[sport].strongFoot) : null,
        height: getRandomInt(165, 205),
        weight: getRandomInt(60, 95),
        createdAt: createdAt
      }
    });

    createdUserIds.push(user.id);
    if ((i + 1) % 100 === 0) console.log(`✅ ${i + 1}/600 utilisateurs créés.`);
  }

  console.log("\n🤝 Phase 2 : Génération des interactions sociales (Follows)...");

  for (const userId of createdUserIds) {
    // Chaque utilisateur suit entre 2 et 45 personnes (mélange aléatoire < 50)
    const followCount = getRandomInt(2, 45);
    
    // Mélanger les IDs pour choisir des cibles au hasard
    const shuffled = [...createdUserIds]
      .filter(id => id !== userId) // Ne pas se suivre soi-même
      .sort(() => 0.5 - Math.random());
    
    const targets = shuffled.slice(0, followCount);

    // Création massive des follows pour cet utilisateur
    await prisma.follow.createMany({
      data: targets.map(targetId => ({
        followerId: userId,
        followingId: targetId,
        status: 'ACCEPTED',
        notifLevel: 'CUSTOM'
      })),
      skipDuplicates: true
    });
  }

  console.log("\n" + "=".repeat(50));
  console.log("✨ SEEDING DE 600 UTILISATEURS TERMINÉ ✨");
  console.log(`📅 Période : 19 Janvier - 21 Janvier 2026`);
  console.log(`👤 Rôles : Joueurs & Coachs`);
  console.log(`❌ Clubs : AUCUN (null)`);
  console.log(`✅ Vérification : TOUS à False`);
  console.log(`🔗 Interactions : Follows aléatoires générés (< 50/pers)`);
  console.log("=".repeat(50));
}

main()
  .catch((e) => {
    console.error("❌ Erreur:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });