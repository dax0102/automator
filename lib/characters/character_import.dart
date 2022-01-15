import 'dart:io';

import 'package:automator/characters/character.dart';
import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/core/reader.dart';
import 'package:automator/shared/custom/checkbox_form.dart';
import 'package:automator/shared/custom/dropdown_field.dart';
import 'package:automator/shared/custom/radio_form.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CharacterImport extends StatefulWidget {
  const CharacterImport({
    Key? key,
    required this.characters,
  }) : super(key: key);
  final List<Character> characters;

  @override
  _CharacterImportState createState() => _CharacterImportState();
}

class _CharacterImportState extends State<CharacterImport> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  List<Character> _characters = [];

  @override
  void initState() {
    super.initState();
    _characters = [...widget.characters];
  }

  void _onUpdateCharacters(List<Character> characters) {
    List<Character> merged = _characters;
    for (Character character in characters) {
      if (merged.indexWhere((c) => character.name == c.name) < 0) {
        merged.add(character);
      }
    }
    setState(() => _characters = merged);
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    for (Character character in _characters) {
      character.tag = _tagController.text;
      Provider.of<CharactersNotifier>(context, listen: false).put(character);
    }
    Navigator.pop(context);
  }

  Future<Ideology?> _showIdeologyPicker(Ideology ideology) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_select_ideology),
          content: SingleChildScrollView(
            child: Column(
              children: Ideology.values.map(
                (_ideology) {
                  return RadioForm<Ideology>(
                    groupValue: ideology,
                    title: Text(_ideology.getLocalization(context)),
                    value: _ideology,
                    onChanged: (checked) {
                      Navigator.pop(context, _ideology);
                    },
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<Role?> _showPositionAndTraitPicker() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final _traitController = TextEditingController();
        String? trait;
        Position position = Position.values.first;

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Consumer<TraitsNotifier>(builder: (context, notifier, _) {
            final _importedTraits = notifier.traits.isNotEmpty;
            if (_importedTraits) {
              trait ??= notifier.traits[position]!.first;
            }

            return AlertDialog(
              title: Text(Translations.of(context)!.dialog_select_trait),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownInputField<Position>(
                    selected: position,
                    items: Position.values,
                    labels: Position.values
                        .map((position) => position.getLocalization(context))
                        .toList(),
                    onChange: (item) {
                      setState(() {
                        position = item;
                        trait = notifier.traits[item]!.first;
                      });
                    },
                  ),
                  SizedBox(height: ThemeComponents.spacing),
                  _importedTraits
                      ? DropdownInputField<String>(
                          selected: trait ?? notifier.traits[position]!.first,
                          items: notifier.traits[position] ?? [],
                          onChange: (item) {
                            setState(() => trait = item);
                          },
                        )
                      : TextFormField(
                          decoration: InputDecoration(
                            border: ThemeComponents.inputBorder,
                            hintText: Translations.of(context)!.hint_trait,
                          ),
                          controller: _traitController,
                        ),
                ],
              ),
              actions: [
                TextButton(
                    child: Text(Translations.of(context)!.button_save),
                    onPressed: () {
                      Navigator.pop(context,
                          Role(position, trait ?? _traitController.text));
                    }),
                TextButton(
                  child: Text(Translations.of(context)!.button_cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
        });
      },
    );
  }

  Future<int?> _showPortraitChooser(
    bool hasCivilian,
    bool hasArmy,
    bool hasNavy,
  ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        int portraits = 0;
        if (hasCivilian) {
          portraits += _civilianPortrait;
        }
        if (hasArmy) {
          portraits += _armyPortrait;
        }
        if (hasNavy) {
          portraits += _navyPortrait;
        }

        return StatefulBuilder(builder: (
          BuildContext context,
          StateSetter setState,
        ) {
          return AlertDialog(
              title: Text(
                Translations.of(context)!.dialog_generate_portrait_paths,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxForm(
                    value: portraits & _civilianPortrait == _civilianPortrait,
                    onChanged: (checked) {
                      int _portraits = portraits;
                      if (checked == true) {
                        _portraits += _civilianPortrait;
                      } else {
                        _portraits -= _civilianPortrait;
                      }
                      setState(() => portraits = _portraits);
                    },
                    title: Text(Translations.of(context)!.hint_civillian),
                  ),
                  CheckboxForm(
                    value: portraits & _armyPortrait == _armyPortrait,
                    onChanged: (checked) {
                      int _portraits = portraits;
                      if (checked == true) {
                        _portraits += _armyPortrait;
                      } else {
                        _portraits -= _armyPortrait;
                      }
                      setState(() => portraits = _portraits);
                    },
                    title: Text(Translations.of(context)!.hint_army),
                  ),
                  CheckboxForm(
                    value: portraits & _navyPortrait == _navyPortrait,
                    onChanged: (checked) {
                      int _portraits = portraits;
                      if (checked == true) {
                        _portraits += _navyPortrait;
                      } else {
                        _portraits -= _navyPortrait;
                      }
                      setState(() => portraits = _portraits);
                    },
                    title: Text(Translations.of(context)!.hint_navy),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Translations.of(context)!.button_save),
                  onPressed: () {
                    Navigator.pop(context, portraits);
                  },
                ),
                TextButton(
                  child: Text(Translations.of(context)!.button_cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ]);
        });
      },
    );
  }

  Future<List<String>?> _showTraitEditor(Character character,
      {int type = 0}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        List<String> traits = [];
        switch (type) {
          case 0:
            traits = character.leaderTraits;
            break;
          case 1:
            traits = character.commanderLandTraits;
            break;
          case 2:
            traits = character.commanderSeaTraits;
            break;
        }
        final traitController = TextEditingController(text: traits.join(','));
        debugPrint(traits.map((t) => t).toString());

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(Translations.of(context)!.dialog_enter_trait),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(Translations.of(context)!.dialog_enter_trait_subtitle),
                  SizedBox(height: ThemeComponents.spacing),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: ThemeComponents.inputBorder,
                        hintText: Translations.of(context)!.hint_traits,
                      ),
                      controller: traitController,
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Translations.of(context)!.button_save),
                  onPressed: () {
                    final traits = traitController.text;
                    if (traits.isEmpty) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context, traitController.text.split(','));
                    }
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

  Future<Source?> _showSourcePicker() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_import_source),
          content: SizedBox(
            width: 256,
            height: 128,
            child: ListView(
              shrinkWrap: true,
              children: Source.values.map((source) {
                return ListTile(
                  title: Text(source.getLocalization(context)),
                  onTap: () {
                    Navigator.pop(context, source);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _configureButton(Character character) {
    String label = "";
    if (character.civilianPortrait) {
      label += Translations.of(context)!.hint_civillian;
    }
    if (character.armyPortrait) {
      if (label.isNotEmpty) {
        label += ", ";
      }
      label += Translations.of(context)!.hint_army;
    }
    if (character.navyPortrait) {
      if (label.isNotEmpty) {
        label += ", ";
      }
      label += Translations.of(context)!.hint_navy;
    }

    return TextButton.icon(
      icon: const Icon(Icons.settings_outlined),
      label: Text(
        label.isEmpty ? Translations.of(context)!.button_configure : label,
      ),
      onPressed: () async {
        final result = await _showPortraitChooser(character.civilianPortrait,
            character.armyPortrait, character.navyPortrait);
        if (result != null) {
          final characters = _characters;
          character.civilianPortrait =
              result & _civilianPortrait == _civilianPortrait;
          character.armyPortrait = result & _armyPortrait == _armyPortrait;
          character.navyPortrait = result & _navyPortrait == _navyPortrait;

          final index = characters.indexWhere((c) => c.name == character.name);
          if (index > -1) {
            characters[index] = character;
            setState(() => _characters = characters);
          }
        }
      },
    );
  }

  void _onAdd() async {
    final source = await _showSourcePicker();
    if (source != null) {
      switch (source) {
        case Source.csv:
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['csv'],
          );
          if (result != null) {
            try {
              final file = File(result.files.single.path!);
              final names = await Reader.importNamesFromCSV(file);
              List<Character> imported = names.map((name) {
                return Character(name: name, tag: "", ideology: Ideology.none);
              }).toList();

              _onUpdateCharacters(imported);
            } on MissingContentError {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(Translations.of(context)!.feedback_empty_file),
                ),
              );
            }
          }
          break;
        case Source.yaml:
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['yml'],
          );
          if (result != null) {
            try {
              final file = File(result.files.single.path!);
              final imported = await Reader.importNamesFromYAML(file);
              final names = await _onExtractionComplete(imported);
              if (names != null) {
                _onUpdateCharacters(names);
              }
            } on MissingContentError {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(Translations.of(context)!.feedback_empty_file),
                ),
              );
            }
          }
          break;
        case Source.history:
          final result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['txt'],
          );
          if (result != null) {
            try {
              final file = File(result.files.single.path!);
              final names = await Reader.importFromHistory(file);
              List<Character> imported = names.map((name) {
                return Character(name: name, tag: "", ideology: Ideology.none);
              }).toList();

              _onUpdateCharacters(imported);
            } on MissingContentError {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(Translations.of(context)!.feedback_empty_file),
                ),
              );
            }
          }
          break;
      }
    }
  }

  Future<List<Character>?> _onExtractionComplete(List<Character> items) async {
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
                    Navigator.pop(context, names);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _onAdd,
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _onSave,
                  child: Text(Translations.of(context)!.button_save),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ThemeComponents.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: ThemeComponents.inputBorder,
                          hintText: Translations.of(context)!.hint_tag,
                        ),
                        maxLength: 3,
                        controller: _tagController,
                        validator: (tag) {
                          if (tag == null || tag.isEmpty || tag.length > 3) {
                            return Translations.of(context)!
                                .feedback_invalid_tag;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
              SizedBox(height: ThemeComponents.spacing),
              Table(
                border: TableBorder.all(
                  color: Theme.of(context).colorScheme.surface,
                ),
                columnWidths: const {
                  0: FractionColumnWidth(0.2),
                  1: FractionColumnWidth(0.1),
                  2: FractionColumnWidth(0.15),
                  3: FractionColumnWidth(0.25)
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Translations.of(context)!.hint_name,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Translations.of(context)!.hint_ideology,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Translations.of(context)!.hint_portraits,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Translations.of(context)!.hint_positions,
                          textAlign: ThemeComponents.textAlignment,
                        ),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Translations.of(context)!.hint_field_marshal,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Translations.of(context)!.hint_corps_commander,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          Translations.of(context)!.hint_admiral,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: ThemeComponents.cellAlignment,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          Translations.of(context)!.button_remove,
                          textAlign: ThemeComponents.textAlignment,
                        ),
                      ),
                    ),
                  ]),
                  ..._characters.map((character) {
                    return TableRow(children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(character.name),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: TextButton(
                          onPressed: () async {
                            final ideology =
                                await _showIdeologyPicker(character.ideology);
                            if (ideology != null) {
                              final characters = _characters;
                              character.ideology = ideology;
                              int index = characters
                                  .indexWhere((c) => c.name == character.name);
                              characters[index] = character;

                              if (character.headOfState) {
                                character.headOfState = false;
                              }
                              setState(() {
                                _characters = characters;
                              });
                            }
                          },
                          child:
                              Text(character.ideology.getLocalization(context)),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: _configureButton(character),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              ...character.positions.map((position) => Chip(
                                    label: Text(
                                      position.getLocalization(context),
                                    ),
                                    onDeleted: () {
                                      final characters = _characters;
                                      final positions = character.positions;
                                      positions.remove(position);

                                      final index = characters.indexWhere(
                                          (c) => c.name == character.name);
                                      if (index > -1) {
                                        characters[index] = character;
                                      }

                                      setState(() => _characters = characters);
                                    },
                                  )),
                              ActionChip(
                                avatar: const Icon(Icons.add_outlined),
                                label:
                                    Text(Translations.of(context)!.button_add),
                                onPressed: () async {
                                  Role? role =
                                      await _showPositionAndTraitPicker();
                                  if (role != null) {
                                    final characters = _characters;
                                    List<Position> positions = [
                                      ...character.positions
                                    ];
                                    List<String> ministerTraits = [
                                      ...character.ministerTraits
                                    ];
                                    positions.add(role.position);
                                    ministerTraits.add(role.trait);

                                    character.positions = positions;
                                    character.ministerTraits = ministerTraits;
                                    setState(() {
                                      _characters = characters;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: character.headOfState,
                          onChanged: character.ideology != Ideology.none
                              ? (checked) async {
                                  final characters = _characters;
                                  character.headOfState = checked ?? false;

                                  int index = characters.indexWhere(
                                      (c) => c.name == character.name);
                                  if (index > -1) {
                                    characters[index] = character;
                                  }

                                  if (checked == true) {
                                    final traits =
                                        await _showTraitEditor(character);
                                    if (traits != null) {
                                      character.leaderTraits = traits;
                                    }
                                  }

                                  setState(() => _characters = characters);
                                }
                              : null,
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: character.fieldMarshal,
                          onChanged: character.corpCommander
                              ? null
                              : (checked) async {
                                  final characters = _characters;
                                  character.fieldMarshal = checked ?? false;

                                  int index = characters.indexWhere(
                                      (c) => c.name == character.name);
                                  if (index > -1) {
                                    characters[index] = character;
                                  }

                                  if (checked == true) {
                                    final traits = await _showTraitEditor(
                                        character,
                                        type: 1);
                                    if (traits != null) {
                                      character.commanderLandTraits = traits;
                                    }
                                  }

                                  setState(() => _characters = characters);
                                },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: character.corpCommander,
                          onChanged: character.fieldMarshal
                              ? null
                              : (checked) async {
                                  final characters = _characters;
                                  character.corpCommander = checked ?? false;

                                  int index = characters.indexWhere(
                                      (c) => c.name == character.name);
                                  if (index > -1) {
                                    characters[index] = character;
                                  }

                                  if (checked == true) {
                                    final traits = await _showTraitEditor(
                                        character,
                                        type: 1);
                                    if (traits != null) {
                                      character.commanderLandTraits = traits;
                                    }
                                  }

                                  setState(() => _characters = characters);
                                },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: character.admiral,
                          onChanged: (checked) async {
                            final characters = _characters;
                            character.admiral = checked ?? false;

                            int index = characters
                                .indexWhere((c) => c.name == character.name);
                            if (index > -1) {
                              characters[index] = character;
                            }

                            if (checked == true) {
                              final traits =
                                  await _showTraitEditor(character, type: 1);
                              if (traits != null) {
                                character.commanderSeaTraits = traits;
                              }
                            }

                            setState(() => _characters = characters);
                          },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () {
                            final characters = _characters;
                            characters.removeWhere((c) => c.id == character.id);
                            setState(() => _characters = characters);
                          },
                        ),
                      ),
                    ]);
                  }).toList()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static const _civilianPortrait = 1;
  static const _armyPortrait = 2;
  static const _navyPortrait = 4;
}

class Role {
  final Position position;
  final String trait;

  const Role(this.position, this.trait);
}
