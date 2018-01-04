DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20171228001655');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20171228001655');
-- Add your query below.


-- Add minimum and maximum respawn time for creature spawns.
ALTER TABLE `creature`
	CHANGE COLUMN `spawntimesecs` `spawntimesecsmin` INT(10) UNSIGNED NOT NULL DEFAULT '120' AFTER `orientation`;

ALTER TABLE `creature`
	ADD COLUMN `spawntimesecsmax` INT(10) UNSIGNED NOT NULL DEFAULT '120' AFTER `spawntimesecsmin`;

UPDATE `creature` SET `spawntimesecsmax`=`spawntimesecsmin`;

-- Add minimum and maximum respawn time for gameobject spawns.
ALTER TABLE `gameobject`
	CHANGE COLUMN `spawntimesecs` `spawntimesecsmin` INT(11) NOT NULL DEFAULT '0' AFTER `rotation3`;

ALTER TABLE `gameobject`
	ADD COLUMN `spawntimesecsmax` INT(11) NOT NULL DEFAULT '0' AFTER `spawntimesecsmin`;

UPDATE `gameobject` SET `spawntimesecsmax`=`spawntimesecsmin`;


-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20171228194322');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20171228194322');
-- Add your query below.


-- Add creature_spells_scripts table.
DROP TABLE IF EXISTS `creature_spells_scripts`;
CREATE TABLE IF NOT EXISTS `creature_spells_scripts` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `command` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `datalong2` int(10) unsigned NOT NULL DEFAULT '0',
  `datalong3` int(10) unsigned NOT NULL DEFAULT '0',
  `datalong4` int(10) unsigned NOT NULL DEFAULT '0',
  `data_flags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dataint` int(11) NOT NULL DEFAULT '0',
  `dataint2` int(11) NOT NULL DEFAULT '0',
  `dataint3` int(11) NOT NULL DEFAULT '0',
  `dataint4` int(11) NOT NULL DEFAULT '0',
  `x` float NOT NULL DEFAULT '0',
  `y` float NOT NULL DEFAULT '0',
  `z` float NOT NULL DEFAULT '0',
  `o` float NOT NULL DEFAULT '0',
  `comments` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Add script support to creature_spells table.
ALTER TABLE `creature_spells`
	ADD COLUMN `scriptId_1` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_1`,
	ADD COLUMN `scriptId_2` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_2`,
	ADD COLUMN `scriptId_3` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_3`,
	ADD COLUMN `scriptId_4` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_4`,
	ADD COLUMN `scriptId_5` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_5`,
	ADD COLUMN `scriptId_6` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_6`,
	ADD COLUMN `scriptId_7` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_7`,
	ADD COLUMN `scriptId_8` MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0' AFTER `delayRepeatMax_8`;

-- Azuregos spawn time 3 days to 7 days.
UPDATE `creature` SET `spawntimesecsmin`=259200, `spawntimesecsmax`=604800 WHERE `id`=6109;

-- Lord Kazzak spawn time 3 days to 7 days.
UPDATE `creature` SET `spawntimesecsmin`=259200, `spawntimesecsmax`=604800 WHERE `id`=12397;

-- Gossip for Spirit of Azuregos.
UPDATE `creature_template` SET `ScriptName`='' WHERE `entry`=15481;
INSERT INTO `gossip_menu` VALUES (15014, 7898, 0);
DELETE FROM `gossip_scripts` WHERE `id`=7;
UPDATE `gossip_menu_option` SET `action_menu_id`=15014, `action_script_id`=0 WHERE `menu_id`=15013 && `id`=0;

-- Gossip for Azuregos.
UPDATE `creature_template` SET `gossip_menu_id`=15000, `spells_template`=61090, `AIName`='EventAI', `ScriptName`='' WHERE `entry`=6109;
UPDATE `gossip_menu_option` SET `action_menu_id`=-1, `action_script_id`=7 WHERE `menu_id`=15000 && `id`=0;
DELETE FROM `gossip_menu_option` WHERE `menu_id`=15000 && `id`=1;
DELETE FROM `gossip_menu` WHERE `entry`=15000 && `text_id`!=7880;
DELETE FROM `gossip_scripts` WHERE `id`=15000;
INSERT INTO `gossip_scripts` (`id`, `delay`, `command`, `datalong`, `dataint`, `data_flags`, `comments`) VALUES
(7, 0, 0, 0, 11017, 0, 'Azuregos - Say Text 1'),
(7, 0, 22, 168, 0, 2, 'Azuregos - Set Faction to Enemy'),
(7, 1, 26, 0, 0, 0, 'Azuregos - Attack Player');

-- EventAI script for Azuregos.
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (610900, 6109, 4, 0, 100, 0, 0, 0, 0, 0, 1, 9072, 0, 0, 11, 23184, 0, 34, 0, 0, 0, 0, 'Azuregos - Aggro - Say Text and Cast Mark of Frost');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (610901, 6109, 7, 0, 100, 0, 0, 0, 0, 0, 28, 0, 23184, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Azuregos - Evade - Remove Mark of Frost aura');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (610902, 6109, 5, 0, 100, 1, 10000, 10000, 0, 0, 1, 9073, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Azuregos - Killed Played- Say Text');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (610903, 6109, 1, 0, 100, 1, 3000, 5000, 3000, 5000, 11, 23185, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Azuregos - Out of Combat - Cast Aura of Frost');

-- Adding creature_spells template for Azuregos.
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (61090, 'Azshara - Azuregos', 23185, 100, 0, 0, 0, 0, 3, 5, 0, 21147, 100, 0, 0, 20, 20, 30, 45, 21147, 21098, 100, 1, 0, 14, 14, 22, 29, 0, 21099, 100, 1, 0, 12, 12, 10, 20, 0, 21097, 100, 4, 0, 16, 16, 11, 22, 0, 22067, 100, 0, 0, 21, 21, 20, 35, 0, 15613, 100, 1, 0, 7, 7, 7, 7, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0);

-- Script when casting Arcane Vacuum
INSERT INTO `creature_spells_scripts` (`id`, `delay`, `command`, `dataint`, `comments`) VALUES (21147, 0, 0, 9071, 'Azuregos - Arcane Vacuum - Say Text');

-- Removing old script texts.
DELETE FROM `script_texts` WHERE `entry` IN (-1000006, -1000098, -1000099, -1000100);

-- Updating chat type to zone yell.
UPDATE `broadcast_text` SET `Type`=6 WHERE `ID` IN (9071, 9072, 9073);


-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20171229022458');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20171229022458');
-- Add your query below.

UPDATE `gameobject_template` SET `data3`=23505 WHERE `entry`=179905;
UPDATE `gameobject_template` SET `data3`=23505 WHERE `entry`=179907;

-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20171229182303');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20171229182303');
-- Add your query below.


-- Salia
-- Fixes https://github.com/LightsHope/server/issues/546
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=9860;
UPDATE `creature_template` SET `spells_template`=98600, `AIName`='' WHERE `entry`=9860;
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (98600, 'Felwood - Salia', 12888, 100, 4, 0, 18, 24, 18, 24, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0);

-- Jaedanar Warlock
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=7120;
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (712000, 7120, 1, 0, 100, 0, 1000, 1000, 0, 0, 11, 11939, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaedenar Warlock - Summon Imp on Spawn');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (712001, 7120, 2, 0, 100, 0, 30, 0, 0, 0, 11, 8699, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaedenar Warlock - Cast Unholy Frenzy at 30% HP');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (712002, 7120, 2, 0, 100, 0, 15, 0, 0, 0, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Jaedenar Warlock -  Flee at 15% HP');
UPDATE `creature_template` SET `spells_template`=71200 WHERE `entry`=7120;
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (71200, 'Felwood - Jaedenar Warlock', 9613, 100, 1, 0, 0, 0, 1, 1, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0);

-- Shadow Lord Fel'dan
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=9517;
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (951701, 9517, 2, 0, 100, 0, 15, 0, 0, 0, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Shadow Lord Fel\'dan - Start Combat Movement and Flee at 15% HP (Phase 3)');
UPDATE `creature_template` SET `spells_template`=95170 WHERE `entry`=9517;
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (95170, 'Felwood - Shadow Lord Fel\'dan', 16583, 100, 4, 1, 12, 16, 10, 13, 0, 9081, 100, 4, 1, 9, 14, 11, 15, 0, 20825, 100, 1, 0, 0, 0, 1, 1, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0);

-- Moora
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=9861;
UPDATE `creature_template` SET `spells_template`=98610, `AIName`='' WHERE `entry`=9861;
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (98610, 'Felwood - Moora', 11639, 100, 1, 0, 6, 12, 21, 26, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0);

-- Imp Minion
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=12922;
UPDATE `creature_template` SET `spells_template`=129220, `AIName`='AggressorAI' WHERE `entry`=12922;
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (129220, 'Felwood - Imp Minion (Pet)', 20801, 100, 1, 0, 0, 0, 1, 1, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0);

-- ERROR:Table 'reference_loot_template' entry 323622 (reference id) not exist but used as loot id in DB.
-- ERROR:Table 'reference_loot_template' entry 323619 (reference id) not exist but used as loot id in DB.
DELETE FROM `creature_loot_template` WHERE `item` IN (323622, 323619);


-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20171229202929');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20171229202929');
-- Add your query below.


-- Add some spanish quest locales from trinity.
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¿Cómo va la caza, $N? ¿Has acabado con las alimañas?' WHERE `entry`=7;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¿Tienes el Kelp de Cristal? Estoy seguro de que Maybell está ansiosa por ver a su novio...' WHERE `entry`=112;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¿Qué tal va la caza, $N?' WHERE `entry`=173;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¡$N! ¿Ha habido suerte?' WHERE `entry`=218;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Tu tarea no ha concluido, $N. Regresa de nuevo una vez hayas matado a 5 sables de la noche sarnosos y 5 jabalíes cardo.' WHERE `entry`=457;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Satisface mis sospechas, $N. Tráeme 8 muestras de Musgovil.' WHERE `entry`=459;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Yenniku está aturdido ante ti, su mente está en otro lugar...' WHERE `entry`=593;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¿Tienes las glándulas venenosas, $N?' WHERE `entry`=916;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Las pozas de la luna contienen las aguas del Pozo de la Eternidad, la antigua fuente de magia que tantos males ha traído a nuestro mundo.$B$BLos druidas usan las pozas y los centinelas las veneran como santuarios de Elune, pero la hechicería está prohibida.' WHERE `entry`=921;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¿Has ido al Lago Primigenio, $N? ¿Has estado cazando a los Brezomadera de allí?' WHERE `entry`=923;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Saludos, $c. ¿Con qué propósito debo el placer de nuestro encuentro?' WHERE `entry`=928;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Hola de nuevo, $N. ¿Has completado tu tarea?' WHERE `entry`=929;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Al principio, los informes de ataques enloquecidos de Fúrbolgs fueron eliminados. ¿Quién podría haber pensado que la paz y amor entre hombres y osos conllevaría a la rabia sin sentido? Sin embargo, otro de los problemas que nos afecta aquí, en nuestro nuevo hogar.' WHERE `entry`=933;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Sé que no fuiste citado, así que no puedo evitar preguntarme por qué has venido a hablar conmigo.$B$BSea lo que sea, por favor, hazlo rápido.' WHERE `entry`=935;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='¿Vienes de Teldrassil? Dime, ¿cómo es la pesca allí?' WHERE `entry`=6342;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Cuando finalmente ponga en marcha este puesto, ¡habrá que hacerle mucha publicidad! ¿Y qué mejor manera de hacerlo que usando fuegos artificiales?$B$BBueno, algunos pensarían que el olor de un caldero, con cabezas de tus enemigos hirviendo sería lo mejor para convocar multitudes, pero... estamos en una empresa mixta. ¡Así que mejor usamos fuegos artificiales!$B$BTráeme fuegos de artificio verde, $N, y te daré un puñado de vales de la Feria de la Luna Negra.' WHERE `entry`=7896;
UPDATE `locales_quest` SET `RequestItemsText_loc6`='Junto con los druidas, el Árbol del Oráculo y el Archidruida han sido cuidadosamente la vigilancia del crecimiento de Teldrassil. Pero aunque tenemos un nuevo hogar, nuestra vida inmortal no ha sido restaurada.' WHERE `entry`=7383;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Buen trabajo. Los Kóbolds son ladrones y cobardes, pero en gran número suponen una amenaza más para los humanos de Ventormenta.$B$BTe agradezco lo que has hecho.' WHERE `entry`=7;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Ya las tengo. ¡Gran Trabajo! Ahora espera un momento mientras hago la pócima...' WHERE `entry`=112;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Te has desenvuelto bien contra los Correoscuros, $N. Pero parece que su número es irreducible. Cada vez que hacemos un progreso, llegan más a tomar el relevo.$B$B¿Qué maléfico poder es el que les trae aquí? ¿Por qué han irrumpido de esta manera en nuestro infeliz reino?$B$BTendré fe en el maestro Carevin. Sin duda, él llegará hasta el fondo del asunto.' WHERE `entry`=173;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Muy bien, $N. Puedes seguir adelante.' WHERE `entry`=185;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='¡Que tengas buena suerte, $N!' WHERE `entry`=190;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='¡Que tengas buena suerte, $N!' WHERE `entry`=192;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Un trabajo magistral.' WHERE `entry`=194;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Has demostrado una gran dedicación hacia el bién de la naturaleza, $N. A $glos:las; jóvenes como tu les espera un futuro muy prometedor.' WHERE `entry`=457;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Tu servicio hacia las criaturas de Cañada Umbría es digno de recompensa, $N.$B$BSin embargo, has confirmado mis temores. Si los grells han sido contaminados por el Musgovil, puedes imaginarte lo que le ha sucedido a la tribu Tuercepinos de fúrbolgs que una vez vivió aquí.$B$BDeberías encontrar tu verdadero talento en Dolanaar, diestr$go:a; $c, busca al sabio druida, Athridas Manto de Oso. Él comparte nuestra preocupación por el bienestar del bosque.' WHERE `entry`=459;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Colocas la gema del alma frente a él. Se estremece mientras aspira su alma, abandonando su cuerpo, como un cascarón.' WHERE `entry`=593;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Gracias, $N. Compararé este veneno con el de otras arañas en Darnassus. Creo que tiene propiedades relacionadas con el crecimiento de nuestro Árbol del Mundo.' WHERE `entry`=916;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Has oído lo que pasó justo después de la Batalla del Monte Hyjal. Hay mucho más, pero la misión que te encomiendo seguirá vigente durante tu recorrido por Teldrassil y dentro Darnassus.' WHERE `entry`=921;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='¡Bien hecho! Estos tumores son el síntoma de la enfermedad de los Brezomadera. Están llenos de un veneno que tenemos que erradicar de nuestra nueva tierra.$B$BYo me desharé de estos tumores. Gracias, $N.' WHERE `entry`=923;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Ah, ya veo. Has sido enviado por Tenaron. Pues bien, parece que tenemos mucho de que hablar, mucho que hacer, y poco tiempo para hacer las cosas.$B$BCreo que deberíamos empezar ya.' WHERE `entry`=928;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Después de la batalla de Monte Hyjal, íbamos sin rumbo. Nordrassil ahumado por el fuego que desató y nuestra inmortalidad, la esencia misma de nuestro ser, se había perdido.$B$BFue entonces cuando el traidor fue liberado de su prisión y Shan\'do Tempestira desapareció. Fueron tiempos oscuros para nosotros.' WHERE `entry`=929;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Shan\'do Tempestira nunca regresó y los druidas no sabían que hacer. Hasta hoy mismo todavía no sé sabe que fue de él. Con Malfurion desaparecido, el Archidruida Fandral Corzocelada asumió el liderazgo de los druidas, convenciendo al Círculo de Ancianos en Costa Oscura que era el momento de reconstruir nuestros pueblos y de recuperar nuestra inmortalidad.$B$BCon la aprobación del Círculo, Corzocelada y los druidas más poderosos, nació Teldrassil, el nuevo Árbol del Mundo.' WHERE `entry`=933;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Ah, sí, el agua que había solicitado. Tenaron y Corithras se tomaron su tiempo hasta ser entregado... hmm tal vez no eligieron al más fiable de los mensajeros...$B$BSin embargo, por fin puedo volver a mi trabajo. El peso de los problemas de Teldrassil caen sobre mis hombros.$B$BToma esto, puede que encuentres alguna utilidad en él.' WHERE `entry`=935;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='¡Gracias por el trabajo realizado!' WHERE `entry`=1318;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Aquí en Ventormenta, soy el responsable de poner a los paladines en el camino hacia una mayor virtud como devotos de la Luz y defensores de Azeroth contra la Plaga y otras amenazas.$B$BHa llegado el momento de que des tu primer paso para ser verdaderamente virtuoso. Si lo aceptas, te daré un Libro de la Divinidad. En su estudio, aprenderás algo sobre la Luz, y lo que se espera de ti. Si lo entiendes, y estás capacitado, entonces tendrás éxito en el logro de mayores habilidades.' WHERE `entry`=1641;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Hola de nuevo, $N. ¿Cómo va tu estudio del Libro de la Divinidad?$B$BEntonces deberías estar preparado para probarte. Siempre hay tareas que realizar en la ciudad y en nuestras tierras; actos de compasión y comprensión; gente que necesita ayuda; criaturas que matar.$B$BAl probar que tienes paciencia para ayudar a otros, especialmente aquellos que son desafortunados, probarás que eres $gun:una; sirviente de la Luz y de mente sana.' WHERE `entry`=1642;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Aquí en Forjaz, soy la responsable de poner a los paladines en el camino hacia una mayor virtud como devotos de la Luz y a defensores de Azeroth contra la Plaga y otras amenazas.$B$BHa llegado la hora de que des tu primer paso para ser verdaderamente virtuos$go:a;. Si lo aceptas, te daré un Libro de la Divinidad. En su estudio, aprenderás algo sobre la Luz, y lo que se espera de ti. Si lo entiendes, y estás capacitado, entonces tendrás éxito en el logro de mayores habilidades.' WHERE `entry`=1645;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Aquí está tu toga, $N. Dale buen uso.' WHERE `entry`=1962;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Aquí tienes, $N. Y por favor, dale a Menara nuestros saludos.$B$BEsperamos grandes cosas de ti. Quizás cuando la Legión caiga de rodillas, tu nombre se pronuncie en voz alta en alabanza de tu poder. ¡No puedo esperar!' WHERE `entry`=4785;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Un diario de páginas amarillentas se abre en la última anotación:$B$B"No sé qué va a pasar ahora que Harold cambió. Se llevó todo mientras lo arrastraba al único lugar que podía encontrar donde mantenerlo seguro. Escondí la llave conmigo, y rezo por que nadie la encuentre...$B$BEspero poder escapar de aquí, pero necesito dinero para eso. Creo que todas nuestras cosas están en el armario... y ahora que lo pienso, Harold tenía la llave.$B$BVoy a descansar un poco, ahora estoy muerta de cansancio."' WHERE `entry`=5058;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='¿Un paquete de Nessa? ¡Gracias, $N! Me dijo que me enviaría muestras de todos los peces que pescara cerca de la Aldea Rut\'theran. Cree que podrían ser muy diferentes de los que pescamos aquí...$B$B¡Vaya! Esta mandíbula casi dobla el tamaño de la que tiene el mismo pez aquí. ¡Y estas escamas son grandes como puños! ¡Es increíble!' WHERE `entry`=6342;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Sí, necesito a alguien que me lleve un paquete a Costa Oscura. ¿Quieres ayudarme?' WHERE `entry`=6344;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Trajiste los fuegos artificiales. ¡Espléndido trabajo, $N! ¡No puedo esperar para encenderlos y decirle a todos que mi puesto está listo! Pero debo esperar, desde hace mucho tiempo tengo miedo, pero... estaré listo cuando esté listo, ¿vale?$B$BAquí están los vales, $N. ¡Disfrútalos!' WHERE `entry`=7896;
UPDATE `locales_quest` SET `OfferRewardText_loc6`='Cuando estás en presencia del Árbol del Oráculo... es como sentir la sabiduría tomar forma. Permíteme continuar el relato...$B$BCon Teldrassil en crecimiento, el Archidruida se acercó a los dragones para recibir sus bendiciones, como habían hecho sobre Nordrassil en tiempos antiguos. Sin embargo, Nozdormu, Señor del Tiempo, se negó a dar su bendición, reprendiendo a los druidas su arrogancia. De acuerdo con Nozdormu, Alexstrasza Staghelm también se negó y sin su bendición, el crecimiento de Teldrassil ha sido deficiente e impredecible...' WHERE `entry`=7383;
UPDATE `locales_quest` SET `EndText_loc6`='Explora la glorieta en el Lago Mystral que domina la cercana avanzada de la Alianza.' WHERE `entry`=25;
UPDATE `locales_quest` SET `ObjectiveText1_loc6`='Alimaña Kóbold matado' WHERE `entry`=7;
UPDATE `locales_quest` SET `ObjectiveText1_loc6`='Hoja de Kelp de Cristal' WHERE `entry`=112;
UPDATE `locales_quest` SET `ObjectiveText1_loc6`='Visita el nido de raptor amarillo' WHERE `entry`=905;
UPDATE `locales_quest` SET `ObjectiveText2_loc6`='Visita el nido de raptor azul' WHERE `entry`=905;
UPDATE `locales_quest` SET `ObjectiveText3_loc6`='Visita el nido de raptor rojo' WHERE `entry`=905;


-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
DROP PROCEDURE IF EXISTS add_migration;
delimiter ??
CREATE PROCEDURE `add_migration`()
BEGIN
DECLARE v INT DEFAULT 1;
SET v = (SELECT COUNT(*) FROM `migrations` WHERE `id`='20180102212045');
IF v=0 THEN
INSERT INTO `migrations` VALUES ('20180102212045');
-- Add your query below.


-- Delete custom NPCs.
DELETE FROM `creature_template` WHERE `entry` IN (964, 4621, 4622, 10001);
DELETE FROM `creature` WHERE `id` IN (4621);

-- Arugal (the intro npc) doesn't need a core script.
UPDATE `creature_template` SET `AIName`='EventAI', `ScriptName`='' WHERE `entry`=10000;

-- Arugal (the intro npc) should be invisible by default.
UPDATE `creature` SET `id`=10000, `spawnFlags`=64 WHERE `id`=10001;

-- EventAI script for Arugal (Intro NPC).
DELETE FROM `creature_ai_scripts` WHERE `creature_id` IN (10000, 10001);
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (1000000, 10000, 11, 0, 100, 0, 0, 0, 0, 0, 50, 10000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Arugal - Start SFK Intro Event');

-- Event script for Arugal (Intro NPC).
DELETE FROM `event_scripts` WHERE `id`=10000;
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 3, 0, 0, 0, 0, 0, 0, 1456, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Say Text 1');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 4, 15, 10418, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Cast Spawn Spell');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 8, 0, 0, 0, 0, 0, 0, 5680, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Say Text 2');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 8, 1, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Emote Point');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 13, 0, 0, 0, 0, 0, 0, 5681, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Say Text 3');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 17, 1, 11, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Emote Laugh');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 20, 28, 7, 4444, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Deathstalker Vincent Set Stand State to Dead');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 20, 0, 0, 0, 0, 0, 0, 5682, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Say Text 4');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 25, 15, 6700, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Cast Dimensional Portal');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (10000, 13, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'SFK Intro - Arugal Emote Talk');

-- Change implicit target for spell 10418 to self.
-- Arugal (the intro npc) casts this on himself to become visible.
INSERT INTO `spell_effect_mod` (`Id`, `EffectIndex`, `EffectImplicitTargetA`, `Comment`) VALUES (10418, 0, 1, 'Arugal spawn-in spell - Cast on Self');

-- Add missing sound, type and emotes for broadcast texts.
UPDATE `broadcast_text` SET `Sound`=5797, `Type`=1 WHERE `ID`=6535;
UPDATE `broadcast_text` SET `Type`=1 WHERE `ID`=1435;
UPDATE `broadcast_text` SET `Sound`=5793, `Type`=1 WHERE `ID`=6115;
UPDATE `broadcast_text` SET `Sound`=5795, `Type`=1 WHERE `ID`=6116;
UPDATE `broadcast_text` SET `EmoteId0`=1 WHERE `ID` IN (1328, 1329);
UPDATE `broadcast_text` SET `Type`=1 WHERE `ID`=2086;

-- Assign spells template to Archmage Arugal (boss).
UPDATE `creature_template` SET `spells_template`=42750, `InhabitType`=3, `speed_walk`=1 WHERE `entry`=4275;

-- Remove old texts replaced with broadcast texts.
DELETE FROM `creature_ai_texts` WHERE `entry` IN (-541, -542, -543, -1100);
DELETE FROM `script_texts` WHERE `entry` IN (-1033000, -1033001, -1033002, -1033003, -1033004, -1033005, -1033006, -1033007, -1033008, -1033009, -1033010, -1033011, -1033012, -1033013, -1033014, -1033016, -1033017, -1033018, -1033019);

-- Delay for event that spawns the void walkers after Fenrus should be longer.
-- One of the void walkers had wrong spawn coordinates.
DELETE FROM `event_scripts` WHERE `id`=9536;
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (9536, 11, 10, 4627, 9000000, 0, 0, 0, 0, 0, 0, 0, -140.203, 2175.26, 128.448, 0.373, 'Arugals Voidwalker spawn 4');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (9536, 11, 10, 4627, 9000000, 0, 0, 0, 0, 0, 0, 0, -148.869, 2180.86, 128.448, 1.814, 'Arugals Voidwalker spawn 3');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (9536, 11, 10, 4627, 9000000, 0, 0, 0, 0, 0, 0, 0, -155.352, 2172.780, 128.448, 4.679, 'Arugals Voidwalker spawn 2');
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (9536, 11, 10, 4627, 9000000, 0, 0, 0, 0, 0, 0, 0, -147.059, 2163.19, 128.696, 0.128, 'Arugals Voidwalker spawn 1');

-- EventAI script for Archmage Arugal (Boss).
DELETE FROM `creature_ai_scripts` WHERE `creature_id`=4275;
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (427501, 4275, 4, 0, 100, 2, 0, 0, 0, 0, 1, 6115, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Yell on Aggro (Ustaag)');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (427502, 4275, 5, 0, 100, 2, 0, 0, 0, 0, 1, 6116, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Yell on Player Kill (Ustaag)');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (427503, 4275, 9, 0, 100, 3, 0, 5, 5000, 7000, 11, 7588, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Cast Void Bolt (Melee) (Ustaag)');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (427504, 4275, 9, 0, 100, 3, 5, 60, 0, 0, 11, 7588, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Cast Void Bolt (Range) (Ustaag)');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (427505, 4275, 9, 0, 100, 3, 0, 5, 1000, 1000, 21, 1, 0, 0, 20, 1, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Enable Movement when target in melee range (Ustaag)');
INSERT INTO `creature_ai_scripts` (`id`, `creature_id`, `event_type`, `event_inverse_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action1_type`, `action1_param1`, `action1_param2`, `action1_param3`, `action2_type`, `action2_param1`, `action2_param2`, `action2_param3`, `action3_type`, `action3_param1`, `action3_param2`, `action3_param3`, `comment`) VALUES (427506, 4275, 9, 0, 100, 3, 5, 60, 1000, 1000, 21, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Disable Movement when target is far (Ustaag)');

-- Spells template for Archmage Arugal (Boss).
INSERT INTO `creature_spells` (`entry`, `name`, `spellId_1`, `probability_1`, `castTarget_1`, `castFlags_1`, `delayInitialMin_1`, `delayInitialMax_1`, `delayRepeatMin_1`, `delayRepeatMax_1`, `scriptId_1`, `spellId_2`, `probability_2`, `castTarget_2`, `castFlags_2`, `delayInitialMin_2`, `delayInitialMax_2`, `delayRepeatMin_2`, `delayRepeatMax_2`, `scriptId_2`, `spellId_3`, `probability_3`, `castTarget_3`, `castFlags_3`, `delayInitialMin_3`, `delayInitialMax_3`, `delayRepeatMin_3`, `delayRepeatMax_3`, `scriptId_3`, `spellId_4`, `probability_4`, `castTarget_4`, `castFlags_4`, `delayInitialMin_4`, `delayInitialMax_4`, `delayRepeatMin_4`, `delayRepeatMax_4`, `scriptId_4`, `spellId_5`, `probability_5`, `castTarget_5`, `castFlags_5`, `delayInitialMin_5`, `delayInitialMax_5`, `delayRepeatMin_5`, `delayRepeatMax_5`, `scriptId_5`, `spellId_6`, `probability_6`, `castTarget_6`, `castFlags_6`, `delayInitialMin_6`, `delayInitialMax_6`, `delayRepeatMin_6`, `delayRepeatMax_6`, `scriptId_6`, `spellId_7`, `probability_7`, `castTarget_7`, `castFlags_7`, `delayInitialMin_7`, `delayInitialMax_7`, `delayRepeatMin_7`, `delayRepeatMax_7`, `scriptId_7`, `spellId_8`, `probability_8`, `castTarget_8`, `castFlags_8`, `delayInitialMin_8`, `delayInitialMax_8`, `delayRepeatMin_8`, `delayRepeatMax_8`, `scriptId_8`) VALUES (42750, 'Shadowfang Keep - Archmage Arugal', 7136, 80, 0, 1, 48, 48, 40, 40, 0, 7586, 80, 0, 1, 22, 22, 40, 40, 0, 7587, 80, 0, 1, 34, 34, 40, 40, 7587, 7621, 100, 4, 1, 10, 15, 15, 20, 7621, 7803, 80, 1, 1, 15, 15, 15, 15, 7803, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- Scripts for Archmage Arugal's spells.
INSERT INTO `creature_spells_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (7621, 0, 0, 0, 0, 0, 0, 0, 6535, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Arugal\'s Curse - Arugal Say Text');
INSERT INTO `creature_spells_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (7803, 1, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 'Archmage Arugal - Thundershock - Move Away from Target');
INSERT INTO `creature_spells_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `datalong3`, `datalong4`, `data_flags`, `dataint`, `dataint2`, `dataint3`, `dataint4`, `x`, `y`, `z`, `o`, `comments`) VALUES (7587, 8, 15, 7136, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Archmage Arugal - Shadow Port - Teleport back to Start Location');


-- End of migration.
END IF;
END??
delimiter ; 
CALL add_migration();
DROP PROCEDURE IF EXISTS add_migration;
