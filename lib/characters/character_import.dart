import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/shared/custom/checkbox_form.dart';
import 'package:automator/shared/custom/dropdown_field.dart';
import 'package:automator/shared/custom/radio_form.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CharacterImport extends StatefulWidget {
  const CharacterImport({
    Key? key,
    required this.names,
  }) : super(key: key);
  final List<String> names;

  @override
  _CharacterImportState createState() => _CharacterImportState();
}

class _CharacterImportState extends State<CharacterImport> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  Map<String, Ideology> _ideologies = {};
  Map<String, Map<Position, String>> _positions = {};
  Map<String, List<String>> _leaderTraits = {};
  Map<String, List<String>> _commanderLandTraits = {};
  Map<String, List<String>> _commanderSeaTraits = {};
  Map<String, bool> _headOfState = {};
  Map<String, bool> _fieldMarshal = {};
  Map<String, bool> _corpCommander = {};
  Map<String, bool> _admiral = {};
  Map<String, int> _portraits = {};

  @override
  void initState() {
    super.initState();
    for (var name in widget.names) {
      _ideologies[name] = Ideology.vanguardist;
    }
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final List<Character> characters = [];
    for (String name in widget.names) {
      final portrait = _portraits[name] ?? 0;

      Character character = Character(
        name: name,
        tag: _tagController.text,
        ideology: _ideologies[name] ?? Ideology.values.first,
        positions: _positions[name]?.keys.toList() ?? [],
        headOfState: _headOfState[name] ?? false,
        fieldMarshal: _fieldMarshal[name] ?? false,
        corpCommander: _corpCommander[name] ?? false,
        admiral: _admiral[name] ?? false,
        ministerTraits: _positions[name]?.keys.map(
              (position) {
                return Character.randomTrait(
                    position,
                    Provider.of<TraitsNotifier>(context).traits[position] ??
                        []);
              },
            ).toList() ??
            [],
        civilianPortrait: portrait & _civilianPortrait == _civilianPortrait,
        armyPortrait: portrait & _armyPortrait == _armyPortrait,
        navyPortrait: portrait & _navyPortrait == _navyPortrait,
        leaderTraits: _leaderTraits[name] ?? [],
        commanderLandTraits: _commanderLandTraits[name] ?? [],
        commanderSeaTraits: _commanderSeaTraits[name] ?? [],
      );
      characters.add(character);
    }
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
                      Navigator.pop(context, Role(position, trait!));
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

  Future<int?> _showPortraitChooser(int? portraits) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        int _portraits = portraits ?? 0;

        return StatefulBuilder(builder: (BuildContext context, setState) {
          return AlertDialog(
              title: Text(
                  Translations.of(context)!.dialog_generate_portrait_paths),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxForm(
                    value: _portraits & _civilianPortrait == _civilianPortrait,
                    onChanged: (checked) {
                      int portraits = _portraits;
                      if (checked == true) {
                        portraits += _civilianPortrait;
                      } else {
                        portraits -= _civilianPortrait;
                      }
                      setState(() => _portraits = portraits);
                    },
                    title: Text(Translations.of(context)!.hint_civillian),
                  ),
                  CheckboxForm(
                    value: _portraits & _armyPortrait == _armyPortrait,
                    onChanged: (checked) {
                      int portraits = _portraits;
                      if (checked == true) {
                        portraits += _armyPortrait;
                      } else {
                        portraits -= _armyPortrait;
                      }
                      setState(() => _portraits = portraits);
                    },
                    title: Text(Translations.of(context)!.hint_army),
                  ),
                  CheckboxForm(
                    value: _portraits & _navyPortrait == _navyPortrait,
                    onChanged: (checked) {
                      int portraits = _portraits;
                      if (checked == true) {
                        portraits += _navyPortrait;
                      } else {
                        portraits -= _navyPortrait;
                      }
                      setState(() => _portraits = portraits);
                    },
                    title: Text(Translations.of(context)!.hint_navy),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(Translations.of(context)!.button_save),
                  onPressed: () {
                    Navigator.pop(context, _portraits);
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

  Future<List<String>?> _showTraitEditor(String name, {int type = 0}) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        List<String> traits = [];
        switch (type) {
          case 0:
            traits = _leaderTraits[name] ?? [];
            break;
          case 1:
            traits = _commanderLandTraits[name] ?? [];
            break;
          case 2:
            traits = _commanderSeaTraits[name] ?? [];
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
                    Navigator.pop(context, traitController.text.split(','));
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

  Widget _configureButton(String name, int portraits) {
    String label = "";
    if (portraits & _civilianPortrait == _civilianPortrait) {
      label += Translations.of(context)!.hint_civillian;
    }
    if (portraits & _armyPortrait == _armyPortrait) {
      if (label.isNotEmpty) {
        label += ", ";
      }
      label += Translations.of(context)!.hint_army;
    }
    if (portraits & _navyPortrait == _navyPortrait) {
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
        final result = await _showPortraitChooser(_portraits[name]);
        if (result != null) {
          final portraits = _portraits;
          portraits[name] = result;
          setState(() => _portraits = portraits);
        }
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
            child: ElevatedButton(
              onPressed: _onSave,
              child: Text(Translations.of(context)!.button_save),
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
                  1: FractionColumnWidth(0.15),
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
                  ]),
                  ...widget.names.map((name) {
                    return TableRow(children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(name),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: TextButton(
                          onPressed: () async {
                            final ideology =
                                await _showIdeologyPicker(_ideologies[name]!);
                            if (ideology != null) {
                              final ideologies = _ideologies;
                              ideologies[name] = ideology;
                              setState(() => _ideologies = ideologies);
                            }
                          },
                          child:
                              Text(_ideologies[name]!.getLocalization(context)),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.fill,
                        child: _configureButton(name, _portraits[name] ?? 0),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              if (_positions[name]?.values != null)
                                ..._positions[name]!
                                    .keys
                                    .map((position) => Chip(
                                          label: Text(position
                                              .getLocalization(context)),
                                          onDeleted: () {
                                            final Map<Position, String>
                                                positions =
                                                _positions[name] ?? {};
                                            if (positions
                                                .containsKey(position)) {
                                              positions.remove(position);
                                              setState(() =>
                                                  _positions[name] = positions);
                                            }
                                          },
                                        ))
                                    .toList(),
                              ActionChip(
                                avatar: const Icon(Icons.add_outlined),
                                label:
                                    Text(Translations.of(context)!.button_add),
                                onPressed: () async {
                                  Role? role =
                                      await _showPositionAndTraitPicker();
                                  if (role != null) {
                                    final positions = _positions[name] ?? {};
                                    positions[role.position] = role.trait;
                                    setState(
                                        () => _positions[name] = positions);
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
                          value: _headOfState[name] ?? false,
                          onChanged: (checked) async {
                            final headOfState = _headOfState;
                            headOfState[name] = checked ?? false;
                            setState(() => _headOfState = headOfState);
                            if (checked == true) {
                              final traits = await _showTraitEditor(name);
                              if (traits != null) {
                                final leaderTrait = _leaderTraits;
                                leaderTrait[name] = traits;
                                setState(() => _leaderTraits = leaderTrait);
                              }
                            }
                          },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _fieldMarshal[name] ?? false,
                          onChanged: _corpCommander[name] == true
                              ? null
                              : (checked) async {
                                  final fieldMarshal = _fieldMarshal;
                                  fieldMarshal[name] = checked ?? false;
                                  setState(() => _fieldMarshal = fieldMarshal);
                                  if (checked == true) {
                                    final traits =
                                        await _showTraitEditor(name, type: 1);
                                    if (traits != null) {
                                      final commanderTrait =
                                          _commanderLandTraits;
                                      commanderTrait[name] = traits;
                                      setState(() => _commanderLandTraits =
                                          commanderTrait);
                                    }
                                  }
                                },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _corpCommander[name] ?? false,
                          onChanged: _fieldMarshal[name] == true
                              ? null
                              : (checked) async {
                                  final corpCommander = _corpCommander;
                                  corpCommander[name] = checked ?? false;
                                  setState(
                                      () => _corpCommander = corpCommander);
                                  if (checked == true) {
                                    final traits =
                                        await _showTraitEditor(name, type: 1);
                                    if (traits != null) {
                                      final commanderTrait =
                                          _commanderLandTraits;
                                      commanderTrait[name] = traits;
                                      setState(() => _commanderLandTraits =
                                          commanderTrait);
                                    }
                                  }
                                },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: ThemeComponents.cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _admiral[name] ?? false,
                          onChanged: (checked) async {
                            final admiral = _admiral;
                            admiral[name] = checked ?? false;
                            setState(() => _admiral = admiral);
                            if (checked == true) {
                              final traits =
                                  await _showTraitEditor(name, type: 2);
                              if (traits != null) {
                                final commanderTrait = _commanderSeaTraits;
                                commanderTrait[name] = traits;
                                setState(
                                    () => _commanderSeaTraits = commanderTrait);
                              }
                            }
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
