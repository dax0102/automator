import 'dart:io';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum Position {
  headOfGovernment,
  foreignMinister,
  economyMinister,
  securityMinister,
  chiefOfStaff,
  chiefOfArmy,
  chiefOfNavy,
  chiefOfAirForce,
}

extension PositionExtension on Position {
  static const prefixHeadOfGovernment = "hog";
  static const prefixForeignMinister = "for";
  static const prefixEconomyMinister = "eco";
  static const prefixSecurityMinister = "sec";
  static const prefixChiefOfStaff = "cos";
  static const prefixChiefOfArmy = "carm";
  static const prefixChiefOfNavy = "cnav";
  static const prefixChiefOfAirForce = "cair";

  static List<Position> get government {
    return [
      Position.headOfGovernment,
      Position.foreignMinister,
      Position.economyMinister,
      Position.securityMinister
    ];
  }

  static List<Position> get military {
    return [
      Position.chiefOfStaff,
      Position.chiefOfArmy,
      Position.chiefOfNavy,
      Position.chiefOfAirForce
    ];
  }

  String getLocalization(BuildContext context) {
    switch (this) {
      case Position.headOfGovernment:
        return Translations.of(context)!.position_hog;
      case Position.foreignMinister:
        return Translations.of(context)!.position_for;
      case Position.economyMinister:
        return Translations.of(context)!.position_eco;
      case Position.securityMinister:
        return Translations.of(context)!.position_sec;
      case Position.chiefOfStaff:
        return Translations.of(context)!.position_cos;
      case Position.chiefOfArmy:
        return Translations.of(context)!.position_carm;
      case Position.chiefOfNavy:
        return Translations.of(context)!.position_cnav;
      case Position.chiefOfAirForce:
        return Translations.of(context)!.position_cair;
    }
  }

  String get prefix {
    switch (this) {
      case Position.headOfGovernment:
        return prefixHeadOfGovernment;
      case Position.foreignMinister:
        return prefixForeignMinister;
      case Position.economyMinister:
        return prefixEconomyMinister;
      case Position.securityMinister:
        return prefixSecurityMinister;
      case Position.chiefOfStaff:
        return prefixChiefOfStaff;
      case Position.chiefOfArmy:
        return prefixChiefOfArmy;
      case Position.chiefOfNavy:
        return prefixChiefOfNavy;
      case Position.chiefOfAirForce:
        return prefixChiefOfAirForce;
    }
  }
}

class Character {
  String name;
  String tag;
  String ideology;
  List<Position> positions;
  List<String> traits;
  bool headOfState;
  bool fieldMarshal;
  bool corpCommander;
  bool admiral;

  Character({
    required this.name,
    required this.tag,
    required this.ideology,
    this.positions = const [],
    this.traits = const [],
    this.headOfState = false,
    this.fieldMarshal = false,
    this.corpCommander = false,
    this.admiral = false,
  });

  static Future<List<String>> getNamesFromCSV(File source) async {
    final lines = await source.readAsString();
    List<String> names = lines.split(',');
    names = names.map((name) => name.trim()).toList();
    return names;
  }

  static String randomTrait(Position position, List<String> traits) {
    final random = Random();
    return traits[random.nextInt(traits.length)];
  }
}
