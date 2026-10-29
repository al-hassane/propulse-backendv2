-- CreateEnum
CREATE TYPE "CertifTier" AS ENUM ('NONE', 'PREMIUM', 'GOLD', 'ELITE');

-- CreateEnum
CREATE TYPE "CertifStatus" AS ENUM ('INCOMPLETE', 'PENDING_DOCS', 'WAITING_APPROVAL', 'APPROVED', 'REJECTED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "MediaType" AS ENUM ('TEXT', 'IMAGE', 'VIDEO', 'PDF', 'SHARED_POST', 'AUDIO', 'SHARED_AUDIO', 'SHARED_ORG_POST', 'SHARED_STORY');

-- CreateEnum
CREATE TYPE "ReactionType" AS ENUM ('LIKE', 'LOVE', 'LAUGH', 'SURPRISED', 'SAD', 'ANGRY');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "fullName" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "ovr" INTEGER NOT NULL DEFAULT 60,
    "sportAttributes" JSONB DEFAULT '{}',
    "city" TEXT,
    "cityBackfillAttempts" INTEGER NOT NULL DEFAULT 0,
    "country" TEXT DEFAULT 'Sénégal',
    "nationalities" TEXT[],
    "cvCompleted" BOOLEAN NOT NULL DEFAULT false,
    "eliteCV" JSONB,
    "username" TEXT,
    "nameUpdatedAt" TIMESTAMP(3),
    "email" TEXT,
    "phoneNumber" TEXT,
    "phoneCountryCode" TEXT,
    "password" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "certifTier" "CertifTier" NOT NULL DEFAULT 'NONE',
    "acceptedTermsAt" TIMESTAMP(3),
    "suspendedUntil" TIMESTAMP(3),
    "sport" TEXT,
    "position" TEXT,
    "club" TEXT,
    "strongFoot" TEXT,
    "height" INTEGER,
    "weight" INTEGER,
    "birthDate" TIMESTAMP(3),
    "bio" TEXT,
    "coverUrl" TEXT,
    "avatarUrl" TEXT DEFAULT 'https://d21bhgmu32o7ny.cloudfront.net/propulse_app/default-avatar.png',
    "eliteCardUrl" TEXT,
    "eliteCardUrlLight" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "xp" INTEGER NOT NULL DEFAULT 0,
    "level" INTEGER NOT NULL DEFAULT 1,
    "postStreakCount" INTEGER NOT NULL DEFAULT 0,
    "postStreakLastDate" TIMESTAMP(3),
    "postStreakMax" INTEGER NOT NULL DEFAULT 0,
    "postStreakBadge" TEXT DEFAULT 'none',
    "isPrivateProfile" BOOLEAN NOT NULL DEFAULT false,
    "allowMessages" TEXT NOT NULL DEFAULT 'EVERYONE',
    "showOnlineStatus" BOOLEAN NOT NULL DEFAULT true,
    "allowRatings" TEXT NOT NULL DEFAULT 'EVERYONE',
    "managerType" TEXT,
    "managerOtherDetail" TEXT,
    "verificationSelfie" TEXT,
    "verificationDocType" TEXT,
    "verificationDocFront" TEXT,
    "verificationDocBack" TEXT,
    "eliteCardUpdatedAt" TIMESTAMP(3),
    "eliteCvValidated" BOOLEAN NOT NULL DEFAULT false,
    "elitePackOpened" BOOLEAN NOT NULL DEFAULT false,
    "isManagerVerified" BOOLEAN NOT NULL DEFAULT false,
    "managerRequestDate" TIMESTAMP(3),
    "isApplePrivateRelay" BOOLEAN NOT NULL DEFAULT false,
    "showProfileViews" BOOLEAN NOT NULL DEFAULT true,
    "isDefaultStarter" BOOLEAN NOT NULL DEFAULT false,
    "tacticalRole" TEXT,
    "jerseyNumber" INTEGER,
    "isEmailVerified" BOOLEAN NOT NULL DEFAULT false,
    "verificationToken" TEXT,
    "verificationTokenExpiresAt" TIMESTAMP(3),
    "pushToken" TEXT,
    "referralCode" TEXT,
    "referredById" INTEGER,
    "aiProScore" DOUBLE PRECISION DEFAULT 0,
    "aiTalentGroup" TEXT,
    "trustIndex" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "ascId" INTEGER,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "lastLocUpdate" TIMESTAMP(3),
    "lastActiveAt" TIMESTAMP(3),
    "proximityRadius" INTEGER NOT NULL DEFAULT 10,
    "batteryLevel" INTEGER,
    "trainingStreak" INTEGER NOT NULL DEFAULT 0,
    "lastTrainingAt" TIMESTAMP(3),
    "referralProcessed" BOOLEAN NOT NULL DEFAULT false,
    "kudosStreakCount" INTEGER NOT NULL DEFAULT 0,
    "kudosStreakLastAt" TIMESTAMP(3),
    "kudosStreakMax" INTEGER NOT NULL DEFAULT 0,
    "kudosReceivedBalance" INTEGER NOT NULL DEFAULT 0,
    "kudosBalance" INTEGER NOT NULL DEFAULT 15,
    "lastDailyKudosAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Post" (
    "id" SERIAL NOT NULL,
    "imageUrl" TEXT,
    "thumbnailUrl" TEXT,
    "description" TEXT,
    "width" INTEGER,
    "height" INTEGER,
    "views" INTEGER NOT NULL DEFAULT 0,
    "sport" TEXT,
    "location" TEXT,
    "tags" TEXT,
    "aiTags" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "commentsDisabled" BOOLEAN NOT NULL DEFAULT false,
    "mediaType" "MediaType" NOT NULL DEFAULT 'IMAGE',
    "userId" INTEGER NOT NULL,
    "communityId" INTEGER,
    "hasPoll" BOOLEAN NOT NULL DEFAULT false,
    "pollQuestion" TEXT,
    "hideAiTags" BOOLEAN NOT NULL DEFAULT false,
    "audioId" INTEGER,

    CONSTRAINT "Post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostMedia" (
    "id" SERIAL NOT NULL,
    "url" TEXT NOT NULL,
    "postId" INTEGER NOT NULL,

    CONSTRAINT "PostMedia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PollVote" (
    "id" SERIAL NOT NULL,
    "postId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "option" TEXT NOT NULL,

    CONSTRAINT "PollVote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Like" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Like_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Kudos" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "tier" TEXT,
    "cost" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Kudos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rating" (
    "id" SERIAL NOT NULL,
    "score" INTEGER NOT NULL,
    "comment" TEXT,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "parentId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Rating_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RatingLike" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "ratingId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RatingLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Follow" (
    "id" SERIAL NOT NULL,
    "followerId" INTEGER NOT NULL,
    "followingId" INTEGER NOT NULL,
    "notifLevel" TEXT NOT NULL DEFAULT 'CUSTOM',
    "status" TEXT NOT NULL DEFAULT 'ACCEPTED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Follow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Share" (
    "id" SERIAL NOT NULL,
    "postId" INTEGER NOT NULL,
    "senderId" INTEGER NOT NULL,
    "receiverId" INTEGER NOT NULL,
    "message" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Share_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedPost" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Report" (
    "id" SERIAL NOT NULL,
    "reporterId" INTEGER NOT NULL,
    "postId" INTEGER,
    "storyId" INTEGER,
    "targetUserId" INTEGER,
    "organizationId" INTEGER,
    "organizationPostId" INTEGER,
    "reason" TEXT NOT NULL,
    "details" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HiddenPost" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HiddenPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Block" (
    "id" SERIAL NOT NULL,
    "blockerId" INTEGER NOT NULL,
    "blockedId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Block_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "message" TEXT,
    "receiverId" INTEGER NOT NULL,
    "senderId" INTEGER NOT NULL,
    "postId" INTEGER,
    "eventId" INTEGER,
    "orgPostId" INTEGER,
    "ratingId" INTEGER,
    "requestStatus" TEXT NOT NULL DEFAULT 'PENDING',
    "communityId" INTEGER,
    "organizationId" INTEGER,
    "storyId" INTEGER,
    "newsId" INTEGER,
    "trainingId" INTEGER,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Event" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "description" TEXT,
    "date" TIMESTAMP(3) NOT NULL,
    "ageCategory" TEXT,
    "isFree" BOOLEAN NOT NULL DEFAULT true,
    "price" DOUBLE PRECISION,
    "currency" TEXT,
    "country" TEXT,
    "city" TEXT,
    "location" TEXT NOT NULL,
    "imageUrl" TEXT,
    "status" TEXT NOT NULL DEFAULT 'UPCOMING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" INTEGER NOT NULL,
    "communityId" INTEGER,

    CONSTRAINT "Event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EventPayout" (
    "id" SERIAL NOT NULL,
    "eventId" INTEGER NOT NULL,
    "managerId" INTEGER NOT NULL,
    "paymentMethod" TEXT NOT NULL,
    "payoutPhone" TEXT,
    "payoutFullName" TEXT,
    "cardToken" TEXT,
    "cardLast4" TEXT,
    "cardBrand" TEXT,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "saveForNext" BOOLEAN NOT NULL DEFAULT false,
    "totalReceived" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalPayouts" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "platformFee" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EventPayout_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EventTicketPayment" (
    "id" SERIAL NOT NULL,
    "buyerId" INTEGER NOT NULL,
    "eventId" INTEGER NOT NULL,
    "amountXof" INTEGER NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'XOF',
    "platformFeePct" INTEGER NOT NULL DEFAULT 10,
    "platformFeeXof" INTEGER NOT NULL DEFAULT 0,
    "netForManager" INTEGER NOT NULL DEFAULT 0,
    "refCommand" TEXT NOT NULL,
    "token" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "paymentMethod" TEXT,
    "paidAt" TIMESTAMP(3),
    "payoutStatus" TEXT NOT NULL DEFAULT 'PENDING',
    "payoutRef" TEXT,
    "payoutAt" TIMESTAMP(3),
    "payoutError" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EventTicketPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EventParticipant" (
    "id" SERIAL NOT NULL,
    "eventId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EventParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TargetPlayer" (
    "id" SERIAL NOT NULL,
    "managerId" INTEGER NOT NULL,
    "playerId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TargetPlayer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Community" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "logo" TEXT DEFAULT 'https://d21bhgmu32o7ny.cloudfront.net/propulse_app/chatgpt_image_2.png',
    "banner" TEXT DEFAULT 'https://d21bhgmu32o7ny.cloudfront.net/propulse_app/chatgpt_image_1.png',
    "city" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "foundedIn" TEXT,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "category" TEXT NOT NULL DEFAULT 'CLUB',
    "isPrivate" BOOLEAN NOT NULL DEFAULT false,
    "ownerId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Community_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CommunityRequest" (
    "id" SERIAL NOT NULL,
    "communityId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CommunityRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerCertification" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "realFullName" TEXT NOT NULL,
    "birthDate" TEXT NOT NULL,
    "idCardNumber" TEXT,
    "idCardPhoto" TEXT,
    "clubProofPhoto" TEXT,
    "proContractPhoto" TEXT,
    "tier" "CertifTier" NOT NULL DEFAULT 'PREMIUM',
    "status" "CertifStatus" NOT NULL DEFAULT 'INCOMPLETE',
    "reason" TEXT,
    "paymentStatus" BOOLEAN NOT NULL DEFAULT false,
    "paymentMethod" TEXT,
    "paymentGateway" TEXT,
    "transactionId" TEXT,
    "originalTransactionId" TEXT,
    "paymentDate" TIMESTAMP(3),
    "amount" DOUBLE PRECISION NOT NULL DEFAULT 1000,
    "expiryDate" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlayerCertification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Duel" (
    "id" SERIAL NOT NULL,
    "sport" TEXT NOT NULL DEFAULT 'football',
    "post1Id" INTEGER NOT NULL,
    "post2Id" INTEGER NOT NULL,
    "winnerId" INTEGER,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Duel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DuelVote" (
    "id" SERIAL NOT NULL,
    "duelId" INTEGER NOT NULL,
    "voterId" INTEGER NOT NULL,
    "votedFor" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DuelVote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SupportTicket" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "category" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'OPEN',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SupportTicket_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Story" (
    "id" SERIAL NOT NULL,
    "mediaUrl" TEXT,
    "type" TEXT NOT NULL,
    "content" TEXT,
    "background" TEXT,
    "fontStyle" TEXT,
    "textColor" TEXT DEFAULT '#FFFFFF',
    "stickerStyle" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "userId" INTEGER NOT NULL,
    "sharedPostId" INTEGER,
    "storyAudioId" INTEGER,
    "textScale" TEXT DEFAULT '1',
    "textOffsetX" TEXT DEFAULT '0',
    "textOffsetY" TEXT DEFAULT '0',
    "textRotation" TEXT DEFAULT '0',
    "stickers" TEXT DEFAULT '[]',
    "mediaBgMode" TEXT DEFAULT 'blur',
    "mediaBgColor" TEXT DEFAULT '#000000',
    "mediaScale" TEXT DEFAULT '1',
    "mediaOffsetX" TEXT DEFAULT '0',
    "mediaOffsetY" TEXT DEFAULT '0',

    CONSTRAINT "Story_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryLike" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "storyId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryComment" (
    "id" SERIAL NOT NULL,
    "text" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "storyId" INTEGER NOT NULL,
    "parentId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryView" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "storyId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryFlame" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "storyId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryFlame_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryPoll" (
    "id" SERIAL NOT NULL,
    "storyId" INTEGER NOT NULL,
    "question" TEXT NOT NULL,
    "optionA" TEXT NOT NULL,
    "optionB" TEXT NOT NULL,
    "x" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "y" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "scale" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "rotation" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryPoll_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryPollVote" (
    "id" SERIAL NOT NULL,
    "pollId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "choice" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryPollVote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Shop" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "logo" TEXT,
    "cover" TEXT,
    "whatsapp" TEXT,
    "address" TEXT,
    "city" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isPremium" BOOLEAN NOT NULL DEFAULT false,
    "premiumUntil" TIMESTAMP(3),
    "ownerId" INTEGER NOT NULL,
    "mainBrand" TEXT,

    CONSTRAINT "Shop_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ShopMember" (
    "id" SERIAL NOT NULL,
    "shopId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'vendeur',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ShopMember_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ShopCertification" (
    "id" SERIAL NOT NULL,
    "shopId" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING_PAYMENT',
    "transactionId" TEXT,
    "paymentMethod" TEXT,
    "expiryDate" TIMESTAMP(3),
    "reason" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ShopCertification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Product" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "price" DOUBLE PRECISION NOT NULL,
    "oldPrice" DOUBLE PRECISION,
    "category" TEXT NOT NULL,
    "condition" TEXT NOT NULL,
    "size" TEXT,
    "brand" TEXT,
    "views" INTEGER NOT NULL DEFAULT 0,
    "discount" INTEGER NOT NULL DEFAULT 0,
    "isSold" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "shopId" INTEGER NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductImage" (
    "id" SERIAL NOT NULL,
    "url" TEXT NOT NULL,
    "productId" INTEGER NOT NULL,

    CONSTRAINT "ProductImage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProductLike" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,

    CONSTRAINT "ProductLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" SERIAL NOT NULL,
    "buyerId" INTEGER NOT NULL,
    "shopId" INTEGER NOT NULL,
    "total" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrderItem" (
    "id" SERIAL NOT NULL,
    "orderId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SuggestionDismiss" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "targetId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SuggestionDismiss_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AdminNotification" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AdminNotification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NewsArticle" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "imageUrl" TEXT NOT NULL,
    "source" TEXT,
    "category" TEXT NOT NULL,
    "views" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "NewsArticle_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NewsReaction" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "newsId" INTEGER NOT NULL,

    CONSTRAINT "NewsReaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedNews" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "newsId" INTEGER NOT NULL,

    CONSTRAINT "SavedNews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedStory" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "storyId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedStory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SystemConfig" (
    "id" INTEGER NOT NULL DEFAULT 1,
    "isCertifEnabled" BOOLEAN NOT NULL DEFAULT true,
    "playerPrice" INTEGER NOT NULL DEFAULT 1000,
    "clubPrice" INTEGER NOT NULL DEFAULT 100000,
    "shopPrice" INTEGER NOT NULL DEFAULT 5000,
    "waveNumber" TEXT NOT NULL DEFAULT '77 000 00 00',
    "orangeMoneyNumber" TEXT NOT NULL DEFAULT '77 111 11 11',

    CONSTRAINT "SystemConfig_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Broadcast" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "targetRole" TEXT NOT NULL DEFAULT 'ALL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Broadcast_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BroadcastView" (
    "id" SERIAL NOT NULL,
    "broadcastId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "viewedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BroadcastView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryMention" (
    "id" SERIAL NOT NULL,
    "storyId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "StoryMention_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PostMention" (
    "id" SERIAL NOT NULL,
    "postId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "PostMention_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CommunityCertification" (
    "id" SERIAL NOT NULL,
    "communityId" INTEGER NOT NULL,
    "managerFullName" TEXT,
    "contactPhone" TEXT,
    "contactEmail" TEXT,
    "position" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING_PAYMENT',
    "tier" "CertifTier" NOT NULL DEFAULT 'PREMIUM',
    "paymentMethod" TEXT,
    "transactionId" TEXT,
    "expiryDate" TIMESTAMP(3),
    "lastReminderSent" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CommunityCertification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ShopLike" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "shopId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ShopLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedProduct" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedProduct_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SearchHistory" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "query" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SearchHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mute" (
    "id" SERIAL NOT NULL,
    "muterId" INTEGER NOT NULL,
    "mutedId" INTEGER NOT NULL,
    "mutePosts" BOOLEAN NOT NULL DEFAULT false,
    "muteStories" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Mute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProfileView" (
    "id" SERIAL NOT NULL,
    "viewerId" INTEGER NOT NULL,
    "profileOwnerId" INTEGER NOT NULL,
    "viewedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isRead" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "ProfileView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserBehavior" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "targetPostId" INTEGER,
    "targetUserId" INTEGER,
    "actionType" TEXT NOT NULL,
    "value" DOUBLE PRECISION,
    "sport" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserBehavior_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Competition" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "year" TEXT NOT NULL,
    "season" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Competition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Region" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "competitionId" INTEGER NOT NULL,

    CONSTRAINT "Region_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Department" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "regionId" INTEGER NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Zone" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "departmentId" INTEGER NOT NULL,

    CONSTRAINT "Zone_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Asc" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "logo" TEXT,
    "formation" TEXT NOT NULL DEFAULT '4-4-2',
    "zoneId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Asc_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Match" (
    "id" SERIAL NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "stadium" TEXT,
    "status" TEXT NOT NULL DEFAULT 'SCHEDULED',
    "homeTeamId" INTEGER NOT NULL,
    "homeScore" INTEGER NOT NULL DEFAULT 0,
    "awayTeamId" INTEGER NOT NULL,
    "awayScore" INTEGER NOT NULL DEFAULT 0,
    "zoneId" INTEGER NOT NULL,
    "startTime" TIMESTAMP(3),
    "elapsedSeconds" INTEGER NOT NULL DEFAULT 0,
    "extraTime" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Match_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MatchEvent" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "minute" INTEGER NOT NULL,
    "teamId" INTEGER NOT NULL,
    "playerName" TEXT,
    "playerId" INTEGER,

    CONSTRAINT "MatchEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MatchLineup" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "teamId" INTEGER NOT NULL,
    "playerName" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "posX" INTEGER NOT NULL,
    "posY" INTEGER NOT NULL,
    "isStarter" BOOLEAN NOT NULL DEFAULT true,
    "tacticalRole" TEXT,

    CONSTRAINT "MatchLineup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MatchStats" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "homePossession" INTEGER NOT NULL DEFAULT 50,
    "awayPossession" INTEGER NOT NULL DEFAULT 50,
    "homeShots" INTEGER NOT NULL DEFAULT 0,
    "awayShots" INTEGER NOT NULL DEFAULT 0,
    "homeOnTarget" INTEGER NOT NULL DEFAULT 0,
    "awayOnTarget" INTEGER NOT NULL DEFAULT 0,
    "homeCorners" INTEGER NOT NULL DEFAULT 0,
    "awayCorners" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "MatchStats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Standing" (
    "id" SERIAL NOT NULL,
    "played" INTEGER NOT NULL DEFAULT 0,
    "won" INTEGER NOT NULL DEFAULT 0,
    "drawn" INTEGER NOT NULL DEFAULT 0,
    "lost" INTEGER NOT NULL DEFAULT 0,
    "goalsFor" INTEGER NOT NULL DEFAULT 0,
    "goalsAgainst" INTEGER NOT NULL DEFAULT 0,
    "points" INTEGER NOT NULL DEFAULT 0,
    "ascId" INTEGER NOT NULL,
    "zoneId" INTEGER NOT NULL,

    CONSTRAINT "Standing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MatchComment" (
    "id" SERIAL NOT NULL,
    "text" TEXT NOT NULL,
    "matchId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MatchComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ProximityAlert" (
    "id" SERIAL NOT NULL,
    "senderId" INTEGER NOT NULL,
    "receiverId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProximityAlert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CareerStep" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "clubName" TEXT NOT NULL,
    "startYear" TEXT NOT NULL,
    "endYear" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "description" TEXT,
    "mediaUrl" TEXT,
    "isCurrent" BOOLEAN NOT NULL DEFAULT false,
    "mj" TEXT,
    "buts" TEXT,
    "pd" TEXT,
    "note" TEXT,
    "pts" TEXT,
    "reb" TEXT,
    "pad" TEXT,
    "moyPts" TEXT,
    "buts_hand" TEXT,
    "passes" TEXT,
    "points" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CareerStep_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Trophy" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "year" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'medal',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Trophy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CareerTeaserInteraction" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CareerTeaserInteraction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Conversation" (
    "id" SERIAL NOT NULL,
    "user1Id" INTEGER NOT NULL,
    "user2Id" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isPinned" BOOLEAN NOT NULL DEFAULT false,
    "isPinnedForUser2" BOOLEAN NOT NULL DEFAULT false,
    "isArchivedForUser1" BOOLEAN NOT NULL DEFAULT false,
    "isArchivedForUser2" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" SERIAL NOT NULL,
    "conversationId" INTEGER NOT NULL,
    "senderId" INTEGER NOT NULL,
    "text" TEXT,
    "mediaUrl" TEXT,
    "mediaType" "MediaType" NOT NULL DEFAULT 'TEXT',
    "duration" INTEGER,
    "sharedPostId" INTEGER,
    "sharedOrgPostId" INTEGER,
    "sharedAudioId" INTEGER,
    "isRead" BOOLEAN NOT NULL DEFAULT false,
    "isPinned" BOOLEAN NOT NULL DEFAULT false,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sharedStoryId" INTEGER,
    "storySnapshot" JSONB,
    "replyToId" INTEGER,
    "isEdited" BOOLEAN NOT NULL DEFAULT false,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MessageReport" (
    "id" SERIAL NOT NULL,
    "messageId" INTEGER NOT NULL,
    "reporterId" INTEGER NOT NULL,
    "reason" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MessageReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MessageDeletion" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "messageId" INTEGER NOT NULL,

    CONSTRAINT "MessageDeletion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MessageReaction" (
    "id" SERIAL NOT NULL,
    "messageId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "reactionType" "ReactionType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MessageReaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TrainingSession" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "videoUrl" TEXT NOT NULL,
    "description" TEXT,
    "duration" INTEGER,
    "intensity" INTEGER NOT NULL DEFAULT 3,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TrainingSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TrainingFeedback" (
    "id" SERIAL NOT NULL,
    "sessionId" INTEGER NOT NULL,
    "reviewerId" INTEGER NOT NULL,
    "technicalScore" INTEGER NOT NULL DEFAULT 0,
    "intensityScore" INTEGER NOT NULL DEFAULT 0,
    "comment" TEXT,
    "voiceNoteUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TrainingFeedback_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TrainingTarget" (
    "id" SERIAL NOT NULL,
    "sessionId" INTEGER NOT NULL,
    "targetUserId" INTEGER NOT NULL,

    CONSTRAINT "TrainingTarget_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserPostView" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "seenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserPostView_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TrainingReaction" (
    "id" SERIAL NOT NULL,
    "sessionId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "emoji" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TrainingReaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CVPayment" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "refCommand" TEXT NOT NULL,
    "token" TEXT,
    "amount" INTEGER NOT NULL DEFAULT 200,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "paymentMethod" TEXT,
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CVPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PropulseAd" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "mediaUrl" TEXT,
    "ctaText" TEXT NOT NULL,
    "ctaLink" TEXT NOT NULL,
    "targetRole" TEXT NOT NULL DEFAULT 'ALL',
    "targetSport" TEXT NOT NULL DEFAULT 'ALL',
    "priority" INTEGER NOT NULL DEFAULT 5,
    "startDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endDate" TIMESTAMP(3) NOT NULL,
    "impressions" INTEGER NOT NULL DEFAULT 0,
    "clicks" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PropulseAd_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PropulseAdImage" (
    "id" SERIAL NOT NULL,
    "adId" INTEGER NOT NULL,
    "url" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PropulseAdImage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PropulseAdImpression" (
    "id" SERIAL NOT NULL,
    "adId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "viewedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PropulseAdImpression_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PropulseAdClick" (
    "id" SERIAL NOT NULL,
    "adId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "clickedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PropulseAdClick_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CertificationPayment" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "refCommand" TEXT NOT NULL,
    "token" TEXT,
    "amount" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "paymentMethod" TEXT,
    "tier" "CertifTier" NOT NULL,
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CertificationPayment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserSession" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "connectionType" TEXT,
    "deviceBrand" TEXT,
    "deviceModel" TEXT,
    "deviceOS" TEXT,
    "deviceOSVersion" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserSession_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Sticker" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "keywords" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "bgColor" TEXT,
    "textColor" TEXT,
    "borderWidth" DOUBLE PRECISION,
    "borderColor" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Sticker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorySlider" (
    "id" SERIAL NOT NULL,
    "storyId" INTEGER NOT NULL,
    "emoji" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "x" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "y" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "scale" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "rotation" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StorySlider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorySliderVote" (
    "id" SERIAL NOT NULL,
    "sliderId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StorySliderVote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ChatTab" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ChatTab_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryAudio" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "audioUrl" TEXT NOT NULL,
    "duration" INTEGER,
    "waveform" TEXT,
    "authorId" INTEGER NOT NULL,
    "usageCount" INTEGER NOT NULL DEFAULT 0,
    "isPublic" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "likesCount" INTEGER NOT NULL DEFAULT 0,
    "isOfficial" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "StoryAudio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StoryAudioLike" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "storyAudioId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StoryAudioLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Tournament" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "game" TEXT NOT NULL,
    "rules" TEXT NOT NULL,
    "prizePool" TEXT,
    "maxParticipants" INTEGER NOT NULL DEFAULT 16,
    "isFree" BOOLEAN NOT NULL DEFAULT true,
    "entryFee" DOUBLE PRECISION DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'PENDING_APPROVAL',
    "rejectionReason" TEXT,
    "creatorId" INTEGER NOT NULL,
    "organizationId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tournament_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TournamentParticipant" (
    "id" SERIAL NOT NULL,
    "tournamentId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TournamentParticipant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TournamentMatch" (
    "id" SERIAL NOT NULL,
    "tournamentId" INTEGER NOT NULL,
    "round" INTEGER NOT NULL,
    "position" INTEGER NOT NULL,
    "playerAId" INTEGER,
    "playerBId" INTEGER,
    "youtubeVideoId" TEXT,
    "scoreA" INTEGER,
    "scoreB" INTEGER,
    "winnerId" INTEGER,
    "scheduledAt" TIMESTAMP(3),
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "nextMatchId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TournamentMatch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LiveStream" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "ingestEndpoint" TEXT NOT NULL,
    "streamKey" TEXT NOT NULL,
    "playbackUrl" TEXT NOT NULL,
    "isLive" BOOLEAN NOT NULL DEFAULT false,
    "viewerCount" INTEGER NOT NULL DEFAULT 0,
    "matchId" INTEGER,
    "tournamentId" INTEGER,
    "streamerId" INTEGER NOT NULL,
    "replayUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "LiveStream_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TournamentMatchComment" (
    "id" SERIAL NOT NULL,
    "matchId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "text" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "TournamentMatchComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "logo" TEXT,
    "banner" TEXT,
    "sportCategory" TEXT,
    "email" TEXT,
    "phone" TEXT,
    "address" TEXT,
    "country" TEXT,
    "objectives" TEXT,
    "rules" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "rejectionReason" TEXT,
    "website" TEXT,
    "facebook" TEXT,
    "instagram" TEXT,
    "twitter" TEXT,
    "youtube" TEXT,
    "tiktok" TEXT,
    "privacy" TEXT NOT NULL DEFAULT 'PUBLIC',
    "ownerId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationRequest" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationInvitation" (
    "id" SERIAL NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationInvitation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationPost" (
    "id" SERIAL NOT NULL,
    "text" TEXT,
    "mediaUrl" TEXT,
    "thumbnailUrl" TEXT,
    "mediaType" TEXT,
    "audience" TEXT NOT NULL DEFAULT 'everyone',
    "views" INTEGER NOT NULL DEFAULT 0,
    "organizationId" INTEGER NOT NULL,
    "authorId" INTEGER NOT NULL,
    "pollOptions" JSONB,
    "pollEndsAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "OrganizationPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationPostLike" (
    "id" SERIAL NOT NULL,
    "postId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,

    CONSTRAINT "OrganizationPostLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationPostComment" (
    "id" SERIAL NOT NULL,
    "text" TEXT NOT NULL,
    "postId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "parentId" INTEGER,

    CONSTRAINT "OrganizationPostComment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationFollow" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationFollow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationCommentLike" (
    "id" SERIAL NOT NULL,
    "commentId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationCommentLike_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationPostReaction" (
    "id" SERIAL NOT NULL,
    "emoji" TEXT NOT NULL,
    "postId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationPostReaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedOrganizationPost" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedOrganizationPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HiddenOrganizationPost" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "postId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HiddenOrganizationPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MutedOrganization" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "organizationId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MutedOrganization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrganizationPostVote" (
    "id" SERIAL NOT NULL,
    "postId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "option" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OrganizationPostVote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ManagerCertification" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "fullName" TEXT,
    "phoneNumber" TEXT,
    "clubName" TEXT,
    "cityRegion" TEXT,
    "position" TEXT,
    "email" TEXT,
    "tier" "CertifTier" NOT NULL DEFAULT 'PREMIUM',
    "status" "CertifStatus" NOT NULL DEFAULT 'INCOMPLETE',
    "paymentStatus" BOOLEAN NOT NULL DEFAULT false,
    "transactionId" TEXT,
    "paymentMethod" TEXT,
    "amount" INTEGER,
    "expiryDate" TIMESTAMP(3),
    "lastReminderSent" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ManagerCertification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Stadium" (
    "id" SERIAL NOT NULL,
    "osmId" TEXT,
    "name" TEXT NOT NULL,
    "address" TEXT,
    "city" TEXT,
    "country" TEXT,
    "latitude" DOUBLE PRECISION NOT NULL,
    "longitude" DOUBLE PRECISION NOT NULL,
    "sport" TEXT NOT NULL DEFAULT 'football',
    "imageUrl" TEXT,
    "wikipedia" TEXT,
    "operator" TEXT,
    "capacity" TEXT,
    "surface" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Stadium_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContactMessage" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'support',
    "userId" INTEGER,
    "fullName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT,
    "subject" TEXT,
    "message" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'NEW',
    "adminReply" TEXT,
    "repliedAt" TIMESTAMP(3),
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ContactMessage_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BlogPost" (
    "id" SERIAL NOT NULL,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "subtitle" TEXT,
    "content" TEXT NOT NULL,
    "coverImage" TEXT,
    "tag" TEXT NOT NULL DEFAULT 'Actualité',
    "readTime" INTEGER NOT NULL DEFAULT 5,
    "authorName" TEXT NOT NULL,
    "authorRole" TEXT,
    "authorBio" TEXT,
    "authorAvatar" TEXT,
    "isPublished" BOOLEAN NOT NULL DEFAULT false,
    "publishedAt" TIMESTAMP(3),
    "views" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BlogPost_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "KudosPurchase" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "packId" TEXT NOT NULL,
    "kudosAmount" INTEGER NOT NULL,
    "amountXof" INTEGER NOT NULL,
    "refCommand" TEXT NOT NULL,
    "token" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "paymentMethod" TEXT,
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "KudosPurchase_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "KudosConversion" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "kudosConverted" INTEGER NOT NULL,
    "amountFcfaBrut" INTEGER NOT NULL,
    "commissionPct" INTEGER NOT NULL DEFAULT 50,
    "commissionFcfa" INTEGER NOT NULL,
    "amountNetFcfa" INTEGER NOT NULL,
    "currency" TEXT NOT NULL,
    "amountNetLocal" DOUBLE PRECISION NOT NULL,
    "exchangeRate" DOUBLE PRECISION NOT NULL,
    "paymentMethod" TEXT,
    "paymentDetails" TEXT,
    "status" TEXT NOT NULL DEFAULT 'PENDING',
    "refCommand" TEXT NOT NULL,
    "adminNote" TEXT,
    "processedAt" TIMESTAMP(3),
    "paidAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "KudosConversion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_CommunityMembers" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_ChatTabToConversation" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "_OrganizationMembers" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_phoneNumber_key" ON "User"("phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "User_referralCode_key" ON "User"("referralCode");

-- CreateIndex
CREATE INDEX "Post_userId_isArchived_communityId_mediaType_createdAt_idx" ON "Post"("userId", "isArchived", "communityId", "mediaType", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "PollVote_postId_userId_key" ON "PollVote"("postId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "Like_userId_postId_key" ON "Like"("userId", "postId");

-- CreateIndex
CREATE INDEX "Kudos_postId_idx" ON "Kudos"("postId");

-- CreateIndex
CREATE INDEX "Kudos_userId_createdAt_idx" ON "Kudos"("userId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "Kudos_userId_postId_key" ON "Kudos"("userId", "postId");

-- CreateIndex
CREATE UNIQUE INDEX "RatingLike_userId_ratingId_key" ON "RatingLike"("userId", "ratingId");

-- CreateIndex
CREATE UNIQUE INDEX "Follow_followerId_followingId_key" ON "Follow"("followerId", "followingId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedPost_userId_postId_key" ON "SavedPost"("userId", "postId");

-- CreateIndex
CREATE UNIQUE INDEX "HiddenPost_userId_postId_key" ON "HiddenPost"("userId", "postId");

-- CreateIndex
CREATE UNIQUE INDEX "Block_blockerId_blockedId_key" ON "Block"("blockerId", "blockedId");

-- CreateIndex
CREATE INDEX "Notification_receiverId_createdAt_idx" ON "Notification"("receiverId", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "Notification_receiverId_type_idx" ON "Notification"("receiverId", "type");

-- CreateIndex
CREATE INDEX "Notification_receiverId_isRead_idx" ON "Notification"("receiverId", "isRead");

-- CreateIndex
CREATE UNIQUE INDEX "EventPayout_eventId_key" ON "EventPayout"("eventId");

-- CreateIndex
CREATE INDEX "EventPayout_managerId_idx" ON "EventPayout"("managerId");

-- CreateIndex
CREATE INDEX "EventPayout_paymentMethod_idx" ON "EventPayout"("paymentMethod");

-- CreateIndex
CREATE UNIQUE INDEX "EventTicketPayment_refCommand_key" ON "EventTicketPayment"("refCommand");

-- CreateIndex
CREATE INDEX "EventTicketPayment_status_paidAt_idx" ON "EventTicketPayment"("status", "paidAt");

-- CreateIndex
CREATE INDEX "EventTicketPayment_eventId_status_idx" ON "EventTicketPayment"("eventId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "EventTicketPayment_buyerId_eventId_key" ON "EventTicketPayment"("buyerId", "eventId");

-- CreateIndex
CREATE UNIQUE INDEX "EventParticipant_eventId_userId_key" ON "EventParticipant"("eventId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "TargetPlayer_managerId_playerId_key" ON "TargetPlayer"("managerId", "playerId");

-- CreateIndex
CREATE UNIQUE INDEX "Community_name_key" ON "Community"("name");

-- CreateIndex
CREATE UNIQUE INDEX "CommunityRequest_communityId_userId_key" ON "CommunityRequest"("communityId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerCertification_userId_key" ON "PlayerCertification"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerCertification_transactionId_key" ON "PlayerCertification"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "PlayerCertification_originalTransactionId_key" ON "PlayerCertification"("originalTransactionId");

-- CreateIndex
CREATE UNIQUE INDEX "DuelVote_duelId_voterId_key" ON "DuelVote"("duelId", "voterId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryLike_userId_storyId_key" ON "StoryLike"("userId", "storyId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryView_userId_storyId_key" ON "StoryView"("userId", "storyId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryFlame_userId_storyId_key" ON "StoryFlame"("userId", "storyId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryPoll_storyId_key" ON "StoryPoll"("storyId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryPollVote_pollId_userId_key" ON "StoryPollVote"("pollId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "Shop_ownerId_key" ON "Shop"("ownerId");

-- CreateIndex
CREATE UNIQUE INDEX "ShopCertification_shopId_key" ON "ShopCertification"("shopId");

-- CreateIndex
CREATE UNIQUE INDEX "ShopCertification_transactionId_key" ON "ShopCertification"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "ProductLike_userId_productId_key" ON "ProductLike"("userId", "productId");

-- CreateIndex
CREATE UNIQUE INDEX "SuggestionDismiss_userId_targetId_key" ON "SuggestionDismiss"("userId", "targetId");

-- CreateIndex
CREATE UNIQUE INDEX "NewsReaction_userId_newsId_key" ON "NewsReaction"("userId", "newsId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedNews_userId_newsId_key" ON "SavedNews"("userId", "newsId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedStory_userId_storyId_key" ON "SavedStory"("userId", "storyId");

-- CreateIndex
CREATE UNIQUE INDEX "BroadcastView_broadcastId_userId_key" ON "BroadcastView"("broadcastId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryMention_storyId_userId_key" ON "StoryMention"("storyId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "PostMention_postId_userId_key" ON "PostMention"("postId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "CommunityCertification_communityId_key" ON "CommunityCertification"("communityId");

-- CreateIndex
CREATE UNIQUE INDEX "CommunityCertification_transactionId_key" ON "CommunityCertification"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "ShopLike_userId_shopId_key" ON "ShopLike"("userId", "shopId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedProduct_userId_productId_key" ON "SavedProduct"("userId", "productId");

-- CreateIndex
CREATE INDEX "SearchHistory_userId_idx" ON "SearchHistory"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Mute_muterId_mutedId_key" ON "Mute"("muterId", "mutedId");

-- CreateIndex
CREATE UNIQUE INDEX "ProfileView_viewerId_profileOwnerId_key" ON "ProfileView"("viewerId", "profileOwnerId");

-- CreateIndex
CREATE INDEX "UserBehavior_userId_idx" ON "UserBehavior"("userId");

-- CreateIndex
CREATE INDEX "UserBehavior_actionType_idx" ON "UserBehavior"("actionType");

-- CreateIndex
CREATE UNIQUE INDEX "MatchStats_matchId_key" ON "MatchStats"("matchId");

-- CreateIndex
CREATE UNIQUE INDEX "Standing_ascId_zoneId_key" ON "Standing"("ascId", "zoneId");

-- CreateIndex
CREATE INDEX "ProximityAlert_receiverId_createdAt_idx" ON "ProximityAlert"("receiverId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "ProximityAlert_senderId_receiverId_key" ON "ProximityAlert"("senderId", "receiverId");

-- CreateIndex
CREATE INDEX "CareerStep_userId_idx" ON "CareerStep"("userId");

-- CreateIndex
CREATE INDEX "Trophy_userId_idx" ON "Trophy"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Conversation_user1Id_user2Id_key" ON "Conversation"("user1Id", "user2Id");

-- CreateIndex
CREATE UNIQUE INDEX "MessageDeletion_userId_messageId_key" ON "MessageDeletion"("userId", "messageId");

-- CreateIndex
CREATE INDEX "MessageReaction_messageId_idx" ON "MessageReaction"("messageId");

-- CreateIndex
CREATE INDEX "MessageReaction_userId_idx" ON "MessageReaction"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "MessageReaction_messageId_userId_key" ON "MessageReaction"("messageId", "userId");

-- CreateIndex
CREATE INDEX "UserPostView_userId_seenAt_idx" ON "UserPostView"("userId", "seenAt");

-- CreateIndex
CREATE INDEX "UserPostView_userId_action_idx" ON "UserPostView"("userId", "action");

-- CreateIndex
CREATE UNIQUE INDEX "UserPostView_userId_postId_key" ON "UserPostView"("userId", "postId");

-- CreateIndex
CREATE UNIQUE INDEX "TrainingReaction_sessionId_userId_key" ON "TrainingReaction"("sessionId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "CVPayment_refCommand_key" ON "CVPayment"("refCommand");

-- CreateIndex
CREATE INDEX "PropulseAd_isActive_startDate_endDate_idx" ON "PropulseAd"("isActive", "startDate", "endDate");

-- CreateIndex
CREATE INDEX "PropulseAd_targetRole_targetSport_idx" ON "PropulseAd"("targetRole", "targetSport");

-- CreateIndex
CREATE INDEX "PropulseAd_priority_idx" ON "PropulseAd"("priority");

-- CreateIndex
CREATE INDEX "PropulseAdImage_adId_idx" ON "PropulseAdImage"("adId");

-- CreateIndex
CREATE INDEX "PropulseAdImage_order_idx" ON "PropulseAdImage"("order");

-- CreateIndex
CREATE INDEX "PropulseAdImpression_adId_viewedAt_idx" ON "PropulseAdImpression"("adId", "viewedAt");

-- CreateIndex
CREATE UNIQUE INDEX "PropulseAdImpression_adId_userId_key" ON "PropulseAdImpression"("adId", "userId");

-- CreateIndex
CREATE INDEX "PropulseAdClick_adId_clickedAt_idx" ON "PropulseAdClick"("adId", "clickedAt");

-- CreateIndex
CREATE UNIQUE INDEX "PropulseAdClick_adId_userId_key" ON "PropulseAdClick"("adId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "CertificationPayment_refCommand_key" ON "CertificationPayment"("refCommand");

-- CreateIndex
CREATE INDEX "UserSession_userId_idx" ON "UserSession"("userId");

-- CreateIndex
CREATE INDEX "UserSession_createdAt_idx" ON "UserSession"("createdAt");

-- CreateIndex
CREATE INDEX "Sticker_type_idx" ON "Sticker"("type");

-- CreateIndex
CREATE INDEX "Sticker_category_idx" ON "Sticker"("category");

-- CreateIndex
CREATE UNIQUE INDEX "StorySlider_storyId_key" ON "StorySlider"("storyId");

-- CreateIndex
CREATE UNIQUE INDEX "StorySliderVote_sliderId_userId_key" ON "StorySliderVote"("sliderId", "userId");

-- CreateIndex
CREATE INDEX "ChatTab_userId_idx" ON "ChatTab"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "StoryAudioLike_userId_storyAudioId_key" ON "StoryAudioLike"("userId", "storyAudioId");

-- CreateIndex
CREATE UNIQUE INDEX "TournamentParticipant_tournamentId_userId_key" ON "TournamentParticipant"("tournamentId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "TournamentMatch_tournamentId_round_position_key" ON "TournamentMatch"("tournamentId", "round", "position");

-- CreateIndex
CREATE UNIQUE INDEX "LiveStream_matchId_key" ON "LiveStream"("matchId");

-- CreateIndex
CREATE UNIQUE INDEX "LiveStream_tournamentId_key" ON "LiveStream"("tournamentId");

-- CreateIndex
CREATE UNIQUE INDEX "Organization_name_key" ON "Organization"("name");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationRequest_organizationId_userId_key" ON "OrganizationRequest"("organizationId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationInvitation_organizationId_userId_key" ON "OrganizationInvitation"("organizationId", "userId");

-- CreateIndex
CREATE INDEX "OrganizationPost_organizationId_idx" ON "OrganizationPost"("organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationPostLike_postId_userId_key" ON "OrganizationPostLike"("postId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationFollow_userId_organizationId_key" ON "OrganizationFollow"("userId", "organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationCommentLike_commentId_userId_key" ON "OrganizationCommentLike"("commentId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationPostReaction_postId_userId_key" ON "OrganizationPostReaction"("postId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedOrganizationPost_userId_postId_key" ON "SavedOrganizationPost"("userId", "postId");

-- CreateIndex
CREATE UNIQUE INDEX "HiddenOrganizationPost_userId_postId_key" ON "HiddenOrganizationPost"("userId", "postId");

-- CreateIndex
CREATE UNIQUE INDEX "MutedOrganization_userId_organizationId_key" ON "MutedOrganization"("userId", "organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "OrganizationPostVote_postId_userId_key" ON "OrganizationPostVote"("postId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "ManagerCertification_userId_key" ON "ManagerCertification"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "ManagerCertification_transactionId_key" ON "ManagerCertification"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "Stadium_osmId_key" ON "Stadium"("osmId");

-- CreateIndex
CREATE INDEX "Stadium_name_idx" ON "Stadium"("name");

-- CreateIndex
CREATE INDEX "ContactMessage_status_createdAt_idx" ON "ContactMessage"("status", "createdAt" DESC);

-- CreateIndex
CREATE INDEX "ContactMessage_type_idx" ON "ContactMessage"("type");

-- CreateIndex
CREATE UNIQUE INDEX "BlogPost_slug_key" ON "BlogPost"("slug");

-- CreateIndex
CREATE INDEX "BlogPost_isPublished_publishedAt_idx" ON "BlogPost"("isPublished", "publishedAt" DESC);

-- CreateIndex
CREATE UNIQUE INDEX "KudosPurchase_refCommand_key" ON "KudosPurchase"("refCommand");

-- CreateIndex
CREATE INDEX "KudosPurchase_userId_createdAt_idx" ON "KudosPurchase"("userId", "createdAt");

-- CreateIndex
CREATE INDEX "KudosPurchase_status_idx" ON "KudosPurchase"("status");

-- CreateIndex
CREATE UNIQUE INDEX "KudosConversion_refCommand_key" ON "KudosConversion"("refCommand");

-- CreateIndex
CREATE INDEX "KudosConversion_userId_status_idx" ON "KudosConversion"("userId", "status");

-- CreateIndex
CREATE INDEX "KudosConversion_status_idx" ON "KudosConversion"("status");

-- CreateIndex
CREATE INDEX "KudosConversion_createdAt_idx" ON "KudosConversion"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "_CommunityMembers_AB_unique" ON "_CommunityMembers"("A", "B");

-- CreateIndex
CREATE INDEX "_CommunityMembers_B_index" ON "_CommunityMembers"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ChatTabToConversation_AB_unique" ON "_ChatTabToConversation"("A", "B");

-- CreateIndex
CREATE INDEX "_ChatTabToConversation_B_index" ON "_ChatTabToConversation"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_OrganizationMembers_AB_unique" ON "_OrganizationMembers"("A", "B");

-- CreateIndex
CREATE INDEX "_OrganizationMembers_B_index" ON "_OrganizationMembers"("B");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_referredById_fkey" FOREIGN KEY ("referredById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_ascId_fkey" FOREIGN KEY ("ascId") REFERENCES "Asc"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "Community"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Post" ADD CONSTRAINT "Post_audioId_fkey" FOREIGN KEY ("audioId") REFERENCES "StoryAudio"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostMedia" ADD CONSTRAINT "PostMedia_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PollVote" ADD CONSTRAINT "PollVote_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PollVote" ADD CONSTRAINT "PollVote_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Like" ADD CONSTRAINT "Like_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Like" ADD CONSTRAINT "Like_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kudos" ADD CONSTRAINT "Kudos_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kudos" ADD CONSTRAINT "Kudos_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Rating"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Rating" ADD CONSTRAINT "Rating_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RatingLike" ADD CONSTRAINT "RatingLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RatingLike" ADD CONSTRAINT "RatingLike_ratingId_fkey" FOREIGN KEY ("ratingId") REFERENCES "Rating"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Share" ADD CONSTRAINT "Share_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Share" ADD CONSTRAINT "Share_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Share" ADD CONSTRAINT "Share_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedPost" ADD CONSTRAINT "SavedPost_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedPost" ADD CONSTRAINT "SavedPost_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_organizationPostId_fkey" FOREIGN KEY ("organizationPostId") REFERENCES "OrganizationPost"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HiddenPost" ADD CONSTRAINT "HiddenPost_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HiddenPost" ADD CONSTRAINT "HiddenPost_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Block" ADD CONSTRAINT "Block_blockerId_fkey" FOREIGN KEY ("blockerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Block" ADD CONSTRAINT "Block_blockedId_fkey" FOREIGN KEY ("blockedId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_orgPostId_fkey" FOREIGN KEY ("orgPostId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_ratingId_fkey" FOREIGN KEY ("ratingId") REFERENCES "Rating"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "Community"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_newsId_fkey" FOREIGN KEY ("newsId") REFERENCES "NewsArticle"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_trainingId_fkey" FOREIGN KEY ("trainingId") REFERENCES "TrainingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "Community"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventPayout" ADD CONSTRAINT "EventPayout_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventPayout" ADD CONSTRAINT "EventPayout_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventTicketPayment" ADD CONSTRAINT "EventTicketPayment_buyerId_fkey" FOREIGN KEY ("buyerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventTicketPayment" ADD CONSTRAINT "EventTicketPayment_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventParticipant" ADD CONSTRAINT "EventParticipant_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "Event"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EventParticipant" ADD CONSTRAINT "EventParticipant_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TargetPlayer" ADD CONSTRAINT "TargetPlayer_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TargetPlayer" ADD CONSTRAINT "TargetPlayer_playerId_fkey" FOREIGN KEY ("playerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Community" ADD CONSTRAINT "Community_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommunityRequest" ADD CONSTRAINT "CommunityRequest_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "Community"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommunityRequest" ADD CONSTRAINT "CommunityRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCertification" ADD CONSTRAINT "PlayerCertification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Duel" ADD CONSTRAINT "Duel_post1Id_fkey" FOREIGN KEY ("post1Id") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Duel" ADD CONSTRAINT "Duel_post2Id_fkey" FOREIGN KEY ("post2Id") REFERENCES "Post"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DuelVote" ADD CONSTRAINT "DuelVote_duelId_fkey" FOREIGN KEY ("duelId") REFERENCES "Duel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DuelVote" ADD CONSTRAINT "DuelVote_voterId_fkey" FOREIGN KEY ("voterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SupportTicket" ADD CONSTRAINT "SupportTicket_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Story" ADD CONSTRAINT "Story_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Story" ADD CONSTRAINT "Story_sharedPostId_fkey" FOREIGN KEY ("sharedPostId") REFERENCES "Post"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Story" ADD CONSTRAINT "Story_storyAudioId_fkey" FOREIGN KEY ("storyAudioId") REFERENCES "StoryAudio"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryLike" ADD CONSTRAINT "StoryLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryLike" ADD CONSTRAINT "StoryLike_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryComment" ADD CONSTRAINT "StoryComment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "StoryComment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryComment" ADD CONSTRAINT "StoryComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryComment" ADD CONSTRAINT "StoryComment_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryView" ADD CONSTRAINT "StoryView_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryView" ADD CONSTRAINT "StoryView_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryFlame" ADD CONSTRAINT "StoryFlame_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryFlame" ADD CONSTRAINT "StoryFlame_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryPoll" ADD CONSTRAINT "StoryPoll_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryPollVote" ADD CONSTRAINT "StoryPollVote_pollId_fkey" FOREIGN KEY ("pollId") REFERENCES "StoryPoll"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryPollVote" ADD CONSTRAINT "StoryPollVote_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Shop" ADD CONSTRAINT "Shop_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShopMember" ADD CONSTRAINT "ShopMember_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShopMember" ADD CONSTRAINT "ShopMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShopCertification" ADD CONSTRAINT "ShopCertification_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Product" ADD CONSTRAINT "Product_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductImage" ADD CONSTRAINT "ProductImage_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductLike" ADD CONSTRAINT "ProductLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProductLike" ADD CONSTRAINT "ProductLike_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_buyerId_fkey" FOREIGN KEY ("buyerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SuggestionDismiss" ADD CONSTRAINT "SuggestionDismiss_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SuggestionDismiss" ADD CONSTRAINT "SuggestionDismiss_targetId_fkey" FOREIGN KEY ("targetId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NewsReaction" ADD CONSTRAINT "NewsReaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NewsReaction" ADD CONSTRAINT "NewsReaction_newsId_fkey" FOREIGN KEY ("newsId") REFERENCES "NewsArticle"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedNews" ADD CONSTRAINT "SavedNews_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedNews" ADD CONSTRAINT "SavedNews_newsId_fkey" FOREIGN KEY ("newsId") REFERENCES "NewsArticle"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedStory" ADD CONSTRAINT "SavedStory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedStory" ADD CONSTRAINT "SavedStory_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BroadcastView" ADD CONSTRAINT "BroadcastView_broadcastId_fkey" FOREIGN KEY ("broadcastId") REFERENCES "Broadcast"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BroadcastView" ADD CONSTRAINT "BroadcastView_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryMention" ADD CONSTRAINT "StoryMention_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryMention" ADD CONSTRAINT "StoryMention_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostMention" ADD CONSTRAINT "PostMention_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PostMention" ADD CONSTRAINT "PostMention_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommunityCertification" ADD CONSTRAINT "CommunityCertification_communityId_fkey" FOREIGN KEY ("communityId") REFERENCES "Community"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShopLike" ADD CONSTRAINT "ShopLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ShopLike" ADD CONSTRAINT "ShopLike_shopId_fkey" FOREIGN KEY ("shopId") REFERENCES "Shop"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedProduct" ADD CONSTRAINT "SavedProduct_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedProduct" ADD CONSTRAINT "SavedProduct_productId_fkey" FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SearchHistory" ADD CONSTRAINT "SearchHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mute" ADD CONSTRAINT "Mute_muterId_fkey" FOREIGN KEY ("muterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mute" ADD CONSTRAINT "Mute_mutedId_fkey" FOREIGN KEY ("mutedId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProfileView" ADD CONSTRAINT "ProfileView_viewerId_fkey" FOREIGN KEY ("viewerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProfileView" ADD CONSTRAINT "ProfileView_profileOwnerId_fkey" FOREIGN KEY ("profileOwnerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserBehavior" ADD CONSTRAINT "UserBehavior_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Region" ADD CONSTRAINT "Region_competitionId_fkey" FOREIGN KEY ("competitionId") REFERENCES "Competition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Department" ADD CONSTRAINT "Department_regionId_fkey" FOREIGN KEY ("regionId") REFERENCES "Region"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Zone" ADD CONSTRAINT "Zone_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Asc" ADD CONSTRAINT "Asc_zoneId_fkey" FOREIGN KEY ("zoneId") REFERENCES "Zone"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Match" ADD CONSTRAINT "Match_homeTeamId_fkey" FOREIGN KEY ("homeTeamId") REFERENCES "Asc"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Match" ADD CONSTRAINT "Match_awayTeamId_fkey" FOREIGN KEY ("awayTeamId") REFERENCES "Asc"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Match" ADD CONSTRAINT "Match_zoneId_fkey" FOREIGN KEY ("zoneId") REFERENCES "Zone"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchEvent" ADD CONSTRAINT "MatchEvent_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchLineup" ADD CONSTRAINT "MatchLineup_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchStats" ADD CONSTRAINT "MatchStats_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Standing" ADD CONSTRAINT "Standing_ascId_fkey" FOREIGN KEY ("ascId") REFERENCES "Asc"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Standing" ADD CONSTRAINT "Standing_zoneId_fkey" FOREIGN KEY ("zoneId") REFERENCES "Zone"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchComment" ADD CONSTRAINT "MatchComment_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "Match"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MatchComment" ADD CONSTRAINT "MatchComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProximityAlert" ADD CONSTRAINT "ProximityAlert_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ProximityAlert" ADD CONSTRAINT "ProximityAlert_receiverId_fkey" FOREIGN KEY ("receiverId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CareerStep" ADD CONSTRAINT "CareerStep_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trophy" ADD CONSTRAINT "Trophy_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CareerTeaserInteraction" ADD CONSTRAINT "CareerTeaserInteraction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_user1Id_fkey" FOREIGN KEY ("user1Id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_user2Id_fkey" FOREIGN KEY ("user2Id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_sharedPostId_fkey" FOREIGN KEY ("sharedPostId") REFERENCES "Post"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_sharedOrgPostId_fkey" FOREIGN KEY ("sharedOrgPostId") REFERENCES "OrganizationPost"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_sharedAudioId_fkey" FOREIGN KEY ("sharedAudioId") REFERENCES "StoryAudio"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_sharedStoryId_fkey" FOREIGN KEY ("sharedStoryId") REFERENCES "Story"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_replyToId_fkey" FOREIGN KEY ("replyToId") REFERENCES "Message"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageReport" ADD CONSTRAINT "MessageReport_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageReport" ADD CONSTRAINT "MessageReport_reporterId_fkey" FOREIGN KEY ("reporterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageDeletion" ADD CONSTRAINT "MessageDeletion_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageReaction" ADD CONSTRAINT "MessageReaction_messageId_fkey" FOREIGN KEY ("messageId") REFERENCES "Message"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MessageReaction" ADD CONSTRAINT "MessageReaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingSession" ADD CONSTRAINT "TrainingSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingFeedback" ADD CONSTRAINT "TrainingFeedback_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "TrainingSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingFeedback" ADD CONSTRAINT "TrainingFeedback_reviewerId_fkey" FOREIGN KEY ("reviewerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingTarget" ADD CONSTRAINT "TrainingTarget_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "TrainingSession"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingTarget" ADD CONSTRAINT "TrainingTarget_targetUserId_fkey" FOREIGN KEY ("targetUserId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPostView" ADD CONSTRAINT "UserPostView_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserPostView" ADD CONSTRAINT "UserPostView_postId_fkey" FOREIGN KEY ("postId") REFERENCES "Post"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingReaction" ADD CONSTRAINT "TrainingReaction_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "TrainingSession"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TrainingReaction" ADD CONSTRAINT "TrainingReaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CVPayment" ADD CONSTRAINT "CVPayment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PropulseAdImage" ADD CONSTRAINT "PropulseAdImage_adId_fkey" FOREIGN KEY ("adId") REFERENCES "PropulseAd"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PropulseAdImpression" ADD CONSTRAINT "PropulseAdImpression_adId_fkey" FOREIGN KEY ("adId") REFERENCES "PropulseAd"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PropulseAdImpression" ADD CONSTRAINT "PropulseAdImpression_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PropulseAdClick" ADD CONSTRAINT "PropulseAdClick_adId_fkey" FOREIGN KEY ("adId") REFERENCES "PropulseAd"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PropulseAdClick" ADD CONSTRAINT "PropulseAdClick_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CertificationPayment" ADD CONSTRAINT "CertificationPayment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserSession" ADD CONSTRAINT "UserSession_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorySlider" ADD CONSTRAINT "StorySlider_storyId_fkey" FOREIGN KEY ("storyId") REFERENCES "Story"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorySliderVote" ADD CONSTRAINT "StorySliderVote_sliderId_fkey" FOREIGN KEY ("sliderId") REFERENCES "StorySlider"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorySliderVote" ADD CONSTRAINT "StorySliderVote_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatTab" ADD CONSTRAINT "ChatTab_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryAudio" ADD CONSTRAINT "StoryAudio_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryAudioLike" ADD CONSTRAINT "StoryAudioLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StoryAudioLike" ADD CONSTRAINT "StoryAudioLike_storyAudioId_fkey" FOREIGN KEY ("storyAudioId") REFERENCES "StoryAudio"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tournament" ADD CONSTRAINT "Tournament_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Tournament" ADD CONSTRAINT "Tournament_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentParticipant" ADD CONSTRAINT "TournamentParticipant_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES "Tournament"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentParticipant" ADD CONSTRAINT "TournamentParticipant_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatch" ADD CONSTRAINT "TournamentMatch_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES "Tournament"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatch" ADD CONSTRAINT "TournamentMatch_playerAId_fkey" FOREIGN KEY ("playerAId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatch" ADD CONSTRAINT "TournamentMatch_playerBId_fkey" FOREIGN KEY ("playerBId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatch" ADD CONSTRAINT "TournamentMatch_winnerId_fkey" FOREIGN KEY ("winnerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatch" ADD CONSTRAINT "TournamentMatch_nextMatchId_fkey" FOREIGN KEY ("nextMatchId") REFERENCES "TournamentMatch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStream" ADD CONSTRAINT "LiveStream_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "TournamentMatch"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStream" ADD CONSTRAINT "LiveStream_tournamentId_fkey" FOREIGN KEY ("tournamentId") REFERENCES "Tournament"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "LiveStream" ADD CONSTRAINT "LiveStream_streamerId_fkey" FOREIGN KEY ("streamerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatchComment" ADD CONSTRAINT "TournamentMatchComment_matchId_fkey" FOREIGN KEY ("matchId") REFERENCES "TournamentMatch"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TournamentMatchComment" ADD CONSTRAINT "TournamentMatchComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Organization" ADD CONSTRAINT "Organization_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationRequest" ADD CONSTRAINT "OrganizationRequest_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationRequest" ADD CONSTRAINT "OrganizationRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationInvitation" ADD CONSTRAINT "OrganizationInvitation_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationInvitation" ADD CONSTRAINT "OrganizationInvitation_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPost" ADD CONSTRAINT "OrganizationPost_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPost" ADD CONSTRAINT "OrganizationPost_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostLike" ADD CONSTRAINT "OrganizationPostLike_postId_fkey" FOREIGN KEY ("postId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostLike" ADD CONSTRAINT "OrganizationPostLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostComment" ADD CONSTRAINT "OrganizationPostComment_postId_fkey" FOREIGN KEY ("postId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostComment" ADD CONSTRAINT "OrganizationPostComment_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostComment" ADD CONSTRAINT "OrganizationPostComment_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "OrganizationPostComment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationFollow" ADD CONSTRAINT "OrganizationFollow_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationFollow" ADD CONSTRAINT "OrganizationFollow_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationCommentLike" ADD CONSTRAINT "OrganizationCommentLike_commentId_fkey" FOREIGN KEY ("commentId") REFERENCES "OrganizationPostComment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationCommentLike" ADD CONSTRAINT "OrganizationCommentLike_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostReaction" ADD CONSTRAINT "OrganizationPostReaction_postId_fkey" FOREIGN KEY ("postId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostReaction" ADD CONSTRAINT "OrganizationPostReaction_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedOrganizationPost" ADD CONSTRAINT "SavedOrganizationPost_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedOrganizationPost" ADD CONSTRAINT "SavedOrganizationPost_postId_fkey" FOREIGN KEY ("postId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HiddenOrganizationPost" ADD CONSTRAINT "HiddenOrganizationPost_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HiddenOrganizationPost" ADD CONSTRAINT "HiddenOrganizationPost_postId_fkey" FOREIGN KEY ("postId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MutedOrganization" ADD CONSTRAINT "MutedOrganization_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MutedOrganization" ADD CONSTRAINT "MutedOrganization_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostVote" ADD CONSTRAINT "OrganizationPostVote_postId_fkey" FOREIGN KEY ("postId") REFERENCES "OrganizationPost"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrganizationPostVote" ADD CONSTRAINT "OrganizationPostVote_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ManagerCertification" ADD CONSTRAINT "ManagerCertification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContactMessage" ADD CONSTRAINT "ContactMessage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "KudosPurchase" ADD CONSTRAINT "KudosPurchase_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "KudosConversion" ADD CONSTRAINT "KudosConversion_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CommunityMembers" ADD CONSTRAINT "_CommunityMembers_A_fkey" FOREIGN KEY ("A") REFERENCES "Community"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_CommunityMembers" ADD CONSTRAINT "_CommunityMembers_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChatTabToConversation" ADD CONSTRAINT "_ChatTabToConversation_A_fkey" FOREIGN KEY ("A") REFERENCES "ChatTab"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ChatTabToConversation" ADD CONSTRAINT "_ChatTabToConversation_B_fkey" FOREIGN KEY ("B") REFERENCES "Conversation"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_OrganizationMembers" ADD CONSTRAINT "_OrganizationMembers_A_fkey" FOREIGN KEY ("A") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_OrganizationMembers" ADD CONSTRAINT "_OrganizationMembers_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
