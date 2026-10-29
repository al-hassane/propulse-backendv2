// seed-data/names.js
// 100 noms réalistes (Sénégal / France / mix)

const firstNamesM = [
  "Moussa", "Ousmane", "Kalidou", "Sadio", "Édouard", "Idrissa", "Cheikhou",
  "Boulaye", "Ismaïla", "Nicolas", "Antoine", "Lucas", "Karim", "Youssouf",
  "Amadou", "Ibrahima", "Pape", "Mamadou", "Abdou", "Cheikh", "Modou",
  "Souleymane", "Aliou", "Babacar", "Lamine", "Sidy", "Malick", "Fodé",
  "Théo", "Rayan", "Enzo", "Nathan", "Hugo", "Léo", "Gabriel", "Raphaël",
  "Adam", "Noah", "Jules", "Louis", "Arthur", "Ethan", "Mathis", "Tom",
];

const firstNamesF = [
  "Aïssatou", "Fatou", "Mariama", "Khady", "Ndèye", "Awa", "Coumba",
  "Sokhna", "Adama", "Bineta", "Rokhaya", "Seynabou", "Astou", "Dieynaba",
  "Sophie", "Camille", "Léa", "Emma", "Chloé", "Manon", "Inès", "Sarah",
  "Louise", "Jade", "Alice", "Lina", "Rose", "Anna", "Mila", "Ambre",
];

const lastNames = [
  "Diop", "Ndiaye", "Fall", "Sow", "Ba", "Diallo", "Sarr", "Gueye",
  "Faye", "Mbaye", "Cissé", "Camara", "Toure", "Keita", "Traoré",
  "Sylla", "Barry", "Bah", "Kone", "Doumbia", "Sané", "Mendy",
  "Niang", "Diatta", "Coly", "Badji", "Dieng", "Diouf", "Seck",
  "Dubois", "Martin", "Bernard", "Petit", "Robert", "Richard",
  "Durand", "Moreau", "Laurent", "Simon", "Michel", "Leroy",
  "Roux", "David", "Bertrand", "Morel", "Girard", "Bonnet",
];

const sports = [
  { sport: "football",     positions: ["Attaquant", "Milieu", "Défenseur", "Gardien", "Ailier"] },
  { sport: "basketball",   positions: ["Meneur", "Arrière", "Ailier", "Ailier Fort", "Pivot"] },
  { sport: "volleyball",   positions: ["Passeur", "Réceptionneur", "Pointu", "Central", "Libéro"] },
  { sport: "handball",     positions: ["Gardien", "Ailier", "Arrière", "Demi-centre", "Pivot"] },
];

const cities = [
  "Dakar", "Thiès", "Saint-Louis", "Touba", "Mbour", "Kaolack",
  "Ziguinchor", "Rufisque", "Pikine", "Guédiawaye", "Diourbel",
  "Louga", "Tambacounda", "Kolda", "Matam", "Paris", "Lyon",
  "Marseille", "Bordeaux", "Lille", "Toulouse", "Nantes",
];

const clubs = [
  "ASC Jaraaf", "ASC Diaraf", "US Gorée", "Casa Sports", "AS Douanes",
  "ASC Niarry Tally", "Teungueth FC", "Génération Foot", "AS Pikine",
  "Paris SG", "OM", "OL", "AS Monaco", "Real Madrid", "FC Barcelone",
  null, null, null, // 30% sans club
];

const bios = [
  "Passionné de foot depuis toujours ⚽️",
  "Toujours prêt à progresser 💪",
  "Le sport c'est la vie 🔥",
  "En quête du haut niveau 🌟",
  "Objectif : passer pro 🏆",
  "Joueur de mon quartier, rêve de plus grand",
  "Discipline & travail 🇸🇳",
  "Aime la compétition et les défis",
  "Chaque entraînement compte",
  "Fier de mes racines, ambitieux pour demain",
];

// Helpers
const pick = (arr) => arr[Math.floor(Math.random() * arr.length)];
const randInt = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;

// Génère un user déterministe basé sur l'index
function generateUser(index) {
  const isFemale = index % 3 === 0; // ~33% femmes
  const firstName = isFemale ? pick(firstNamesF) : pick(firstNamesM);
  const lastName = pick(lastNames);
  const fullName = `${firstName} ${lastName}`;
  const sportData = pick(sports);
  const sport = sportData.sport;
  const position = pick(sportData.positions);
  const city = pick(cities);
  const club = pick(clubs);
  const bio = pick(bios);

  return {
    fullName,
    firstName,
    lastName,
    email: `user${index}@propulse-test.sn`,
    password: "Test1234!", // Sera hashé
    role: "joueur",
    sport,
    position,
    city,
    country: "Sénégal",
    club,
    bio,
    avatarUrl: `https://i.pravatar.cc/400?u=user${index}`,
    coverUrl: `https://picsum.photos/seed/cover${index}/1200/400`,
    xp: randInt(0, 5000),
    level: randInt(1, 30),
    isVerified: index % 7 === 0, // 1/7 certifiés
    isEmailVerified: true,
    latitude: 14.6928 + (Math.random() - 0.5) * 0.5, // Autour de Dakar
    longitude: -17.4467 + (Math.random() - 0.5) * 0.5,
    acceptedTermsAt: new Date(),
    username: `${firstName.toLowerCase()}${randInt(10, 99)}`,
  };
}

// Export des 100 users
const USERS = Array.from({ length: 100 }, (_, i) => generateUser(i + 1));

module.exports = { USERS, pick, randInt };