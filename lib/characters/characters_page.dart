import 'dart:io';

import 'package:animations/animations.dart';
import 'package:automator/characters/character.dart';
import 'package:automator/characters/character_editor.dart';
import 'package:automator/characters/character_import.dart';
import 'package:automator/characters/character_table.dart';
import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/reader.dart';
import 'package:automator/core/writer.dart';
import 'package:automator/settings/settings_notifier.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/custom/indicator.dart';
import 'package:automator/shared/custom/state.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/shared/tools.dart';
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
  void _invokeIndicator() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              backgroundColor: Colors.black87,
              content: Indicator(
                  heading: Translations.of(context)!.feedback_writing_files),
            ),
            onWillPop: () async => false);
      },
    );
  }

  Future _onBrowsePrompt() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_browse_directory),
          content:
              Text(Translations.of(context)!.dialog_browse_directory_subtitle),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_continue),
              onPressed: () {
                Navigator.pop(context, Future.value(true));
              },
            )
          ],
        );
      },
    );
  }

  Future _onExtractionComplete(List<Character> items) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        List<Character> names = items;

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              title: Text(Translations.of(context)!.dialog_name_extraction),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 256,
                  height: 512,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: names.length,
                    itemBuilder: (context, index) {
                      final character = names[index];
                      return ListTile(
                        title: Text(character.name),
                        leading: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            final _names = names;
                            names.remove(character);
                            setState(() => names = _names);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Translations.of(context)!.button_continue),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, _, __) => CharacterImport(
                          characters: names,
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
      },
    );
  }

  void _onAdd() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => const CharacterEditor(),
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
        final names = await Reader.importNamesFromCSV(file);
        List<Character> characters = names.map((name) {
          return Character(name: name, tag: "", ideology: Ideology.none);
        }).toList();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => CharacterImport(
              characters: characters,
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

  void _onExtract() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml'],
    );
    if (result != null) {
      try {
        final file = File(result.files.single.path!);
        final names = await Reader.importNamesFromYAML(file);
        await _onExtractionComplete(names);
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

    if (characters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_empty_output),
        ),
      );
    }

    _invokeIndicator();
    String? directory =
        await Provider.of<SettingsNotifier>(context, listen: false)
            .getWorkspaceDirectory();

    if (directory == null) {
      bool? response = await _onBrowsePrompt();
      if (response == null) {
        return;
      }
      directory = await FilePicker.platform.getDirectoryPath();
    }

    if (directory != null) {
      final items = characters.groupBy((c) => c.tag);
      String destination = '$directory/common/characters/';
      for (MapEntry<String, List<Character>> item in items.entries) {
        await Writer.saveCharacters('$destination${item.key}.txt', item.value);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_operation_complete),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(Translations.of(context)!.feedback_provide_valid_directory),
        ),
      );
    }
  }

  void _onAppend() async {
    final characters =
        Provider.of<CharactersNotifier>(context, listen: false).characters;

    if (characters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_empty_output),
        ),
      );
    }

    String? directory =
        await Provider.of<SettingsNotifier>(context, listen: false)
            .getWorkspaceDirectory();

    if (directory == null) {
      bool? response = await _onBrowsePrompt();
      if (response == null) {
        return;
      }
      directory = await FilePicker.platform.getDirectoryPath();
    }

    if (directory != null) {
      await Writer.appendToHistory(directory, characters);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_operation_complete),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(Translations.of(context)!.feedback_provide_valid_directory),
        ),
      );
    }
  }

  Widget _getHeader(CharactersNotifier notifier) {
    final characters = notifier.characters;
    return Header(
      title: Translations.of(context)!.navigation_characters,
      actions: [
        ...Header.getDefault(
          context,
          onAdd: _onAdd,
          onImport: _onImport,
          onExport: _onExport,
          onReset: characters.isNotEmpty ? notifier.reset : null,
        ),
        ElevatedButton.icon(
          onPressed: _onExtract,
          icon: const Icon(Icons.read_more_outlined),
          label: Text(Translations.of(context)!.button_extract),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.history_edu_outlined),
          label: Text(Translations.of(context)!.button_append_to_history),
          onPressed: _onAppend,
        )
      ],
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
