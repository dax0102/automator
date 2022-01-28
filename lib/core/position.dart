import 'package:automator/shared/tools.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:hive/hive.dart';

part 'position.g.dart';

@HiveType(typeId: 1)
enum Position {
  @HiveField(0)
  headOfGovernment,
  @HiveField(1)
  foreignMinister,
  @HiveField(2)
  economyMinister,
  @HiveField(3)
  securityMinister,
  @HiveField(4)
  chiefOfStaff,
  @HiveField(5)
  chiefOfArmy,
  @HiveField(6)
  chiefOfNavy,
  @HiveField(7)
  chiefOfAirForce
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

  bool isGovernment() {
    return this == Position.headOfGovernment ||
        this == Position.foreignMinister ||
        this == Position.economyMinister ||
        this == Position.securityMinister;
  }

  bool isMilitary() {
    return this == Position.chiefOfStaff ||
        this == Position.chiefOfArmy ||
        this == Position.chiefOfNavy ||
        this == Position.chiefOfAirForce;
  }

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

  static Position getFromPrefix(String prefix) {
    switch (prefix) {
      case prefixHeadOfGovernment:
        return Position.headOfGovernment;
      case prefixForeignMinister:
        return Position.foreignMinister;
      case prefixEconomyMinister:
        return Position.economyMinister;
      case prefixSecurityMinister:
        return Position.securityMinister;
      case prefixChiefOfStaff:
        return Position.chiefOfStaff;
      case prefixChiefOfArmy:
        return Position.chiefOfArmy;
      case prefixChiefOfNavy:
        return Position.chiefOfNavy;
      case prefixChiefOfAirForce:
        return Position.chiefOfAirForce;
      default:
        throw InvalidPrefixError();
    }
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
