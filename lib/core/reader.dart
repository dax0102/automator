import 'dart:io';

enum ReadStrategy { single, multiple }

class Reader {
  const Reader._();

  static Future<List<String>> getNamesFromCSV(File source) async {
    final lines = await source.readAsString();
    List<String> names = lines.split(',');
    names = names.map((name) => name.trim()).toList();
    return names;
  }
}
