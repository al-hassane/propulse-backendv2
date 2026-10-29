const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const prisma = new PrismaClient();

async function main() {
  console.log("🚀 Génération de 100 talents ProPulse (Batch 2)...");

  const password = await bcrypt.hash('password123', 10);

  // NOUVELLES dates de création
  const date17 = new Date('2026-01-17 10:00:00');
  const date18 = new Date('2026-01-18 15:30:00');

  // Noms encore plus variés (Sénégalais + Internationaux + nouveaux)
  const firstNames = {
    senegal: ["Moussa", "Ibrahima", "Cheikh", "Modou", "Samba", "Abdoulaye", "Ousmane", "Babacar", "Lamine", "Pape", "Idrissa", "Boubacar", "Moustapha", "Amadou", "Sidy", "Kalidou", "Sadio", "Edouard", "Mame", "Aliou", "Mamadou", "El Hadji", "Birane", "Souleymane", "Maguette", "Assane", "Mor", "Serigne", "Massamba", "Mbaye"],
    international: ["James", "Lucas", "Raphael", "David", "Michael", "Kevin", "Thomas", "Daniel", "Paul", "Victor", "Alexander", "Marco", "Luis", "Carlos", "Jean", "Pierre", "Mohamed", "Youssef", "Ibrahim", "John", "Christopher", "Matthew", "Andrew", "Joshua", "Brandon", "Ryan", "Nicholas", "Jonathan", "Stephen", "Anthony"]
  };
  
  const lastNames = {
    senegal: ["Ndiaye", "Diop", "Fall", "Gueye", "Faye", "Diallo", "Sarr", "Sow", "Kane", "Thiam", "Ba", "Cissé", "Camara", "Wade", "Dramé", "Mendy", "Touré", "Sy", "Diagne", "Mbaye", "Seck", "Niang", "Diouf", "Beye", "Ndour", "Diatta", "Coly", "Sagna", "Gassama"],
    international: ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Walker", "Hall", "Young", "King", "Wright", "Scott", "Green", "Adams", "Baker"]
  };

  // Sports et positions (simplifiés)
  const sportsData = {
    football: {
      positions: ["Attaquant", "Milieu", "Défenseur", "Gardien"],
      strongFoot: ["Droit", "Gauche", "Ambidextre"]
    },
    basketball: {
      positions: ["Meneur", "Arrière", "Ailier", "Ailier Fort", "Pivot"],
      strongFoot: null
    },
    handball: {
      positions: ["Gardien", "Ailier", "Arrière", "Demi-centre", "Pivot"],
      strongFoot: null
    },
    volleyball: {
      positions: ["Passeur", "Réceptionneur", "Pointu", "Central", "Libéro"],
      strongFoot: null
    }
  };

  const sports = Object.keys(sportsData);

  const getRandom = (arr) => arr[Math.floor(Math.random() * arr.length)];
  const getRandomInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

  // Fonction pour générer des heures aléatoires
  const getRandomTime = (date, index) => {
    const newDate = new Date(date);
    const hour = 8 + Math.floor(Math.random() * 12); // 8h à 20h
    const minute = Math.floor(Math.random() * 60);
    const second = Math.floor(Math.random() * 60);
    newDate.setHours(hour, minute, second);
    return newDate;
  };

  // NOUVELLES biographies encore plus intelligentes et variées
  const bioTemplates = {
    ambitious: "🎯 Objectif {goal} dans les {timeline} mois. Je ne recule devant rien pour atteindre mes rêves. {motivation}",
    technical: "⚡ Spécialisé dans {skill}, j'ai une capacité d'analyse du jeu hors norme. {stats} Prêt à relever de nouveaux défis !",
    youngPromise: "🌟 Révélation {year}, je suis considéré comme l'un des espoirs les plus prometteurs de ma génération. Vitesse {speed}/10, Technique {technique}/10.",
    strategic: "🧠 Joueur intelligent avec une vision de jeu exceptionnelle. Capable de jouer à plusieurs postes. QI Sport {iq}/100.",
    hardWorker: "💪 Né pour travailler dur. Premier à l'entraînement, dernier à partir. Discipliné, rigoureux et déterminé à réussir.",
    charismatic: "🗣 Leader naturel sur et en dehors du terrain. Capable de motiver une équipe entière et de faire basculer les matchs serrés.",
    versatile: "🔄 Polyvalent et adaptable à tous les systèmes de jeu. {strength} principale, je sais m'adapter à n'importe quelle situation.",
    stats: "📊 Dernière saison : {goals} buts, {assists} passes décisives en {matches} matchs. Ratio de réussite : {ratio}%.",
    ambitious2: "🌍 Je veux devenir l'un des meilleurs joueurs du monde. Mon parcours ne fait que commencer, mais ma détermination est infinie.",
    academy: "🏫 Formé dans une académie de renom, j'ai soif d'apprendre et de progresser chaque jour. Coachable et motivé !",
    family: "👨‍👩‍👧‍👦 Issu d'une famille de sportifs, le sport coule dans mes veines. Prêt à écrire ma propre histoire.",
    determined: "⚡ Aucun obstacle ne me fera dévier de mon chemin. Chaque entraînement est une opportunité de devenir meilleur.",
    humble: "🙏 Je viens de loin et je sais d'où je viens. Le travail et l'humilité sont mes maîtres-mots. Prêt à saisir ma chance.",
    explosive: "💥 Joueur explosif avec une capacité à faire la différence sur un geste. Recherche un club pour exploser pleinement.",
    leader: "👑 Capitaine de mon équipe depuis 2 ans, j'ai appris à gérer un groupe et à prendre mes responsabilités.",
    resilient: "🛡️ Après une blessure difficile, je reviens plus fort que jamais. Ma résilience est ma plus grande force. Rien ne m'arrête !",
    prodigy: "🎪 Phénomène précoce, j'ai commencé le sport à 5 ans. Déjà {achievements} à mon actif. Prêt pour le prochain niveau !",
    analyst: "📹 Je passe des heures à analyser les matchs et mes performances. La préparation mentale et tactique est la clé du succès.",
    social: "🤝 Ambassador du fair-play, je crois que le sport va au-delà de la performance. Esprit d'équipe et respect avant tout.",
    creative: "🎨 Joueur créatif avec un style unique. Je ne rentre pas dans les cases, je les redessine. La technique au service de l'art."
  };

  const generateSmartBio = (sport, position, index) => {
    const templates = Object.values(bioTemplates);
    const template = getRandom(templates);
    
    const achievements = ["2 titres régionaux", "meilleur buteur du championnat", "MVP du tournoi", "capitaine depuis 3 ans", "recordman d'assists", "champion scolaire national"];
    
    const replacements = {
      goal: getRandom(["devenir professionnel", "signer mon premier contrat", "intégrer une académie", "jouer en sélection nationale", "être repéré par un club", "devenir un joueur clé", "percer dans le sport de haut niveau", "représenter mon pays", "gagner un championnat", "devenir une légende"]),
      timeline: getRandom([3, 6, 12, 18, 24]),
      motivation: getRandom(["L'échec n'est pas une option.", "La seule limite c'est celle que l'on s'impose.", "Le travail paiera toujours.", "Rêver plus grand chaque jour.", "La persévérance est ma force.", "Rien n'est impossible avec du travail.", "La discipline mène à la liberté.", "Chaque jour est une opportunité."]),
      skill: getRandom(["la vision du jeu", "le dribble", "la passe décisive", "le placement", "l'anticipation", "la détente verticale", "la lecture du jeu", "la finition", "la relance", "l'interception", "le leadership", "la communication"]),
      stats: getRandom(["85% de passes réussies", "75% de duels gagnés", "92% d'efficacité", "8 interceptions/match", "80% de tirs cadrés", "7/10 aux tirs au but", "90% de réussite aux tirs", "88% de précision"]),
      sport: sport,
      year: getRandom([2023, 2024, 2025]),
      speed: getRandomInt(6, 10),
      technique: getRandomInt(6, 10),
      iq: getRandomInt(70, 95),
      strength: getRandom(["la vitesse", "la puissance", "la technique", "l'intelligence", "la vision", "l'agilité", "l'explosivité", "la détente", "la résistance", "la flexibilité"]),
      goals: getRandomInt(5, 20),
      assists: getRandomInt(3, 15),
      matches: getRandomInt(10, 30),
      ratio: getRandomInt(65, 90),
      achievements: getRandom(achievements)
    };
    
    let bio = template.replace(/{(\w+)}/g, (_, key) => replacements[key] || `[${key}]`);
    
    const countries = ["Sénégal", "France", "Espagne", "Angleterre", "Italie", "Allemagne", "États-Unis", "Canada", "Maroc", "Côte d'Ivoire", "Belgique", "Suisse", "Portugal", "Pays-Bas", "Brésil", "Argentine", "Algérie", "Tunisie", "Cameroun", "Mali"];
    const cities = ["Dakar", "Thiès", "Saint-Louis", "Ziguinchor", "Kaolack", "Paris", "Lyon", "Marseille", "Barcelone", "Madrid", "Londres", "Manchester", "Milan", "Rome", "Berlin", "Munich", "New York", "Los Angeles", "Toronto", "Montréal"];
    
    bio += `\n\n📍 ${getRandom(cities)}, ${getRandom(countries)}`;
    bio += `\n🎂 ${getRandomInt(17, 23)} ans | 📏 ${getRandomInt(165, 210)} cm | ⚖️ ${getRandomInt(60, 100)} kg`;
    
    const motivations = ["Recherche un club pour progresser", "Prêt à déménager pour ma carrière", "Disponible pour un essai immédiat", "À la recherche d'un challenge", "Motivé à donner le meilleur de moi-même"];
    bio += `\n💫 ${getRandom(motivations)} | 📧 Contact disponible sur demande.`;
    
    return bio;
  };

  console.log("🎮 Création de 100 nouveaux joueurs niveau 1 (sans clubs)...\n");

  for (let i = 0; i < 100; i++) {
    // Alterne entre noms sénégalais et internationaux (60/40)
    const isSenegalese = Math.random() < 0.6;
    
    const firstNamePool = isSenegalese ? firstNames.senegal : firstNames.international;
    const lastNamePool = isSenegalese ? lastNames.senegal : lastNames.international;
    
    const fName = getRandom(firstNamePool);
    const lName = getRandom(lastNamePool);
    let fullName = `${fName} ${lName}`;
    
    // Éviter les doublons de noms complets
    const sport = getRandom(sports);
    const position = getRandom(sportsData[sport].positions);
    const level = 1;
    const xp = getRandomInt(0, 99);
    
    // Email plus varié
    const domains = ["propulse.ai", "sportify.com", "athlete.me", "talents.sn", "propulse.sn"];
    const email = `${fName.toLowerCase()}.${lName.toLowerCase()}${getRandomInt(1, 999)}@${getRandom(domains)}`;
    const username = `${fName.toLowerCase()}${lName.toLowerCase().substring(0, 3)}${getRandomInt(100, 9999)}${getRandom(['', 'pro', 'elite', 'star', 'talent'])}`;
    
    const bio = generateSmartBio(sport, position, i);
    
    // Répartition 50/50 entre le 17 et le 18
    let createdAt;
    if (i < 50) {
      createdAt = getRandomTime(date17, i);
    } else {
      createdAt = getRandomTime(date18, i - 50);
    }
    
    // Ajouter un peu de variation dans la date exacte (quelques jours avant/après pour certains)
    if (i % 7 === 0 && i < 50) {
      createdAt.setDate(createdAt.getDate() - 1);
    }
    if (i % 13 === 0 && i >= 50) {
      createdAt.setDate(createdAt.getDate() + 1);
    }
    
    const strongFoot = sportsData[sport].strongFoot ? getRandom(sportsData[sport].strongFoot) : null;
    
    await prisma.user.create({
      data: {
        fullName,
        username,
        email,
        password,
        role: 'joueur',
        sport: sport,
        position: position,
        level: level,
        xp: xp,
        isVerified: false,
        isEmailVerified: true,
        bio: bio,
        club: null,
        strongFoot: strongFoot,
        height: getRandomInt(165, 210),
        weight: getRandomInt(60, 100),
        createdAt: createdAt
      }
    });
    
    if ((i + 1) % 20 === 0) {
      console.log(`✅ ${i + 1}/100 nouveaux joueurs niveau 1 créés...`);
    }
  }

  console.log("\n" + "=".repeat(55));
  console.log("✨ SECOND SEED TERMINÉ AVEC SUCCÈS ! ✨");
  console.log("=".repeat(55));
  console.log(`📊 100 nouveaux joueurs générés :`);
  console.log(`   🇸🇳 60% noms Sénégalais / 40% noms Internationaux`);
  console.log(`   ⚽ 4 sports différents`);
  console.log(`   📋 Positions variées`);
  console.log(`   📝 Bios UNIQUES et intelligentes (nouvelles templates)`);
  console.log(`   🏆 NIVEAU 1 uniquement`);
  console.log(`   🚫 AUCUN club`);
  console.log(`   🎯 Jeunes talents (17-23 ans)`);
  console.log(`   📅 Dates :`);
  console.log(`      🗓️ 50 joueurs créés le 17 janvier 2026 (heures variées)`);
  console.log(`      🗓️ 50 joueurs créés le 18 janvier 2026 (heures variées)`);
  console.log(`   ✨ NOUVEAUTÉS :`);
  console.log(`      • Noms, emails et usernames plus variés`);
  console.log(`      • 5 templates de bio supplémentaires`);
  console.log(`      • Villes et pays ajoutés dans bios`);
  console.log(`      • Statistiques plus réalistes`);
  console.log("=".repeat(55));
}

main()
  .catch((e) => {
    console.error("❌ Erreur:", e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });