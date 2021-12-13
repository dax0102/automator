import 'package:automator/ministers/minister.dart';
import 'package:flutter/foundation.dart';

class MinistersNotifier extends ChangeNotifier {
  final List<Minister> _ministers = [];
  List<Minister> get ministers => _ministers;

  put(Minister minister) {
    if (_ministers.contains(minister)) {
      final index = _ministers.indexOf(minister);
      assert(index >= 0);
      _ministers[index] = minister;
    } else {
      _ministers.add(minister);
    }
    notifyListeners();
  }

  remove(Minister minister) {
    _ministers.remove(minister);
    notifyListeners();
  }

  void reset() {
    _ministers.clear();
    notifyListeners();
  }
}
