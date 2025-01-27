USE teamproject;

 SET FOREIGN_KEY_CHECKS=0;
 CREATE TABLE `continent_list` (
   `continent` varchar(50) NOT NULL,
   `country_id` varchar(50) NOT NULL,
    PRIMARY KEY (`country_id`)
 );

SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `carbon_emissions` (
    `country_id` varchar(50) NOT NULL,
  `carbon_emissions` decimal(20,2) ,
  `carbon_growth` decimal(20,2) ,
  `emissions_transport` decimal(20,2) ,
  `emissions_industry` decimal(20,2) ,
  `emissions_agriculture` decimal(20,2) ,
  PRIMARY KEY (`country_id`)
  );
  
SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `clean_innovation` (
    `country_id` varchar(50) NOT NULL,
  `patents` decimal(20,2) ,
  `energy_investment` decimal(20,2) ,
  `foodtech_investment` decimal(20,2) ,
  PRIMARY KEY (`country_id`)
  );
SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `climate_policy` (
    `country_id` varchar(50) NOT NULL,
	`climate_action` decimal(20,2),
  `carbon_pricing` decimal(20,2) ,
  `agriculture_strategy` decimal(20,2) ,
  `pandemic_pivot` decimal(20,2) ,
  PRIMARY KEY (`country_id`)
 );

SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `energy_transition` (
    `country_id` varchar(50) NOT NULL,
	`renewable_energy` decimal(20,2),
  `renewable_contribution` decimal(20,2) ,
  PRIMARY KEY (`country_id`)
);

SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `green_society` (
    `country_id` varchar(50) NOT NULL,
	`green_buildings` decimal(20,2),
  `recycling_efforts` decimal(20,2) ,
   `forestation_change` decimal(20,2) ,
    `meat_diary_consume` decimal(20,2) ,
  PRIMARY KEY (`country_id`)
);

SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `green_totalscores` (
    `country_id` varchar(50) NOT NULL,
	`total_emissions` decimal(20,2),
  `total_energy_transition` decimal(20,2) ,
   `total_green_society` decimal(20,2) ,
    `total_clean_innovation` decimal(20,2) ,
    `total_climate_policy` decimal(20,2) ,
    `green_index` decimal(20,2) ,
  PRIMARY KEY (`country_id`)
);

SET FOREIGN_KEY_CHECKS=0;
CREATE TABLE `population_index` (
  `country` varchar(50) NOT NULL,
  `population_2021` decimal(20,2) ,
  `population_2020` decimal(20,2) ,
  `population_rank` decimal(20,2) ,
  PRIMARY KEY (`country`)
  );