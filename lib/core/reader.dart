import 'dart:io';

import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';

enum ReadStrategy { single, multiple }

enum Source { csv, yaml }

class Reader {
  const Reader._();

  static Future<List<Character>> importNamesFromYAML(
    File file,
  ) async {
    final source = await file.readAsLines();
    if (source.isEmpty) {
      throw MissingContentError();
    }

    List<Character> characters = [];
    for (String line in source) {
      if (line.contains('_${Position.headOfGovernment.prefix}') ||
          line.contains('_${Position.foreignMinister.prefix}_') ||
          line.contains('_${Position.economyMinister.prefix}') ||
          line.contains('_${Position.securityMinister.prefix}') ||
          line.contains('_${Position.chiefOfStaff.prefix}') ||
          line.contains('_${Position.chiefOfArmy.prefix}') ||
          line.contains('_${Position.chiefOfNavy.prefix}') ||
          line.contains('_${Position.chiefOfAirForce.prefix}')) {
        String name =
            line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
        Ideology ideology = Ideology.none;

        if (line.contains('_${Ideology.vanguardist.prefix}') ||
            line.contains('_${Ideology.collectivist.prefix}') ||
            line.contains('_${Ideology.libertarianSocialist.prefix}') ||
            line.contains('_${Ideology.socialDemocrat.prefix}') ||
            line.contains('_${Ideology.socialLiberal.prefix}') ||
            line.contains('_${Ideology.marketLiberal.prefix}') ||
            line.contains('_${Ideology.socialConservative.prefix}') ||
            line.contains('_${Ideology.authoritarianDemocrat.prefix}') ||
            line.contains('_${Ideology.paternalAutocrat.prefix}') ||
            line.contains('_${Ideology.nationalPopulist}') ||
            line.contains('_${Ideology.valkist.prefix}')) {
          int index = line.lastIndexOf('_');
          String prefix = line.substring(index + 1, line.indexOf(':'));
          ideology = IdeologyExtension.parseFromPrefix(prefix);
        }

        if (name.isNotEmpty &&
            characters.where((x) => x.name == name).isEmpty) {
          characters.add(Character(name: name, tag: "", ideology: ideology));
        }
      }
    }
    return characters;
  }

  static Future<List<String>> importNamesFromCSV(File file) async {
    final source = await file.readAsString();
    if (source.isEmpty) {
      throw MissingContentError();
    }

    List<String> names = source.split(',');
    names = names.map((name) => name.trim()).toList();
    return names;
  }
}

class MissingContentError extends Error {}

class InvalidSourceError extends Error {}
