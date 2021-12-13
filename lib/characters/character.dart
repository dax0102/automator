import 'dart:io';
import 'dart:math';
import 'package:automator/core/ideologies.dart';
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
  static const tokenHeadOfGovernment = "head_of_government";
  static const tokenForeignMinister = "foreign_minister";
  static const tokenEconomyMinister = "economy_minister";
  static const tokenSecurityMinister = "security_minister";
  static const tokenChiefOfStaff = "chief_of_staff";
  static const tokenChiefOfArmy = "chief_of_army";
  static const tokenChiefOfNavy = "chief_of_navy";
  static const tokenChiefOfAirForce = "chief_of_air_force";

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

  String get token {
    switch (this) {
      case Position.headOfGovernment:
        return tokenHeadOfGovernment;
      case Position.foreignMinister:
        return tokenForeignMinister;
      case Position.economyMinister:
        return tokenEconomyMinister;
      case Position.securityMinister:
        return tokenSecurityMinister;
      case Position.chiefOfStaff:
        return tokenChiefOfStaff;
      case Position.chiefOfArmy:
        return tokenChiefOfArmy;
      case Position.chiefOfNavy:
        return tokenChiefOfNavy;
      case Position.chiefOfAirForce:
        return tokenChiefOfAirForce;
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
  final String name;
  final String tag;
  final Ideology ideology;
  final List<Position> positions;
  final List<String> leaderTraits;
  final List<String> commanderTraits;
  final List<String> ministerTraits;
  final bool headOfState;
  final bool fieldMarshal;
  final bool corpCommander;
  final bool admiral;
  final bool civilianPortrait;
  final bool armyPortrait;
  final bool navyPortrait;
  final String? skills;
  final String? civilianLargePortrait;
  final String? civilianSmallPortrait;
  final String? armyLargePortrait;
  final String? armySmallPortait;
  final String? navyLargePortrait;
  final String? navySmallPortrait;

  Character({
    required this.name,
    required this.tag,
    required this.ideology,
    this.positions = const [],
    this.leaderTraits = const [],
    this.commanderTraits = const [],
    this.ministerTraits = const [],
    this.headOfState = false,
    this.fieldMarshal = false,
    this.corpCommander = false,
    this.admiral = false,
    this.civilianPortrait = false,
    this.armyPortrait = false,
    this.navyPortrait = false,
    this.skills,
    this.civilianLargePortrait,
    this.civilianSmallPortrait,
    this.armyLargePortrait,
    this.armySmallPortait,
    this.navyLargePortrait,
    this.navySmallPortrait,
  });

  static int randomSkill() {
    return 1 + Random().nextInt(5 - 1);
  }

  List<String> get parsedSkills {
    return skills?.split(',') ?? [];
  }

  String get token {
    return '${tag}_${name.replaceAll(" ", "_")}';
  }

  bool get hasGovernmentRole => hasGovernmentPosition(positions);
  bool get hasMilitaryRole => hasMilitaryPosition(positions);
  bool get hasArmyRole => hasArmyPosition(positions);
  bool get hasNavalRole => hasNavalPosition(positions);

  static bool hasGovernmentPosition(List<Position> positions) {
    return positions.contains(Position.headOfGovernment) ||
        positions.contains(Position.foreignMinister) ||
        positions.contains(Position.economyMinister) ||
        positions.contains(Position.securityMinister);
  }

  static bool hasMilitaryPosition(List<Position> positions) {
    return positions.contains(Position.chiefOfStaff) ||
        positions.contains(Position.chiefOfArmy) ||
        positions.contains(Position.chiefOfNavy) ||
        positions.contains(Position.chiefOfAirForce);
  }

  static bool hasArmyPosition(List<Position> positions) {
    return positions.contains(Position.chiefOfStaff) ||
        positions.contains(Position.chiefOfArmy) ||
        positions.contains(Position.chiefOfAirForce);
  }

  static bool hasNavalPosition(List<Position> positions) {
    return positions.contains(Position.chiefOfNavy);
  }

  static String randomTrait(Position position, List<String> traits) {
    final random = Random();
    return traits[random.nextInt(traits.length)];
  }
}
