import 'dart:io';

import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/ministers/minister.dart';
import 'package:path/path.dart';

class Writer {
  const Writer._();

  static Future saveMinistersCore(
    String path,
    Map<Position, List<Minister>> ministers,
  ) async {
    final output = File(path);
    if (await output.exists()) {
      await output.delete();
    }
    await output.create();

    await output.writeAsString(_ideas, mode: _mode);
    for (MapEntry<Position, List<Minister>> entry in ministers.entries) {
      Position position = entry.key;
      List<Minister> ministersGrouped = entry.value;
      String trigger = position == Position.headOfGovernment
          ? 'head_of_gov_available'
          : 'minister_available';

      await output.writeAsString('\n\t${position.token} = {', mode: _mode);
      for (Minister minister in ministersGrouped) {
        String trait = minister.traits
            .firstWhere((trait) => trait.startsWith(position.prefix));
        String nameNoSpace = minister.name.replaceAll(" ", "_");
        nameNoSpace = minister.name.replaceAll(".", "");

        await output.writeAsString(
            '\n\t\t${minister.token}_${position.prefix}_${minister.ideology.prefix} = {',
            mode: _mode);

        await output.writeAsString(
            '\n\t\t\tallowed = { original_tag = ${minister.tag} }',
            mode: _mode);

        await output.writeAsString('\n\t\t\tavailable = {', mode: _mode);
        await output.writeAsString('\n\t\t\t\tcustom_trigger_tooltip = {',
            mode: _mode);
        await output.writeAsString('\n\t\t\t\t\ttooltip = $trigger',
            mode: _mode);
        await output.writeAsString('\n\t\t\t\t\talways = no', mode: _mode);
        await output.writeAsString('\n\t\t\t\t}', mode: _mode);
        await output.writeAsString('\n\t\t\t}', mode: _mode);

        if (position.isMilitary()) {
          await output.writeAsString('\n\t\t\tvisible = {', mode: _mode);
          await output.writeAsString(
              '\n\t\t\t\tNOT = { has_country_flag = ${nameNoSpace}_dead }',
              mode: _mode);
          await output.writeAsString('\n\t\t\t}', mode: _mode);
        }

        await output.writeAsString('\n\t\t\ton_add = {', mode: _mode);
        await output.writeAsString(
            '\n\t\t\t\tlog = "[GetDateText]: [Root.GetName]: add idea ${minister.token}_${position.prefix}_${minister.ideology.prefix}" ',
            mode: _mode);
        await output.writeAsString('\n\t\t\t}', mode: _mode);

        await output.writeAsString(_traits, mode: _mode);
        await output.writeAsString('\n\t\t\t\t${position.token}', mode: _mode);
        if (position.isGovernment()) {
          await output.writeAsString('\n\t\t\t\t${minister.ideology.token}',
              mode: _mode);
        }
        await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
        await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        if (position.isMilitary()) {
          await output.writeAsString('\n\t\t\tcancel_if_invalid = yes');
        }
        await output.writeAsString('\n\t\t}', mode: _mode); // close
      }
      await output.writeAsString('\n\t}', mode: _mode); // close position
    }
    await output.writeAsString('}', mode: _mode);
  }

  static Future saveMinistersLoc(
    String path,
    Map<Position, List<Minister>> ministers,
  ) async {
    final output = File(path);
    if (await output.exists()) {
      await output.delete();
    }
    await output.create();

    await output.writeAsString('l_english:', mode: _mode);
    for (MapEntry<Position, List<Minister>> entry in ministers.entries) {
      final position = entry.key;
      final ministersGroup = entry.value;

      await output.writeAsString('\n### $position', mode: _mode);
      for (Minister minister in ministersGroup) {
        String pos = position.prefix;
        String ide = minister.ideology.prefix;

        await output.writeAsString(
            '\n${minister.token}_${pos}_$ide:0 "${minister.name}"',
            mode: _mode);
      }
    }
  }

  static Future saveMinistersGFX(
    String path,
    Map<Position, List<Minister>> ministers,
  ) async {
    final output = File(path);
    if (await output.exists()) {
      await output.delete();
    }
    await output.create();

    await output.writeAsString('spriteTypes = {', mode: _mode);
    for (MapEntry<Position, List<Minister>> entry in ministers.entries) {
      final position = entry.key;
      final ministersGroup = entry.value;

      await output.writeAsString('\n### $position', mode: _mode);
      for (Minister minister in ministersGroup) {
        String pos = position.prefix;
        String ide = minister.ideology.prefix;
        String token = '${minister.token}_${pos}_$ide';

        await output.writeAsString('\n\tspriteType = {', mode: _mode);
        await output.writeAsString('\n\t\tname = "GFX_idea_$token"',
            mode: _mode);
        await output.writeAsString(
            '\n\t\ttexturefile = "gfx/interface/ministers/${minister.tag}/${minister.token}.tga"',
            mode: _mode);
        await output.writeAsString('\n\t}', mode: _mode);
      }
    }
    await output.writeAsString('\n}', mode: _mode);
  }

  static Future appendToHistory(String path, List<Character> characters) async {
    final directory = Directory('$path/history/countries');
    final List<FileSystemEntity> entities = await directory.list().toList();

    List<String> tags = characters.map((character) => character.tag).toList();
    tags = tags.toSet().toList();

    final List<File> items = entities.map((e) => e as File).where((e) {
      String name = basename(e.path);
      bool exists = false;
      for (String tag in tags) {
        if (name.startsWith(tag)) {
          exists = true;
        }
      }
      return exists;
    }).toList();
    for (File file in items) {
      List<String> content = await file.readAsLines();
      content.removeWhere((e) => e.startsWith('recruit_character'));
      await file.writeAsString(content.join('\n'));

      String name = basename(file.path);
      String tag = name.substring(0, name.indexOf('-')).trim();
      await file.writeAsString('\n', mode: _mode);
      for (Character character in characters) {
        if (character.tag == tag) {
          await file.writeAsString('\nrecruit_character = ${character.token}',
              mode: _mode);
        }
      }
    }
  }

  static Future saveCharacters(String path, List<Character> characters) async {
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
      if (character.civilianPortrait || character.hasGovernmentRole) {
        await output.writeAsString(_civilian, mode: _mode);
        if (character.civilianPortrait) {
          String generated =
              '$_large "$portraitLargePrefix${character.tag}/Portrait_${character.token}$portraitSuffix"';

          if (character.civilianLargePortrait == null) {
            await output.writeAsString(generated, mode: _mode);
          } else {
            await output.writeAsString(
                '$_large "${character.civilianLargePortrait}"',
                mode: _mode);
          }
        }
        if (character.hasGovernmentRole) {
          String generated =
              '$_small "$portraitSmallPrefix${character.tag}/${character.token}$portraitSuffix"';

          if (character.civilianSmallPortrait == null) {
            await output.writeAsString(generated, mode: _mode);
          } else {
            await output.writeAsString(
                '$_small "${character.civilianSmallPortrait}"',
                mode: _mode);
          }
        }
        await output.writeAsString('\n\t\t\t}', mode: _mode);
      }
      // Add Army Portraits
      if (character.armyPortrait || character.hasArmyRole) {
        await output.writeAsString(_army, mode: _mode);
        if (character.armyPortrait) {
          String generated =
              '$_large "$portraitLargePrefix${character.tag}/Portrait_${character.token}$portraitSuffix"';

          if (character.armyLargePortrait == null) {
            await output.writeAsString(generated, mode: _mode);
          } else {
            await output.writeAsString(
                '$_large "${character.armyLargePortrait}"',
                mode: _mode);
          }
        }
        if (character.hasArmyRole) {
          String generated =
              '$_small "$portraitSmallPrefix${character.tag}/${character.token}$portraitSuffix"';

          if (character.armySmallPortait == null) {
            await output.writeAsString(generated, mode: _mode);
          } else {
            await output.writeAsString(
                '$_small "${character.armySmallPortait}"',
                mode: _mode);
          }
        }
        await output.writeAsString('\n\t\t\t}', mode: _mode);
      }

      // Add Navy Portraits
      if (character.navyPortrait || character.hasNavalRole) {
        await output.writeAsString(_navy, mode: _mode);
        if (character.navyPortrait) {
          String generated =
              '$_large "$portraitLargePrefix${character.tag}/Portrait_${character.token}$portraitSuffix"';

          if (character.navyLargePortrait == null) {
            await output.writeAsString(generated, mode: _mode);
          } else {
            await output.writeAsString(
                '$_large "${character.navyLargePortrait}"',
                mode: _mode);
          }
        }
        if (character.hasNavalRole) {
          String generated =
              '$_small "$portraitSmallPrefix${character.tag}/${character.token}$portraitSuffix"';

          if (character.navySmallPortrait == null) {
            await output.writeAsString(generated, mode: _mode);
          } else {
            await output.writeAsString(
                '$_small "${character.navySmallPortrait}"',
                mode: _mode);
          }
        }
        await output.writeAsString('\n\t\t\t}', mode: _mode);
      }
      await output.writeAsString('\n\t\t}', mode: _mode);

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
        if (character.commanderLandTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        String skill = Character.randomSkill().toString();
        String attack = Character.randomSkill().toString();
        String defense = Character.randomSkill().toString();
        String planning = Character.randomSkill().toString();
        String logistics = Character.randomSkill().toString();

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
        if (character.commanderLandTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        String skill = Character.randomSkill().toString();
        String attack = Character.randomSkill().toString();
        String defense = Character.randomSkill().toString();
        String planning = Character.randomSkill().toString();
        String logistics = Character.randomSkill().toString();

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
        if (character.commanderSeaTraits.isNotEmpty) {
          await output.writeAsString(_traits, mode: _mode);
          for (String trait in character.leaderTraits) {
            await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
          }
          await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        } else {
          await output.writeAsString('$_traits }', mode: _mode);
        }

        String skill = Character.randomSkill().toString();
        String attack = Character.randomSkill().toString();
        String defense = Character.randomSkill().toString();
        String maneuver = Character.randomSkill().toString();
        String coordination = Character.randomSkill().toString();

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

      for (Position position in character.positions) {
        String trait = character.ministerTraits
            .firstWhere((trait) => trait.startsWith(position.prefix));
        String token = character.ideology != Ideology.none
            ? '$_ideaToken ${character.token}_${position.prefix}_${character.ideology.prefix}'
            : '$_ideaToken ${character.token}_${position.prefix}';

        await output.writeAsString(_advisor, mode: _mode);
        await output.writeAsString('$_cost ${character.cost}', mode: _mode);
        await output.writeAsString('$_slot ${position.token}', mode: _mode);
        await output.writeAsString(_available, mode: _mode);
        await output.writeAsString(token, mode: _mode);
        await output.writeAsString(_traits, mode: _mode);
        await output.writeAsString('\n\t\t\t\t${position.token}', mode: _mode);
        await output.writeAsString('\n\t\t\t\t${character.ideology.token}',
            mode: _mode);
        await output.writeAsString('\n\t\t\t\t$trait', mode: _mode);
        await output.writeAsString('\n\t\t\t}', mode: _mode); // close traits
        await output.writeAsString('\n\t\t}', mode: _mode); // close idea
      }

      await output.writeAsString('\n\t}', mode: _mode); // close character
    }
    await output.writeAsString('\n}', mode: _mode);
  }

  static String buildPortraitPath(String token, {bool isLarge = false}) {
    String prefix = isLarge ? portraitLargePrefix : portraitSmallPrefix;
    return '$prefix$token$portraitSuffix';
  }

  static const _ideas = "ideas = {";

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
  static const _admiral = "\n\t\tnavy_leader = {";
  static const _advisor = "\n\t\tadvisor = {";
  static const _cost = "\n\t\t\tcost =";
  static const _slot = "\n\t\t\tslot =";
  static const _available = "\n\t\t\tavailable = { can_replace_minister = no }";
  static const _ideaToken = "\n\t\t\tidea_token =";

  static const _mode = FileMode.append;
  static const portraitLargePrefix = "gfx/leaders/";
  static const portraitSmallPrefix = "gfx/interface/ministers/";
  static const portraitSuffix = ".tga";
}
