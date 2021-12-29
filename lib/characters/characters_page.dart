import 'dart:io';

import 'package:animations/animations.dart';
import 'package:automator/characters/character.dart';
import 'package:automator/characters/character_editor.dart';
import 'package:automator/characters/character_import.dart';
import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/writer.dart';
import 'package:automator/shared/custom/header.dart';
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
  final _tagInputFormKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();

  Future<String?> _invokeTagInput() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_enter_tag),
          content: Form(
            key: _tagInputFormKey,
            child: TextFormField(
              controller: _tagController,
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                hintText: Translations.of(context)!.hint_tag,
              ),
              maxLength: 3,
              validator: (text) {
                if (text == null || text.length != 3) {
                  return Translations.of(context)!.feedback_invalid_tag;
                }

                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (_tagInputFormKey.currentState!.validate()) {
                  Navigator.pop(context, _tagController.text);
                }
              },
              child: Text(Translations.of(context)!.button_continue),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(Translations.of(context)!.button_cancel),
            )
          ],
        );
      },
    );
  }

  void _onAdd() async {
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

  void _onImport() async {
    final tag = await _invokeTagInput();
    if (tag != null) {
      _tagController.clear();
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = File(result.files.single.path!);
        final names = await Character.getNamesFromCSV(file);
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => CharacterImport(
              tag: tag,
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
      }
    }
  }

  void _onExport() async {
    final characters =
        Provider.of<CharactersNotifier>(context, listen: false).characters;
    String? output =
        await FilePicker.platform.saveFile(fileName: 'ministers.txt');
    if (output != null) {
      Writer writer = Writer(output, characters);
      await writer.save();
    }
  }

  TableRow get _headers {
    return TableRow(children: [
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_tag,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_name,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_ideology,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_positions,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_head_of_state,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_field_marshal,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_corps_commander,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Text(
          Translations.of(context)!.hint_admiral,
          textAlign: ThemeComponents.textAlignment,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ThemeComponents.defaultPadding,
        child: Column(
          children: [
            Header(
              title: Translations.of(context)!.navigation_characters,
              actions: Header.getDefault(
                context,
                onAdd: _onAdd,
                onImport: _onImport,
                onExport: _onExport,
              ),
            ),
            Consumer<CharactersNotifier>(
              builder: (context, notifier, _) {
                final characters = notifier.characters;
                return Table(
                  border: TableBorder.all(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  columnWidths: const {
                    0: FractionColumnWidth(0.05),
                    1: FractionColumnWidth(0.2),
                    2: FractionColumnWidth(0.2),
                    3: FractionColumnWidth(0.3)
                  },
                  children: [
                    _headers,
                    ...characters.map((character) {
                      return TableRow(children: [
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(character.tag),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(character.name),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                                character.ideology.getLocalization(context)),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: character.positions.map((position) {
                                return Chip(
                                  label:
                                      Text(position.getLocalization(context)),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Icon(character.headOfState
                              ? Icons.check
                              : Icons.clear),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Icon(character.fieldMarshal
                              ? Icons.check
                              : Icons.clear),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Icon(character.corpCommander
                              ? Icons.check
                              : Icons.clear),
                        ),
                        TableCell(
                          verticalAlignment: ThemeComponents.cellAlignment,
                          child: Icon(
                              character.admiral ? Icons.check : Icons.clear),
                        ),
                      ]);
                    })
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}
