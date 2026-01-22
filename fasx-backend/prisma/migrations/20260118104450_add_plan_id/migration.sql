/*
  Warnings:

  - Made the column `planId` on table `PlanningNote` required. This step will fail if there are existing NULL values in that column.
  - Made the column `planId` on table `PlanningRow` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE "PlanningNote" ALTER COLUMN "planId" SET NOT NULL;

-- AlterTable
ALTER TABLE "PlanningRow" ALTER COLUMN "planId" SET NOT NULL;
