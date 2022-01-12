import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:hive/hive.dart';

part 'minister.g.dart';

@HiveType(typeId: 3)
class Minister {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String tag;
  @HiveField(2)
  final IdeologyKR ideology;
  @HiveField(3)
  final List<Position> positions;
  @HiveField(4)
  final List<String> traits;

  Minister({
    required this.name,
    required this.tag,
    required this.ideology,
    required this.positions,
    required this.traits,
  });

  String get token {
    return buildToken(tag, name);
  }

  static String buildToken(String tag, String name) {
    return '${tag}_${name.replaceAll(" ", "_")}';
  }
}
