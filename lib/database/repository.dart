import 'package:automator/characters/character.dart';
import 'package:hive/hive.dart';

abstract class Repository<T> {
  Future put(T data);
  Future remove(T data);
  List<T> fetch();
}

class CharacterRepository extends Repository<Character> {
  static const _boxName = "characters";
  final _box = Hive.box<Character>(_boxName);
  List<Character> _characters = [];

  static Future<bool> open() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Character>(_boxName);
    }
    return true;
  }

  CharacterRepository() {
    _characters = _box.values.toList();
  }

  @override
  List<Character> fetch() {
    return _characters;
  }

  @override
  Future put(data) async {
    final index = _characters.indexWhere((c) => c.name == data.name);
    // if exists in the entries
    if (index > -1) {
      _characters[index] = data;
    } else {
      _characters.add(data);
    }
    await _box.clear();
    return await _box.addAll(_characters);
  }

  @override
  Future remove(data) async {
    _characters.removeWhere((c) => c.name == c.name);
    await _box.clear();
    return await _box.addAll(_characters);
  }
}
