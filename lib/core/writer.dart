import 'dart:io';

import 'package:automator/characters/character.dart';

class Writer {
  final List<Character> characters;
  final String path;

  const Writer(this.path, this.characters);

  Future save() async {
    final output = File(path);
    if (await output.exists()) {
      await output.delete();
    }
    await output.create();

    await output.writeAsString(_header, mode: _mode);
    for (Character character in characters) {
      await output.writeAsString('\n\t${character.token} = {', mode: _mode);
      await output.writeAsString('\n\t\tname = "${character.name}"',
          mode: _mode);

      // Portraits
      await output.writeAsString('\n\t\tportraits = {', mode: _mode);
      await output.writeAsString('\n\t\t\tcivilian = {', mode: _mode);
      if (character.headOfState) {
        await output.writeAsString(
            '\n\t\t\t\tlarge = $_portraitLargePrefix${character.tag}/Portrait_${character.token}.tga',
            mode: _mode);
      }
      if (character.hasGovernmentPosition()) {
        await output.writeAsString(
            '\n\t\t\t\tsmall = $_portraitSmallPrefix${character.token}',
            mode: _mode);
      }
      await output.writeAsString('\n\t\t\t}', mode: _mode);
      // End Portraits

      await output.writeAsString('\n\t\t}', mode: _mode);

      await output.writeAsString('\n\t}', mode: _mode);
    }
    await output.writeAsString('}', mode: _mode);
  }

  static const _mode = FileMode.append;
  static const _header = "characters = {";
  static const _portraitLargePrefix = "gfx/leaders/";
  static const _portraitSmallPrefix = "GFX_idea_";
}
