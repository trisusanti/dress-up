/*
  Warnings:

  - You are about to drop the column `address` on the `User` table. All the data in the column will be lost.
  - Made the column `phone` on table `User` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
UPDATE "User" SET "phone" = '0000000000' WHERE "phone" IS NULL;
ALTER TABLE "User" DROP COLUMN "address",
ALTER COLUMN "phone" SET NOT NULL;
