// utils/streak.js
// 🟢 FEATURE #1 : Streak de publication (jours consécutifs avec un post)

/**
 * 🟢 Met à jour le streak de publication d'un utilisateur.
 * 
 * @param {number} userId - L'ID de l'utilisateur qui poste
 * @param {PrismaClient} prisma - Le client Prisma (passé depuis server.js)
 * @returns {Promise<number|null>} - Le nouveau streak ou null si pas de changement
 */
async function updatePostStreak(userId, prisma) {
  try {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        postStreakCount: true,
        postStreakLastDate: true,
        postStreakMax: true,
        postStreakBadge: true,
      },
    });

    if (!user) return null;

    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());

    let newCount = 1;
    let shouldUpdate = true;

    if (user.postStreakLastDate) {
      const lastDate = new Date(user.postStreakLastDate);
      const lastDay = new Date(
        lastDate.getFullYear(),
        lastDate.getMonth(),
        lastDate.getDate()
      );
      const diffInDays = Math.floor(
        (today.getTime() - lastDay.getTime()) / (1000 * 60 * 60 * 24)
      );

      if (diffInDays === 0) {
        // 🟢 Déjà posté aujourd'hui → on ne touche pas
        shouldUpdate = false;
      } else if (diffInDays === 1) {
        // 🟢 Posté hier → on incrémente
        newCount = user.postStreakCount + 1;
      } else {
        // 🟢 Plus de 1 jour d'écart → reset
        newCount = 1;
      }
    }

    if (!shouldUpdate) return null;

    // Calcul du badge en fonction du streak
    const badge = getStreakBadge(newCount);

    // Mise à jour
    await prisma.user.update({
      where: { id: userId },
      data: {
        postStreakCount: newCount,
        postStreakLastDate: now,
        postStreakMax: Math.max(newCount, user.postStreakMax || 0),
        postStreakBadge: badge,
      },
    });

    console.log(
      `🔥 [STREAK] User ${userId} → streak ${newCount} jour(s) (badge: ${badge})`
    );

    return newCount;
  } catch (error) {
    console.error("❌ [STREAK] Erreur updatePostStreak:", error);
    return null;
  }
}

/**
 * 🟢 Renvoie le badge en fonction du streak
 */
function getStreakBadge(count) {
  if (count >= 365) return "legend";
  if (count >= 100) return "gold";
  if (count >= 30) return "silver";
  if (count >= 7) return "bronze";
  return "none";
}

module.exports = { updatePostStreak, getStreakBadge };