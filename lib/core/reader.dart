import 'dart:io';

enum ReadStrategy { single, multiple }

class Reader {
  const Reader._();

  static Future<List<String>> importNames(File file) async {
    final source = await file.readAsString();
    if (source.isEmpty) {
      throw MissingContentError();
    }

    List<String> names = source.split(',');
    names = names.map((name) => name.trim()).toList();
    return names;
  }
}

class MissingContentError extends Error {}

class InvalidSourceError extends Error {}
