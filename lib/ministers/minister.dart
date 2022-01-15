import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/shared/tools.dart';
import 'package:hive/hive.dart';

part 'minister.g.dart';

@HiveType(typeId: 3)
class Minister {
  @HiveField(0)
  String name;
  @HiveField(1)
  String tag;
  @HiveField(2)
  IdeologyKR ideology;
  @HiveField(3)
  List<Position> positions;
  @HiveField(4)
  List<String> traits;
  @HiveField(5)
  String? id;

  Minister({
    required this.name,
    required this.tag,
    required this.ideology,
    required this.positions,
    required this.traits,
    this.id,
  }) {
    id ??= randomId();
  }

  String get token {
    return buildToken(tag, name);
  }

  static String buildToken(String tag, String name) {
    String token = name.replaceAll('\'', '_');
    token = token.replaceAll('-', '_');
    token = token.replaceAll('.', '');
    token = token.replaceAll(' ', '_');
    return '${tag}_$token';
  }
}
