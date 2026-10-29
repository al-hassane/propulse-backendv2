// seed-data/captions.js
// 60 captions sportives en français

const CAPTIONS_FOOTBALL = [
  "Séance du jour terminée 💪⚽️",
  "Objectif atteint ✅ On continue !",
  "Le travail paie toujours 🌟",
  "Sprint final avant la reprise 🏃‍♂️",
  "Technique, vitesse, mental 🧠⚡️",
  "Toujours là pour progresser 🔥",
  "Match de quartier, ambiance de ouf 😎",
  "Nouveau record perso aujourd'hui 🏆",
  "Merci à mes coéquipiers 🙏",
  "Rien sans travail ⚒️",
  "Fier de représenter mon club 💙",
  "Le ballon rond, ma passion ⚽️",
  "Séance de finition 🎯",
  "Toujours plus haut 🚀",
  "On lâche rien 💯",
];

const CAPTIONS_BASKET = [
  "Séance de shoots 🏀",
  "Travail de dribble aujourd'hui ⚡️",
  "Le panier n'a qu'à bien se tenir 🎯",
  "Match serré mais victoire ! 🏆",
  "Mental de champion 💪🏀",
  "Rien ne remplace le travail 🛠️",
  "Prêt pour le prochain match 🔥",
  "Merci pour le soutien 🙏🏀",
];

const CAPTIONS_VOLLEY = [
  "Smash du jour 🏐",
  "Séance de service 🔥",
  "Belle victoire d'équipe 🏆",
  "Travail de réception 🎯",
  "Le volley, c'est la vie 🏐",
];

const CAPTIONS_HAND = [
  "Séance de tirs 🤾",
  "Défense solide aujourd'hui 💪",
  "Le hand, ma passion 🤾‍♂️",
  "Objectif championnat 🏆",
];

const CAPTIONS_MOTIVATION = [
  "Le succès, c'est la somme de petits efforts quotidiens",
  "Chaque jour est une nouvelle chance",
  "Ne jamais abandonner 💯",
  "La discipline bat le talent",
  "Rêve grand, travaille dur",
  "Aujourd'hui mieux qu'hier 🚀",
  "Rien de grand ne se fait sans effort",
  "Sois la meilleure version de toi-même 🌟",
];

const TAGS_BY_SPORT = {
  football:   ["football", "foot", "soccer", "propulse", "talent"],
  basketball: ["basketball", "basket", "hoops", "propulse", "talent"],
  volleyball: ["volleyball", "volley", "smash", "propulse", "talent"],
  handball:   ["handball", "hand", "propulse", "talent"],
};

const { pick, randInt } = require("./names");

// Génère une caption cohérente avec le sport
function generateCaption(sport) {
  let pool;
  switch (sport) {
    case "basketball": pool = CAPTIONS_BASKET; break;
    case "volleyball": pool = CAPTIONS_VOLLEY; break;
    case "handball":   pool = CAPTIONS_HAND;   break;
    default:           pool = CAPTIONS_FOOTBALL; break;
  }
  // 25% de chance d'avoir une caption motivation
  if (Math.random() < 0.25) pool = CAPTIONS_MOTIVATION;
  
  const caption = pick(pool);
  const tagsPool = TAGS_BY_SPORT[sport] || TAGS_BY_SPORT.football;
  
  // 2-3 tags aléatoires
  const numTags = randInt(2, 3);
  const shuffled = [...tagsPool].sort(() => Math.random() - 0.5);
  const tags = shuffled.slice(0, numTags).join(",");
  
  return { caption, tags };
}

// Génère un commentaire court
function generateComment() {
  const comments = [
    "Trop fort 🔥", "Belle séance 💪", "Continue comme ça ⚽️",
    "Respect 🙏", "Félicitations 🏆", "Ça promet !",
    "Magnifique 👏", "Tu vas y arriver 🚀", "Excellent travail",
    "Waw 😍", "Top 🔝", "Impressionnant", "Cool 😎",
    "Let's go !", "Félicitations champion", "Bien joué 👊",
  ];
  return pick(comments);
}

// Note aléatoire entre 6 et 10
function generateScore() {
  return randInt(6, 10);
}

module.exports = { generateCaption, generateComment, generateScore };