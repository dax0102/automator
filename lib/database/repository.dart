import 'package:automator/characters/character.dart';
import 'package:automator/core/position.dart';
import 'package:automator/shared/tools.dart';
import 'package:hive/hive.dart';

abstract class Repository<T> {
  Future put(T data);
  Future remove(T data);
  List<T> fetch();
}

class CharacterRepository extends Repository<Character> {
  static const boxName = "characters";
  late final Box<Character> _box;
  List<Character> _characters = [];

  CharacterRepository() {
    _box = Hive.box(boxName);
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

class TraitsRepository extends Repository<String> {
  static const boxName = "traits";
  late final Box<String> _box;
  List<String> _traits = [];

  TraitsRepository() {
    _box = Hive.box(boxName);
    _traits = _box.values.toList();
  }

  Map<Position, List<String>> fetchGrouped() {
    return _traits.groupBy((trait) => PositionExtension.getFromPrefix(
        trait.substring(0, trait.indexOf('_'))));
  }

  Future set(Map<Position, List<String>> _traits) async {
    List<String> traits = [];
    for (List<String> items in _traits.values) {
      traits.addAll(items);
    }
    _box.addAll(traits);
  }

  Future clear() async {
    return await _box.clear();
  }

  @override
  List<String> fetch() {
    return _traits;
  }

  @override
  Future put(data) async {
    final index = _traits.indexOf(data);
    // if exists in the entries
    if (index > -1) {
      _traits[index] = data;
    } else {
      _traits.add(data);
    }
    await _box.clear();
    return await _box.addAll(_traits);
  }

  @override
  Future remove(data) async {
    _traits.remove(data);
    await _box.clear();
    return await _box.addAll(_traits);
  }
}
