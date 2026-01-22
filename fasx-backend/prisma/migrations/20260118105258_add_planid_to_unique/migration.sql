/*
  Warnings:

  - A unique constraint covering the columns `[userId,tableName,month,planId]` on the table `PlanningNote` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId,tableName,label,planId]` on the table `PlanningRow` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX "PlanningNote_userId_tableName_month_key";

-- DropIndex
DROP INDEX "PlanningRow_userId_tableName_label_key";

-- CreateIndex
CREATE UNIQUE INDEX "PlanningNote_userId_tableName_month_planId_key" ON "PlanningNote"("userId", "tableName", "month", "planId");

-- CreateIndex
CREATE UNIQUE INDEX "PlanningRow_userId_tableName_label_planId_key" ON "PlanningRow"("userId", "tableName", "label", "planId");
