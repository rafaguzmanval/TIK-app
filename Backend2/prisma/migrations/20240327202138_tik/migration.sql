/*
  Warnings:

  - You are about to drop the column `mail` on the `Client` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[email]` on the table `Client` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `Client` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX `Client_mail_key` ON `Client`;

-- AlterTable
ALTER TABLE `Client` DROP COLUMN `mail`,
    ADD COLUMN `email` VARCHAR(191) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `Client_email_key` ON `Client`(`email`);
