import 'dart:io';

import 'package:automator/characters/character.dart';

class Traits {
  const Traits._();

  static Future<Map<Position, List<String>>> fetch(File file) async {
    final source = await file.readAsLines();
    return {
      Position.headOfGovernment: fetchHeadofGovernment(source),
      Position.foreignMinister: fetchForeignMinister(source),
      Position.economyMinister: fetchEconomyMinister(source),
      Position.securityMinister: fetchSecurityMinister(source),
      Position.chiefOfStaff: fetchChiefOfStaff(source),
      Position.chiefOfArmy: fetchChiefOfArmy(source),
      Position.chiefOfNavy: fetchChiefOfNavy(source),
      Position.chiefOfAirForce: fetchChiefOfAirForce(source),
    };
  }

  static List<String> _extract(List<String> lines, String prefix) {
    String safePrefix = '${prefix}_';
    List<String> extracted = [];
    for (String line in lines) {
      if (line.contains(safePrefix)) {
        String trait =
            line.substring(line.indexOf(safePrefix), line.indexOf('='));
        extracted.add(trait.trim());
      }
    }
    return extracted;
  }

  static List<String> fetchHeadofGovernment(List<String> lines) {
    return _extract(lines, Position.headOfGovernment.prefix);
  }

  static List<String> fetchForeignMinister(List<String> lines) {
    return _extract(lines, Position.foreignMinister.prefix);
  }

  static List<String> fetchEconomyMinister(List<String> lines) {
    return _extract(lines, Position.economyMinister.prefix);
  }

  static List<String> fetchSecurityMinister(List<String> lines) {
    return _extract(lines, Position.securityMinister.prefix);
  }

  static List<String> fetchChiefOfStaff(List<String> lines) {
    return _extract(lines, Position.chiefOfStaff.prefix);
  }

  static List<String> fetchChiefOfArmy(List<String> lines) {
    return _extract(lines, Position.chiefOfArmy.prefix);
  }

  static List<String> fetchChiefOfNavy(List<String> lines) {
    return _extract(lines, Position.chiefOfNavy.prefix);
  }

  static List<String> fetchChiefOfAirForce(List<String> lines) {
    return _extract(lines, Position.chiefOfAirForce.prefix);
  }
}
