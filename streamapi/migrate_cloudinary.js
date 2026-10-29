const { PrismaClient } = require('@prisma/client');
const cloudinary = require('cloudinary').v2;
require('dotenv').config();

const prisma = new PrismaClient();

// CONFIGURATION AVEC TES NOUVELLES CLÉS (PRISES DANS LE .ENV)
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET
});

const NOUVEAU_CLOUD_NAME = "dw59yt9yd";
const ANCIEN_CLOUD_NAME = "de8qaknqq";

async function migrateField(table, idField, urlField) {
    console.log(`\n--- 📦 Migration Table: ${table} | Champ: ${urlField} ---`);
    
    // Trouver les entrées qui contiennent encore l'ancien Cloudinary
    const items = await prisma[table].findMany({
        where: {
            [urlField]: { contains: ANCIEN_CLOUD_NAME }
        }
    });

    console.log(`🔍 Trouvé : ${items.length} fichiers à transférer.`);

    for (const item of items) {
        const oldUrl = item[urlField];

        try {
            console.log(`📤 Transfert de : ${oldUrl}`);

            // Upload direct de l'URL vers le nouveau compte
            const uploadRes = await cloudinary.uploader.upload(oldUrl, {
                folder: 'propulse_migration',
                resource_type: 'auto' // Détecte automatiquement image ou vidéo
            });

            // Mise à jour de l'URL dans Supabase (via Prisma)
            await prisma[table].update({
                where: { [idField]: item[idField] },
                data: { [urlField]: uploadRes.secure_url }
            });

            console.log(`✅ Réussi pour l'ID ${item[idField]}`);
        } catch (error) {
            console.error(`❌ Erreur pour l'ID ${item[idField]}:`, error.message);
        }
    }
}

async function run() {
    try {
        // Liste de tous les champs où tu stockes des fichiers
        await migrateField('user', 'id', 'avatarUrl');
        await migrateField('user', 'id', 'coverUrl');
        await migrateField('post', 'id', 'imageUrl');
        await migrateField('postMedia', 'id', 'url');
        await migrateField('story', 'id', 'mediaUrl');
        await migrateField('community', 'id', 'logo');
        await migrateField('community', 'id', 'banner');
        await migrateField('productImage', 'id', 'url');
        await migrateField('shop', 'id', 'logo');
        await migrateField('shop', 'id', 'cover');
        await migrateField('newsArticle', 'id', 'imageUrl');

        console.log("\n✨ TOUTE LA MIGRATION EST TERMINÉE AVEC SUCCÈS !");
    } catch (e) {
        console.error("Erreur globale :", e);
    } finally {
        await prisma.$disconnect();
    }
}

run();