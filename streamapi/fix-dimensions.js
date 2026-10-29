require('dotenv').config();
const { PrismaClient } = require('@prisma/client');
const cloudinary = require('cloudinary').v2;

const prisma = new PrismaClient();

// Configuration Cloudinary (utilise tes clés du .env)
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

// Fonction pour extraire le "Public ID" d'une URL Cloudinary
const getPublicId = (url) => {
  if (!url) return null;
  const parts = url.split('/');
  const lastPart = parts[parts.length - 1];
  const folder = "propulse_app/"; // Ton dossier Cloudinary
  const filename = lastPart.split('.')[0]; // On enlève l'extension (.mp4, .jpg)
  return folder + filename;
};

async function fixPosts() {
  console.log("🔍 Recherche des anciens posts sans dimensions...");

  try {
    // 1. On récupère tous les posts où width ou height est null
    const postsToFix = await prisma.post.findMany({
      where: {
        OR: [
          { width: null },
          { height: null }
        ]
      }
    });

    console.log(`📊 ${postsToFix.length} posts à corriger.`);

    for (let post of postsToFix) {
      const publicId = getPublicId(post.imageUrl);
      const isVideo = post.imageUrl.match(/\.(mp4|mov|avi|m4v)$/i);

      console.log(`⚙️ Traitement du post ID ${post.id} (${isVideo ? 'VIDÉO' : 'IMAGE'})...`);

      try {
        // 2. On demande les infos à Cloudinary
        // Attention : pour les vidéos, il faut préciser resource_type: 'video'
        const result = await cloudinary.api.resource(publicId, {
          resource_type: isVideo ? 'video' : 'image'
        });

        if (result && result.width && result.height) {
          // 3. On met à jour la base de données
          await prisma.post.update({
            where: { id: post.id },
            data: {
              width: result.width,
              height: result.height
            }
          });
          console.log(`✅ Mis à jour : ${result.width}x${result.height}`);
        }
      } catch (cloudErr) {
        console.error(`❌ Impossible de trouver le média sur Cloudinary pour l'ID ${post.id}`);
      }
    }

    console.log("🏁 Rattrapage terminé !");
  } catch (err) {
    console.error("❌ Erreur critique script:", err);
  } finally {
    await prisma.$disconnect();
    process.exit();
  }
}

fixPosts();