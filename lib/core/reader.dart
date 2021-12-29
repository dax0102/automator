import 'dart:io';

import 'package:automator/core/position.dart';

enum ReadStrategy { single, multiple }

enum Source { csv, yaml }

class Reader {
  const Reader._();

  static Future<List<String>> importNamesFromYAML(
    File file,
  ) async {
    final source = await file.readAsLines();
    if (source.isEmpty) {
      throw MissingContentError();
    }

    List<String> names = [];
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
        if (name.isNotEmpty && !names.contains(name)) {
          names.add(name);
        }
      }
    }
    return names;
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
