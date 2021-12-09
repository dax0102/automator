import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';

class Minister {
  final String name;
  final String tag;
  final IdeologyKR ideology;
  final List<Position> positions;
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
