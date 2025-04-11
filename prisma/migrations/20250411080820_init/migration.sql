/*
  Warnings:

  - The `status` column on the `Booking` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `Rental` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `condition` column on the `Return` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `status` column on the `Tracking` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `role` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('CUSTOMER', 'ADMIN', 'OWNER');

-- CreateEnum
CREATE TYPE "RentalStatus" AS ENUM ('PENDING', 'ACTIVE', 'COMPLETED');

-- CreateEnum
CREATE TYPE "BookingStatus" AS ENUM ('PENDING', 'CONFIRMED', 'REJECTED', 'COMPLETED', 'CANCELED', 'RESCHEDULED');

-- CreateEnum
CREATE TYPE "TrackingStatus" AS ENUM ('ORDER_RECEIVED', 'RENTAL_ONGOING', 'RETURN_PENDING', 'COMPLETED');

-- CreateEnum
CREATE TYPE "ReturnCondition" AS ENUM ('GOOD', 'DAMAGED', 'LOST');

-- CreateEnum
CREATE TYPE "RescheduleStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- AlterTable
ALTER TABLE "Booking" ADD COLUMN     "rescheduleDate" TIMESTAMP(3),
DROP COLUMN "status",
ADD COLUMN     "status" "BookingStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Rental" DROP COLUMN "status",
ADD COLUMN     "status" "RentalStatus" NOT NULL DEFAULT 'PENDING';

-- AlterTable
ALTER TABLE "Return" DROP COLUMN "condition",
ADD COLUMN     "condition" "ReturnCondition" NOT NULL DEFAULT 'GOOD';

-- AlterTable
ALTER TABLE "Tracking" DROP COLUMN "status",
ADD COLUMN     "status" "TrackingStatus" NOT NULL DEFAULT 'ORDER_RECEIVED';

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "address" TEXT,
ADD COLUMN     "businessAddress" TEXT,
ADD COLUMN     "businessName" TEXT,
ADD COLUMN     "phone" TEXT,
DROP COLUMN "role",
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'CUSTOMER';

-- CreateTable
CREATE TABLE "FittingSchedule" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "status" "BookingStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FittingSchedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RescheduleRequest" (
    "id" SERIAL NOT NULL,
    "fittingId" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "requestedDate" TIMESTAMP(3) NOT NULL,
    "reason" TEXT,
    "status" "RescheduleStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "respondedAt" TIMESTAMP(3),

    CONSTRAINT "RescheduleRequest_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "FittingSchedule" ADD CONSTRAINT "FittingSchedule_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RescheduleRequest" ADD CONSTRAINT "RescheduleRequest_fittingId_fkey" FOREIGN KEY ("fittingId") REFERENCES "FittingSchedule"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RescheduleRequest" ADD CONSTRAINT "RescheduleRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
