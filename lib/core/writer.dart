import 'dart:io';
import 'dart:math';

import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';

class Writer {
  final List<Character> characters;
  final String path;

  const Writer(this.path, this.characters);

  Future save() async {
    final output = File(path);
    if (await output.exists()) {
      await output.delete();
    }
    await output.create();

    await output.writeAsString(_characters, mode: _mode);
    for (Character character in characters) {
      await output.writeAsString('\n\t${character.token} = {', mode: _mode);
      await output.writeAsString('$_name "${character.name}"', mode: _mode);

      // Portraits
      await output.writeAsString(_portraits, mode: _mode);
      // Add Civilian Portraits
      if (character.headOfState || character.hasGovernmentPosition()) {
        await output.writeAsString(_civilian, mode: _mode);
        if (character.headOfState) {
          await output.writeAsString(
              '$_large $_portraitLargePrefix${character.tag}/Portrait_${character.token}.tga',
              mode: _mode);
        }
        if (character.hasGovernmentPosition()) {
          await output.writeAsString(
              '$_small $_portraitSmallPrefix${character.token}',
              mode: _mode);
        }
        await output.writeAsString('\n\t\t\t}', mode: _mode);
      }
      // Add Army Portraits
      if (character.fieldMarshal ||
          character.corpCommander ||
          character.isArmy()) {
        await output.writeAsString(_army, mode: _mode);
        if (character.fieldMarshal || character.corpCommander) {
          await output.writeAsString(
              '$_large $_portraitLargePrefix${character.tag}/Portrait_${character.token}_army.tga',
              mode: _mode);
        }
        if (character.isArmy()) {
          await output.writeAsString(
              '$_small $_portraitSmallPrefix${character.token}',
              mode: _mode);
        }
        await output.writeAsString('\n\t\t\t}', mode: _mode);
      }

      // Add Navy Portraits
      if (character.admiral || character.isNavy()) {
        await output.writeAsString(_navy, mode: _mode);
        if (character.admiral) {
          await output.writeAsString(
              '$_large $_portraitLargePrefix${character.tag}/Portrait_${character.token}_navy.tga',
              mode: _mode);
        }
        if (character.isNavy()) {
          await output.writeAsString(
              '$_small $_portraitSmallPrefix${character.token}',
              mode: _mode);
        }
        await output.writeAsString('\n\t\t\t}', mode: _mode);
      }

      if (character.headOfState) {
        // Country Leader
        await output.writeAsString(_countryLeader, mode: _mode);
        await output.writeAsString(
            '$_ideology ${character.ideology.token}_subtype',
            mode: _mode);
        if (character.leaderTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        await output.writeAsString('\n\t\t}', mode: _mode);
      } // close country leader

      // Field Marshal
      if (character.fieldMarshal) {
        await output.writeAsString(_fieldMarshal, mode: _mode);
        if (character.commanderTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        Random random = Random();
        String skill = random.nextInt(5).toString();
        String attack = random.nextInt(5).toString();
        String defense = random.nextInt(5).toString();
        String planning = random.nextInt(5).toString();
        String logistics = random.nextInt(5).toString();

        if (character.parsedSkills.length == 5) {
          skill = character.parsedSkills[0];
          attack = character.parsedSkills[1];
          defense = character.parsedSkills[2];
          planning = character.parsedSkills[3];
          logistics = character.parsedSkills[4];
        }
        await output.writeAsString('$_skill $skill', mode: _mode);
        await output.writeAsString('$_attackSkill $attack', mode: _mode);
        await output.writeAsString('$_defenseSkill $defense', mode: _mode);
        await output.writeAsString('$_planningSkill $planning', mode: _mode);
        await output.writeAsString('$_logisticsSkill $logistics', mode: _mode);
        await output.writeAsString('\n\t\t}', mode: _mode);
      }

      // Corp Commander
      if (character.corpCommander) {
        await output.writeAsString(_corpCommander, mode: _mode);
        await output.writeAsString(_traits, mode: _mode);
        if (character.commanderTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        Random random = Random();
        String skill = random.nextInt(5).toString();
        String attack = random.nextInt(5).toString();
        String defense = random.nextInt(5).toString();
        String planning = random.nextInt(5).toString();
        String logistics = random.nextInt(5).toString();

        if (character.parsedSkills.length == 5) {
          skill = character.parsedSkills[0];
          attack = character.parsedSkills[1];
          defense = character.parsedSkills[2];
          planning = character.parsedSkills[3];
          logistics = character.parsedSkills[4];
        }
        await output.writeAsString('$_skill $skill', mode: _mode);
        await output.writeAsString('$_attackSkill $attack', mode: _mode);
        await output.writeAsString('$_defenseSkill $defense', mode: _mode);
        await output.writeAsString('$_planningSkill $planning', mode: _mode);
        await output.writeAsString('$_logisticsSkill $logistics', mode: _mode);
        await output.writeAsString('\n\t\t}', mode: _mode);
      }

      // Admiral
      if (character.admiral) {
        await output.writeAsString(_admiral, mode: _mode);
        await output.writeAsString(_traits, mode: _mode);
        if (character.commanderTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        Random random = Random();
        String skill = random.nextInt(5).toString();
        String attack = random.nextInt(5).toString();
        String defense = random.nextInt(5).toString();
        String maneuver = random.nextInt(5).toString();
        String coordination = random.nextInt(5).toString();

        if (character.parsedSkills.length == 5) {
          skill = character.parsedSkills[0];
          attack = character.parsedSkills[1];
          defense = character.parsedSkills[2];
          maneuver = character.parsedSkills[3];
          coordination = character.parsedSkills[4];
        }
        await output.writeAsString('$_skill $skill', mode: _mode);
        await output.writeAsString('$_attackSkill $attack', mode: _mode);
        await output.writeAsString('$_defenseSkill $defense', mode: _mode);
        await output.writeAsString('$_maneuveringSkill $maneuver', mode: _mode);
        await output.writeAsString('$_coordinationSkill $coordination',
            mode: _mode);
        await output.writeAsString('\n\t\t}', mode: _mode);
      }

      await output.writeAsString('\n\t}\n', mode: _mode); // close character
    }
    await output.writeAsString('\n}', mode: _mode);
  }

  static const _characters = "characters = {";
  static const _name = "\n\t\tname =";
  static const _portraits = "\n\t\tportraits = {";
  static const _large = "\n\t\t\t\tlarge =";
  static const _small = "\n\t\t\t\tsmall =";
  static const _army = "\n\t\t\tarmy = {";
  static const _navy = "\n\t\t\tnavy = {";
  static const _civilian = "\n\t\t\tcivilian = {";
  static const _countryLeader = "\n\t\tcountry_leader = {";
  static const _ideology = "\n\t\t\tideology =";
  static const _traits = "\n\t\t\ttraits = {";
  static const _skill = "\n\t\t\tskill =";
  static const _attackSkill = "\n\t\t\tattack_skill =";
  static const _defenseSkill = "\n\t\t\tdefense_skill =";
  static const _planningSkill = "\n\t\t\tplanning_skill =";
  static const _logisticsSkill = "\n\t\t\tlogistics_skill =";
  static const _maneuveringSkill = "\n\t\t\tmaneuvering_skill =";
  static const _coordinationSkill = "\n\t\t\tcoordination_skill =";
  static const _fieldMarshal = "\n\t\tfield_marshal = {";
  static const _corpCommander = "\n\t\tcorps_commander = {";
  static const _admiral = "\n\t\tadmiral = {";
  static const _advisor = "\n\t\tadvisor = {";

  static const _mode = FileMode.append;
  static const _portraitLargePrefix = "gfx/leaders/";
  static const _portraitSmallPrefix = "GFX_idea_";
}
