import 'dart:io';
import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum ReadStrategy { single, multiple }

enum Source { csv, yaml, history }

extension SourceExtension on Source {
  String getLocalization(BuildContext context) {
    switch (this) {
      case Source.csv:
        return Translations.of(context)!.source_csv;
      case Source.yaml:
        return Translations.of(context)!.source_yaml;
      case Source.history:
        return Translations.of(context)!.source_txt;
    }
  }
}

class Reader {
  const Reader._();

  static Future<List<String>> importFromHistory(File file) async {
    final source = await file.readAsLines();
    if (source.isEmpty) {
      throw MissingContentError();
    }

    return _readFromHistory(source);
  }

  static List<String> _readFromHistory(List<String> source) {
    List<String> names = [];
    for (String line in source) {
      if (line.contains('name')) {
        String prev = source[source.indexOf(line) - 1];
        if (prev.contains('create_country_leader') ||
            prev.contains('create_field_marshal') ||
            prev.contains('create_corps_commander') ||
            prev.contains('create_navy_leader')) {
          line = line.trim();
          String name =
              line.substring(line.indexOf('"') + 1, line.lastIndexOf('"'));
          if (!names.contains(name)) {
            names.add(name);
          }
        }
      }
    }
    return names;
  }

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
            line.contains('_${Ideology.nationalPopulist.prefix}') ||
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
