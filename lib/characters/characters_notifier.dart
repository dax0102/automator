import 'package:automator/characters/character.dart';
import 'package:automator/database/repository.dart';
import 'package:flutter/foundation.dart';

class CharactersNotifier extends ChangeNotifier {
  final CharacterRepository repository = CharacterRepository();
  List<Character> _main = [];
  List<Character> _characters = [];
  List<Character> get characters => _characters;

  CharactersNotifier() {
    _main = repository.fetch();
    _characters = [..._main];
  }

  put(Character character) {
    repository.put(character);
    _characters = repository.fetch();
    notifyListeners();
  }

  remove(Character character) {
    repository.remove(character);
    _characters = repository.fetch();
    notifyListeners();
  }

  reset() {
    _characters.clear();
    notifyListeners();
  }

  search(String query) {
    if (query.isEmpty) {
      _characters = [..._main];
    } else {
      _characters = _main.where((character) {
        return character.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
