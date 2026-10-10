-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema football002
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema football002
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `football002` DEFAULT CHARACTER SET utf8 ;
USE `football002` ;

-- -----------------------------------------------------
-- Table `football002`.`team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football002`.`team` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `football002`.`match`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football002`.`match` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `season` VARCHAR(45) NOT NULL,
  `home_team_id` INT NOT NULL,
  `away_team_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_match_team_idx` (`home_team_id` ASC) VISIBLE,
  INDEX `fk_match_team1_idx` (`away_team_id` ASC) VISIBLE,
  UNIQUE INDEX `uq_season_home_away` (`season` ASC, `home_team_id` ASC, `away_team_id` ASC) VISIBLE,
  CONSTRAINT `fk_match_team`
    FOREIGN KEY (`home_team_id`)
    REFERENCES `football002`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_match_team1`
    FOREIGN KEY (`away_team_id`)
    REFERENCES `football002`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `football002`.`team_match_stats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `football002`.`team_match_stats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `possession` DECIMAL(4,1) NOT NULL,
  `shots_on_target` INT NOT NULL,
  `red_cards` INT NOT NULL,
  `match_id` INT NOT NULL,
  `team_id` INT NOT NULL,
  `goals` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_team_match_stats_match1_idx` (`match_id` ASC) VISIBLE,
  INDEX `fk_team_match_stats_team1_idx` (`team_id` ASC) VISIBLE,
  UNIQUE INDEX `uq_match_team` (`match_id` ASC, `team_id` ASC) VISIBLE,
  CONSTRAINT `fk_team_match_stats_match1`
    FOREIGN KEY (`match_id`)
    REFERENCES `football002`.`match` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_match_stats_team1`
    FOREIGN KEY (`team_id`)
    REFERENCES `football002`.`team` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
