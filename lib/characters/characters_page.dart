import 'dart:io';

import 'package:animations/animations.dart';
import 'package:automator/characters/character.dart';
import 'package:automator/characters/character_editor.dart';
import 'package:automator/characters/character_import.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

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
                onAdd: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, _, __) => const CharacterEditor(),
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
                onEdit: () {},
                onRemove: () {},
                onImport: () async {
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
                              transitionType:
                                  SharedAxisTransitionType.horizontal,
                              child: child,
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              ),
            ),
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
