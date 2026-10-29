// utils/streakNotifications.js
// 🟢 FEATURE #1 : Notifications intelligentes pour le Streak
// Version SANS table StreakNotificationLog

const { Expo } = require("expo-server-sdk");
const expo = new Expo();

/**
 * 🔔 Notification #1 : Rappel bienveillant (20h)
 */
async function sendStreakDangerReminder(prisma, createNotification) {
  try {
    const now = new Date();
    const todayStart = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      0, 0, 0, 0
    );

    const targets = await prisma.user.findMany({
      where: {
        postStreakCount: { gt: 0 },
        pushToken: { not: null },
        OR: [
          { postStreakLastDate: null },
          { postStreakLastDate: { lt: todayStart } },
        ],
      },
      select: {
        id: true,
        fullName: true,
        pushToken: true,
        postStreakCount: true,
      },
    });

    if (targets.length === 0) {
      console.log("🔥 [STREAK NOTIF] Aucun utilisateur à notifier");
      return { count: 0 };
    }

    console.log(`🔥 [STREAK NOTIF] ${targets.length} utilisateurs à rappeler`);

    let sent = 0;

    for (const user of targets) {
      // 🟢 Anti-spam : on vérifie dans les notifications déjà envoyées
      const alreadySent = await prisma.notification.findFirst({
        where: {
          receiverId: user.id,
          type: "STREAK_DANGER",
          createdAt: { gte: todayStart },
        },
      });

      if (alreadySent) continue;

      try {
        await createNotification(
          "STREAK_DANGER",
          user.id,
          user.id,
          null, null, null,
          `🔥 Ton streak de ${user.postStreakCount} jour${user.postStreakCount > 1 ? "s" : ""} est en danger ! Poste une story ou un reel avant minuit pour le garder.`,
          null, null, null, null, null, null, null
        );
        sent++;
      } catch (e) {
        console.error(`❌ Erreur notif user ${user.id}:`, e.message);
      }
    }

    console.log(`✅ [STREAK NOTIF] ${sent} notifications envoyées`);
    return { count: sent };
  } catch (error) {
    console.error("❌ [STREAK NOTIF] Erreur danger reminder:", error);
    return { count: 0 };
  }
}

/**
 * 🔔 Notification #2 : Relance amicale (8h)
 */
async function sendStreakLostReminder(prisma, createNotification) {
  try {
    const now = new Date();
    const todayStart = new Date(
      now.getFullYear(),
      now.getMonth(),
      now.getDate(),
      0, 0, 0, 0
    );

    const targets = await prisma.user.findMany({
      where: {
        postStreakCount: 0,
        postStreakMax: { gt: 0 },
        pushToken: { not: null },
      },
      select: {
        id: true,
        fullName: true,
        pushToken: true,
        postStreakMax: true,
      },
    });

    if (targets.length === 0) {
      console.log("💔 [STREAK NOTIF] Aucun streak perdu");
      return { count: 0 };
    }

    console.log(`💔 [STREAK NOTIF] ${targets.length} utilisateurs à relancer`);

    let sent = 0;

    for (const user of targets) {
      // Anti-spam : on vérifie dans les notifications
      const alreadySent = await prisma.notification.findFirst({
        where: {
          receiverId: user.id,
          type: "STREAK_LOST",
          createdAt: { gte: todayStart },
        },
      });
      if (alreadySent) continue;

      // Ne pas relancer si déjà posté aujourd'hui
      const postedToday = await prisma.post.count({
        where: {
          userId: user.id,
          createdAt: { gte: todayStart },
        },
      });
      if (postedToday > 0) continue;

      try {
        await createNotification(
          "STREAK_LOST",
          user.id,
          user.id,
          null, null, null,
          `💔 Ton streak de ${user.postStreakMax} jours est terminé. Recommence aujourd'hui — chaque légende a un jour 1.`,
          null, null, null, null, null, null, null
        );
        sent++;
      } catch (e) {
        console.error(`❌ Erreur relance user ${user.id}:`, e.message);
      }
    }

    console.log(`✅ [STREAK NOTIF] ${sent} relances envoyées`);
    return { count: sent };
  } catch (error) {
    console.error("❌ [STREAK NOTIF] Erreur lost reminder:", error);
    return { count: 0 };
  }
}

/**
 * 🔔 Notification #3 : Comparaison sociale (Vendredi 19h)
 */
async function sendStreakSocialComparison(prisma, createNotification) {
  try {
    const now = new Date();
    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    // Héros (les gros streaks)
    const heroes = await prisma.user.findMany({
      where: {
        postStreakCount: { gte: 10 },
        pushToken: { not: null },
      },
      orderBy: { postStreakCount: "desc" },
      take: 50,
      select: {
        id: true,
        fullName: true,
        postStreakCount: true,
      },
    });

    if (heroes.length === 0) {
      console.log("🏆 [STREAK NOTIF] Aucun héros disponible");
      return { count: 0 };
    }

    // Cibles (petits streaks)
    const targets = await prisma.user.findMany({
      where: {
        postStreakCount: { lte: 3 },
        pushToken: { not: null },
      },
      select: {
        id: true,
        fullName: true,
        pushToken: true,
        postStreakCount: true,
      },
    });

    if (targets.length === 0) {
      console.log("🏆 [STREAK NOTIF] Aucune cible");
      return { count: 0 };
    }

    let sent = 0;

    for (const user of targets) {
      // Anti-spam : 1x/semaine
      const alreadySent = await prisma.notification.findFirst({
        where: {
          receiverId: user.id,
          type: "STREAK_SOCIAL",
          createdAt: { gte: weekAgo },
        },
      });
      if (alreadySent) continue;

      const hero = heroes[Math.floor(Math.random() * heroes.length)];
      if (hero.id === user.id) continue;

      try {
        await createNotification(
          "STREAK_SOCIAL",
          hero.id,
          user.id,
          null, null, null,
          `🏆 ${hero.fullName.split(" ")[0]} a atteint ${hero.postStreakCount} jours de streak. Et toi, où en es-tu ? Montre-nous ton niveau !`,
          null, null, null, null, null, null, null
        );
        sent++;
      } catch (e) {
        console.error(`❌ Erreur social user ${user.id}:`, e.message);
      }
    }

    console.log(`✅ [STREAK NOTIF] ${sent} notifs sociales envoyées`);
    return { count: sent };
  } catch (error) {
    console.error("❌ [STREAK NOTIF] Erreur social:", error);
    return { count: 0 };
  }
}

module.exports = {
  sendStreakDangerReminder,
  sendStreakLostReminder,
  sendStreakSocialComparison,
};