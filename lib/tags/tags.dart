import 'dart:io';

class Tag {
  const Tag._();

  static Future<List<String>> getTags(File source) async {
    List<String> tags = [];
    final lines = await source.readAsLines();
    for (final line in lines) {
      if (!line.startsWith("#") || !line.contains("dynamic_tags")) {
        String tag = line.substring(0, line.indexOf('='));
        tag = tag.trim();
        tags.add(tag);
      }
    }

    return tags;
  }
}
