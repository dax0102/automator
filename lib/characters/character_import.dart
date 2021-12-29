import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CharacterImport extends StatefulWidget {
  const CharacterImport({
    Key? key,
    required this.tag,
    required this.names,
  }) : super(key: key);
  final String tag;
  final List<String> names;

  @override
  _CharacterImportState createState() => _CharacterImportState();
}

class _CharacterImportState extends State<CharacterImport> {
  static get _cellAlignment => TableCellVerticalAlignment.middle;
  static get _textAlignment => TextAlign.center;

  Map<String, Ideology> _ideologies = {};
  Map<String, List<Position>> _positions = {};
  Map<String, bool> _headOfState = {};
  Map<String, bool> _fieldMarshal = {};
  Map<String, bool> _corpCommander = {};
  Map<String, bool> _admiral = {};

  Future<Ideology?> _showIdeologyPicker(Ideology ideology) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_select_ideology),
          content: Column(
            children: Ideology.values.map(
              (_ideology) {
                return RadioListTile<Ideology>(
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
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    for (var name in widget.names) {
      _ideologies[name] = Ideology.vanguardist;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: ThemeComponents.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(Translations.of(context)!.concat_for_tag(widget.tag)),
              SizedBox(height: ThemeComponents.spacing),
              Table(
                border: TableBorder.all(
                  color: Theme.of(context).colorScheme.surface,
                ),
                columnWidths: const {
                  0: FractionColumnWidth(0.2),
                  1: FractionColumnWidth(0.2),
                  2: FractionColumnWidth(0.4),
                },
                children: [
                  TableRow(children: [
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_name,
                        textAlign: _textAlignment,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_ideology,
                        textAlign: _textAlignment,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_positions,
                        textAlign: _textAlignment,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_head_of_state,
                        textAlign: _textAlignment,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_field_marshal,
                        textAlign: _textAlignment,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_corps_commander,
                        textAlign: _textAlignment,
                      ),
                    ),
                    TableCell(
                      verticalAlignment: _cellAlignment,
                      child: Text(
                        Translations.of(context)!.hint_admiral,
                        textAlign: _textAlignment,
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
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: Position.values.map((position) {
                              return FilterChip(
                                label: Text(position.prefix.toUpperCase()),
                                selected:
                                    _positions[name]?.contains(position) ??
                                        false,
                                onSelected: (_) {
                                  final Map<String, List<Position>> root =
                                      _positions;
                                  final List<Position> positions =
                                      root[name] ?? [];
                                  if (positions.contains(position)) {
                                    positions.remove(position);
                                  } else {
                                    positions.add(position);
                                  }
                                  root[name] = positions;
                                  setState(() => _positions = root);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: _cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _headOfState[name] ?? false,
                          onChanged: (checked) {
                            final headOfState = _headOfState;
                            headOfState[name] = checked ?? false;
                            setState(() => _headOfState = headOfState);
                          },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: _cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _fieldMarshal[name] ?? false,
                          onChanged: (checked) {
                            final fieldMarshal = _fieldMarshal;
                            fieldMarshal[name] = checked ?? false;
                            setState(() => _fieldMarshal = fieldMarshal);
                          },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: _cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _corpCommander[name] ?? false,
                          onChanged: (checked) {
                            final corpCommander = _corpCommander;
                            corpCommander[name] = checked ?? false;
                            setState(() => _corpCommander = corpCommander);
                          },
                        ),
                      ),
                      TableCell(
                        verticalAlignment: _cellAlignment,
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          value: _admiral[name] ?? false,
                          onChanged: (checked) {
                            final admiral = _admiral;
                            admiral[name] = checked ?? false;
                            setState(() => _admiral = admiral);
                          },
                        ),
                      )
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
}
