[1G[0K\[1G[0K-- CreateEnum
CREATE TYPE "WorkoutType" AS ENUM ('Running', 'XC_Skiing_Classic', 'XC_Skiing_Skate', 'RollerSki_Classic', 'StrengthTraining', 'Other', 'Bike', 'RollerSki_Skate');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "avatarUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "isVerified" BOOLEAN NOT NULL DEFAULT false,
    "verificationToken" TEXT,
    "originalAvatarUrl" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Workout" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "distance" DOUBLE PRECISION,
    "duration" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "zone1Min" INTEGER NOT NULL DEFAULT 0,
    "zone2Min" INTEGER NOT NULL DEFAULT 0,
    "zone3Min" INTEGER NOT NULL DEFAULT 0,
    "zone4Min" INTEGER NOT NULL DEFAULT 0,
    "zone5Min" INTEGER NOT NULL DEFAULT 0,
    "type" "WorkoutType" NOT NULL,
    "name" TEXT NOT NULL,
    "comment" TEXT,
    "effort" INTEGER,
    "feeling" INTEGER,
    "updatedAt" TIMESTAMP(3),

    CONSTRAINT "Workout_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Follow" (
    "id" TEXT NOT NULL,
    "followerId" TEXT NOT NULL,
    "followingId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Follow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "bio" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "gender" TEXT DEFAULT 'Мужчина',
    "sportType" TEXT DEFAULT 'Лыжные гонки',
    "club" TEXT DEFAULT 'Не указан',
    "association" TEXT DEFAULT 'ФЛГР',
    "hrZones" JSONB DEFAULT '{"I1": "118-143", "I2": "143-161", "I3": "161-171", "I4": "171-181", "I5": "181-200"}',
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DailyInformation" (
    "id" SERIAL NOT NULL,
    "userId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "main_param" TEXT,
    "physical" INTEGER NOT NULL DEFAULT 0,
    "mental" INTEGER NOT NULL DEFAULT 0,
    "sleep_quality" INTEGER NOT NULL DEFAULT 0,
    "pulse" INTEGER,
    "sleep_duration" TEXT,
    "comment" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DailyInformation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanningRow" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tableName" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "values" DOUBLE PRECISION[],
    "isDouble" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlanningRow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlanningNote" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "tableName" TEXT NOT NULL,
    "month" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PlanningNote_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Profile_userId_key" ON "Profile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "PlanningRow_userId_tableName_label_key" ON "PlanningRow"("userId", "tableName", "label");

-- CreateIndex
CREATE UNIQUE INDEX "PlanningNote_userId_tableName_month_key" ON "PlanningNote"("userId", "tableName", "month");

-- AddForeignKey
ALTER TABLE "Workout" ADD CONSTRAINT "Workout_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followerId_fkey" FOREIGN KEY ("followerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Follow" ADD CONSTRAINT "Follow_followingId_fkey" FOREIGN KEY ("followingId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Profile" ADD CONSTRAINT "Profile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DailyInformation" ADD CONSTRAINT "fk_daily_user" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanningRow" ADD CONSTRAINT "PlanningRow_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlanningNote" ADD CONSTRAINT "PlanningNote_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

[90m[90m┌─[39m[90m[90m────────────────────────────────────────────────────────┐[39m[90m
[90m│[39m[90m  [0m[34mUpdate available[39m[90m 6.9.0 -> 7.2.0[0m                        [90m│[39m[90m
[90m│[39m[90m  [0m[0m                                                       [90m│[39m[90m
[90m│[39m[90m  [0mThis is a major update - please follow the guide at[0m    [90m│[39m[90m
[90m│[39m[90m  [0mhttps://pris.ly/d/major-version-upgrade[0m                [90m│[39m[90m
[90m│[39m[90m  [0m[0m                                                       [90m│[39m[90m
[90m│[39m[90m  [0mRun the following to update[0m                            [90m│[39m[90m
[90m│[39m[90m  [0m  [1mnpm i --save-dev prisma@latest[22m[0m                       [90m│[39m[90m
[90m│[39m[90m  [0m  [1mnpm i @prisma/client@latest[22m[0m                          [90m│[39m[90m
└─────────────────────────────────────────────────────────┘[39m
[1G[0K\[1G[0K