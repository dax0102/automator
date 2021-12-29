import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/database/repository.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  const HiveDatabase._();

  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(PositionAdapter());
    Hive.registerAdapter(IdeologyAdapter());

    final Box<Character> characterBox =
        await Hive.openBox(CharacterRepository.boxName);
    final Box<String> traitsBox = await Hive.openBox(TraitsRepository.boxName);

    return Future;
  }
}
