import 'package:automator/core/position.dart';
import 'package:flutter/foundation.dart';

class TraitsNotifier extends ChangeNotifier {
  Map<Position, List<String>> _traits = {};
  Map<Position, List<String>> get traits => _traits;

  change(Map<Position, List<String>> traits) {
    _traits.clear();
    _traits = traits;
    notifyListeners();
  }

  reset() {
    _traits = {};
    notifyListeners();
  }
}
