import 'package:automator/database/repository.dart';
import 'package:automator/ministers/minister.dart';
import 'package:flutter/foundation.dart';

class MinistersNotifier extends ChangeNotifier {
  final MinisterRepository repository = MinisterRepository();
  List<Minister> _ministers = [];
  List<Minister> get ministers => _ministers;

  MinistersNotifier() {
    _ministers = repository.fetch();
  }

  put(Minister minister) {
    repository.put(minister);
    _ministers = repository.fetch();
    notifyListeners();
  }

  remove(Minister minister) {
    _ministers.remove(minister);
    _ministers = repository.fetch();
    notifyListeners();
  }

  void reset() {
    _ministers.clear();
    notifyListeners();
  }
}
