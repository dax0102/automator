import 'package:automator/core/position.dart';
import 'package:automator/database/repository.dart';
import 'package:flutter/foundation.dart';

class TraitsNotifier extends ChangeNotifier {
  final TraitsRepository repository = TraitsRepository();
  Map<Position, List<String>> _traits = {};
  Map<Position, List<String>> get traits => _traits;

  TraitsNotifier() {
    _traits = repository.fetchGrouped();
  }

  change(Map<Position, List<String>> traits) {
    repository.set(traits);
    _traits = repository.fetchGrouped();
    notifyListeners();
  }

  reset() {
    repository.clear();
    notifyListeners();
  }
}
