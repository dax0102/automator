import 'package:automator/characters/character.dart';
import 'package:flutter/foundation.dart';

class CharactersNotifier extends ChangeNotifier {
  final List<Character> _characters = [];
  List<Character> get characters => _characters;

  put(Character character) {
    if (_characters.contains(character)) {
      final index = _characters.indexOf(character);
      assert(index >= 0);
      _characters[index] = character;
    } else {
      _characters.add(character);
    }
    notifyListeners();
  }

  remove(Character character) {
    _characters.remove(character);
    notifyListeners();
  }

  reset() {
    _characters.clear();
    notifyListeners();
  }
}
