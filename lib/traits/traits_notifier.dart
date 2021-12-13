import 'package:automator/characters/character.dart';
import 'package:flutter/foundation.dart';

class TraitsNotifier extends ChangeNotifier {
  Map<Position, List<String>> _traits = {};
  Map<Position, List<String>> get traits => _traits;

  change(Map<Position, List<String>> traits) {
    _traits = traits;
    notifyListeners();
  }
}
