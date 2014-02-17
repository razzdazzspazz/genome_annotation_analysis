create database gpls718project;
 
CREATE  TABLE IF NOT EXISTS `gpls718project`.`Genes` (
  `ID` VARCHAR(45) NOT NULL ,
  `GenomeID` VARCHAR(45) NOT NULL ,
  `CommonName` VARCHAR(45) NULL ,
  `GeneSymbol` VARCHAR(45) NULL ,
  `fmin` INT NULL ,
  `fmax` INT NULL ,
  `strand` VARCHAR(45) NULL )
ENGINE = InnoDB
 
 
CREATE  TABLE IF NOT EXISTS `gpls718project`.`GeneFunctions` (
  `GeneID` VARCHAR(45) NOT NULL ,
  `ECNumber` VARCHAR(45) NULL ,
  `TIGRrole` VARCHAR(45) NULL )
ENGINE = InnoDB
 
CREATE  TABLE IF NOT EXISTS `gpls718project`.`Genomes` (
  `ID` INT NOT NULL ,
  `GeneID` VARCHAR(45) NOT NULL ,
  `OrganismName` VARCHAR(45) NULL )
ENGINE = InnoDB
 
 
 
use gpls718project;
