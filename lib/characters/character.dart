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
  String? allowedCondition;
  String? availableCondition;
  bool headOfState;

  Character({
    required this.name,
    required this.tag,
    required this.ideology,
    this.positions = const [],
    this.traits = const [],
    this.headOfState = false,
  });
}