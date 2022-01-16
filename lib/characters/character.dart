import 'dart:math';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/shared/tools.dart';
import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character {
  @HiveField(0)
  final String name;
  @HiveField(1)
  String tag;
  @HiveField(2)
  Ideology ideology;
  @HiveField(3)
  List<Position> positions;
  @HiveField(4)
  List<String> leaderTraits;
  @HiveField(5)
  List<String> commanderLandTraits;
  @HiveField(6)
  List<String> commanderSeaTraits;
  @HiveField(7)
  List<String> ministerTraits;
  @HiveField(8)
  bool headOfState;
  @HiveField(9)
  bool fieldMarshal;
  @HiveField(10)
  bool corpCommander;
  @HiveField(11)
  bool admiral;
  @HiveField(12)
  bool civilianPortrait;
  @HiveField(13)
  bool armyPortrait;
  @HiveField(14)
  bool navyPortrait;
  @HiveField(15)
  String? skills;
  @HiveField(16)
  String? civilianLargePortrait;
  @HiveField(17)
  String? civilianSmallPortrait;
  @HiveField(18)
  String? armyLargePortrait;
  @HiveField(19)
  String? armySmallPortait;
  @HiveField(20)
  String? navyLargePortrait;
  @HiveField(21)
  String? navySmallPortrait;
  @HiveField(22)
  int cost;
  @HiveField(23)
  List<Ideology> leaderRoles;
  @HiveField(24)
  String? id;

  Character({
    required this.name,
    required this.tag,
    required this.ideology,
    this.id,
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
    this.cost = 150,
    this.leaderRoles = const [],
  }) {
    id ??= randomId();
  }

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
    String token = name.withoutDiacriticalMarks;
    token = token.replaceAll('.', '');
    token = token.replaceAll('\'', '_');
    token = token.replaceAll('-', '_');
    return '${tag}_${token.replaceAll(" ", "_")}';
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
