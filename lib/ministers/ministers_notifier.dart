import 'package:automator/database/repository.dart';
import 'package:automator/ministers/minister.dart';
import 'package:flutter/foundation.dart';

class MinistersNotifier extends ChangeNotifier {
  final MinisterRepository repository = MinisterRepository();
  List<Minister> _main = [];
  List<Minister> _ministers = [];
  List<Minister> get ministers => _ministers;

  MinistersNotifier() {
    _main = repository.fetch();
    _ministers = [..._main];
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

  reset() {
    repository.clear();
    _ministers.clear();
    notifyListeners();
  }

  search(String query) {
    if (query.isEmpty) {
      _ministers = [..._main];
    } else {
      _ministers = _main.where((minister) {
        return minister.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
