import 'dart:math';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';

class Character {
  final String name;
  final String tag;
  final Ideology ideology;
  final List<Position> positions;
  final List<String> leaderTraits;
  final List<String> commanderLandTraits;
  final List<String> commanderSeaTraits;
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
    this.commanderLandTraits = const [],
    this.commanderSeaTraits = const [],
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

  bool hasCustomPortraitPath() {
    return civilianLargePortrait != null ||
        civilianSmallPortrait != null ||
        armyLargePortrait != null ||
        armySmallPortait != null ||
        navyLargePortrait != null ||
        navySmallPortrait != null;
  }

  List<String> get parsedSkills {
    return skills?.split(',') ?? [];
  }

  String get token {
    return buildToken(tag, name);
  }

  bool get hasGovernmentRole => hasGovernmentPosition(positions);
  bool get hasMilitaryRole => hasMilitaryPosition(positions);
  bool get hasArmyRole => hasArmyPosition(positions);
  bool get hasNavalRole => hasNavalPosition(positions);

  static int randomSkill() {
    return 1 + Random().nextInt(5 - 1);
  }

  static String buildToken(String tag, String name) {
    return '${tag}_${name.replaceAll(" ", "_")}';
  }

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
