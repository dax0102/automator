import 'dart:io';

import 'package:animations/animations.dart';
import 'package:automator/characters/character.dart';
import 'package:automator/characters/character_editor.dart';
import 'package:automator/characters/character_import.dart';
import 'package:automator/characters/character_table.dart';
import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/core/reader.dart';
import 'package:automator/core/writer.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/custom/state.dart';
import 'package:automator/shared/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  void _onAdd() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => CharacterEditor(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  void _onEdit(Character character) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => CharacterEditor(
          character: character,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  Future _onRemove(Character character) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_remove_character),
          content:
              Text(Translations.of(context)!.dialog_remove_character_subtitle),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_remove),
              onPressed: () {
                Provider.of<CharactersNotifier>(context, listen: false)
                    .remove(character);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(Translations.of(context)!.button_cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _onImport() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null) {
      try {
        final file = File(result.files.single.path!);
        final names = await Reader.importNames(file);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => CharacterImport(
              names: names,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
          ),
        );
      } on MissingContentError {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.of(context)!.feedback_empty_file),
          ),
        );
      }
    }
  }

  void _onExport() async {
    final characters =
        Provider.of<CharactersNotifier>(context, listen: false).characters;
    if (characters.isNotEmpty) {
      String? output =
          await FilePicker.platform.saveFile(fileName: 'ministers.txt');
      if (output != null) {
        Writer writer = Writer(output, characters);
        await writer.save();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedbacK_empty_output),
        ),
      );
    }
  }

  Widget _getHeader(CharactersNotifier notifier) {
    final characters = notifier.characters;
    return Header(
      title: Translations.of(context)!.navigation_characters,
      actions: Header.getDefault(
        context,
        onAdd: _onAdd,
        onImport: _onImport,
        onExport: _onExport,
        onReset: characters.isNotEmpty ? notifier.reset : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharactersNotifier>(
      builder: (context, notifier, _) {
        final characters = notifier.characters;
        return characters.isEmpty
            ? Padding(
                padding: ThemeComponents.defaultPadding,
                child: Column(
                  children: [
                    _getHeader(notifier),
                    EmptyState(
                      title: Translations.of(context)!.state_empty_characters,
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: ThemeComponents.defaultPadding,
                  child: Column(
                    children: [
                      _getHeader(notifier),
                      CharacterTable(
                        characters: characters,
                        onEdit: _onEdit,
                        onRemove: _onRemove,
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
