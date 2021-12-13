import 'package:automator/characters/character.dart';
import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/writer.dart';
import 'package:automator/shared/custom/checkbox_form.dart';
import 'package:automator/shared/custom/dropdown_field.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class CharacterEditor extends StatefulWidget {
  const CharacterEditor({Key? key}) : super(key: key);

  @override
  _CharacterEditorState createState() => _CharacterEditorState();
}

class _CharacterEditorState extends State<CharacterEditor> {
  final _nameController = TextEditingController();
  final _tagController = TextEditingController();
  final _civilianLargePortrait = TextEditingController();
  final _civilianSmallPortrait = TextEditingController();
  final _armyLargePortrait = TextEditingController();
  final _armySmallPortrait = TextEditingController();
  final _navyLargePortrait = TextEditingController();
  final _navySmallPortrait = TextEditingController();
  bool _importedTraits = false;
  bool _customPaths = false;
  List<Position> _positions = [];
  List<String> _leaderTraits = [];
  List<String> _commanderLandTraits = [];
  List<String> _commanderSeaTraits = [];
  Map<Position, String> _ministerTraits = {};
  Ideology _ideology = Ideology.vanguardist;
  bool _headOfState = false;
  bool _fieldMarshal = false;
  bool _corpCommander = false;
  bool _admiral = false;
  bool _randomTraits = true;
  bool _civilianPortrait = false;
  bool _armyPortrait = false;
  bool _navyPortrait = false;

  @override
  void initState() {
    super.initState();
    _importedTraits =
        Provider.of<TraitsNotifier>(context, listen: false).traits.isNotEmpty;
    _randomTraits = _importedTraits;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    _civilianLargePortrait.dispose();
    _civilianSmallPortrait.dispose();
    _armyLargePortrait.dispose();
    _armySmallPortrait.dispose();
    _navyLargePortrait.dispose();
    _navySmallPortrait.dispose();
    super.dispose();
  }

  void _onSave() {
    final tag = _tagController.text;
    final token = Character.buildToken(tag, _nameController.text);

    final character = Character(
      name: _nameController.text,
      tag: tag,
      ideology: _ideology,
      positions: _ministerTraits.keys.toList(),
      leaderTraits: _leaderTraits,
      commanderLandTraits: _commanderLandTraits,
      commanderSeaTraits: _commanderSeaTraits,
      ministerTraits: _ministerTraits.values.toList(),
      headOfState: _headOfState,
      fieldMarshal: _fieldMarshal,
      corpCommander: _corpCommander,
      admiral: _admiral,
      civilianPortrait: _civilianPortrait,
      armyPortrait: _armyPortrait,
      navyPortrait: _navyPortrait,
      civilianLargePortrait: _civilianLargePortrait.text.isEmpty
          ? null
          : Writer.buildPortraitPath(tag, token),
      civilianSmallPortrait: _civilianSmallPortrait.text.isEmpty
          ? null
          : Writer.buildPortraitPath(tag, token, isLarge: false),
      armyLargePortrait: _armyLargePortrait.text.isEmpty
          ? null
          : Writer.buildPortraitPath(tag, token),
      armySmallPortait: _armySmallPortrait.text.isEmpty
          ? null
          : Writer.buildPortraitPath(tag, token, isLarge: false),
      navyLargePortrait: _navyLargePortrait.text.isEmpty
          ? null
          : Writer.buildPortraitPath(tag, token),
      navySmallPortrait: _navySmallPortrait.text.isEmpty
          ? null
          : Writer.buildPortraitPath(tag, token, isLarge: false),
    );
    Provider.of<CharactersNotifier>(context, listen: false).put(character);
    Navigator.pop(context);
  }

  Future<String?> _triggerInput() async {
    final traitController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_enter_trait),
          content: TextFormField(
            decoration: InputDecoration(
              border: ThemeComponents.inputBorder,
              hintText: Translations.of(context)!.hint_trait,
            ),
            controller: traitController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_save),
              onPressed: () {
                Navigator.pop(context, traitController.text);
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

  void _modifyPosition(Position position) {
    final positions = _positions;
    if (positions.contains(position)) {
      positions.remove(position);
    } else {
      positions.add(position);
    }
    setState(() => _positions = positions);
  }

  List<Widget> get _form {
    return <Widget>[
      TextFormField(
        decoration: InputDecoration(
          border: ThemeComponents.inputBorder,
          hintText: Translations.of(context)!.hint_name,
        ),
        controller: _nameController,
      ),
      SizedBox(height: ThemeComponents.spacing),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                hintText: Translations.of(context)!.hint_tag,
              ),
              controller: _tagController,
              maxLength: 3,
            ),
          ),
          SizedBox(width: ThemeComponents.spacing),
          Expanded(
            flex: 2,
            child: DropdownInputField<Ideology>(
              selected: _ideology,
              items: Ideology.values,
              labels: Ideology.values
                  .map((i) => i.getLocalization(context))
                  .toList(),
              labelText: Translations.of(context)!.hint_ideology,
              onChange: (selected) {
                setState(() => _ideology = selected);
              },
            ),
          ),
        ],
      ),
      SizedBox(height: ThemeComponents.spacing),
      Text(
        Translations.of(context)!.hint_portraits,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      CheckboxForm(
        value: _civilianPortrait,
        onChanged: (checked) {
          setState(() => _civilianPortrait = checked ?? false);
        },
        title: Text(Translations.of(context)!.hint_civillian),
      ),
      CheckboxForm(
        value: _armyPortrait,
        onChanged: (checked) {
          setState(() => _armyPortrait = checked ?? false);
        },
        title: Text(Translations.of(context)!.hint_army),
      ),
      CheckboxForm(
        value: _navyPortrait,
        onChanged: (checked) {
          setState(() => _navyPortrait = checked ?? false);
        },
        title: Text(Translations.of(context)!.hint_navy),
      ),
      CheckboxForm(
        value: _customPaths,
        onChanged: (checked) {
          setState(() => _customPaths = checked ?? false);
        },
        title: Text(Translations.of(context)!.hint_custom_portrait_paths),
      ),
      SizedBox(height: ThemeComponents.spacing),
      Text(
        Translations.of(context)!.hint_positions,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 8),
      CheckboxForm(
        title: Text(Translations.of(context)!.hint_head_of_state),
        value: _headOfState,
        onChanged: (selected) {
          setState(() => _headOfState = selected ?? false);
          if (selected == false) {
            _leaderTraits.clear();
          }
        },
      ),
      if (_headOfState) _hosTraits,
      CheckboxForm(
        title: Text(Translations.of(context)!.hint_field_marshal),
        value: _fieldMarshal,
        enabled: !_corpCommander,
        onChanged: (selected) {
          setState(() => _fieldMarshal = selected ?? false);
          if (selected == false) {
            _commanderLandTraits.clear();
          }
        },
      ),
      if (_fieldMarshal) _armyTraits,
      CheckboxForm(
        title: Text(Translations.of(context)!.hint_corps_commander),
        value: _corpCommander,
        enabled: !_fieldMarshal,
        onChanged: (selected) {
          setState(() => _corpCommander = selected ?? false);
          if (selected == false) {
            _commanderLandTraits.clear();
          }
        },
      ),
      if (_corpCommander) _armyTraits,
      CheckboxForm(
        value: _admiral,
        onChanged: (selected) {
          setState(() => _admiral = selected ?? false);
          if (selected == false) {
            _commanderSeaTraits.clear();
          }
        },
        title: Text(Translations.of(context)!.hint_admiral),
      ),
      if (_admiral) _navyTraits,
      SizedBox(height: ThemeComponents.spacing),
      Text(
        Translations.of(context)!.hint_ministers,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      SizedBox(height: ThemeComponents.spacing),
      Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 8,
        spacing: 8,
        children: Position.values.map((position) {
          return FilterChip(
            label: Text(position.getLocalization(context)),
            selected: _positions.contains(position),
            onSelected: (_) {
              _modifyPosition(position);
            },
          );
        }).toList(),
      ),
      SizedBox(height: ThemeComponents.spacing),
      if (_importedTraits)
        Column(
          children: [
            CheckboxForm(
              value: _randomTraits,
              enabled: _positions.isNotEmpty,
              onChanged: (selected) {
                setState(() => _randomTraits = selected ?? true);
              },
              title: Text(Translations.of(context)!.hint_random_traits),
            ),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
      if (!_randomTraits && _positions.isNotEmpty) ..._traits,
    ];
  }

  List<Widget> get _portraitsCivilian {
    String large = Translations.of(context)!.hint_large;
    String small = Translations.of(context)!.hint_small;

    return <Widget>[
      if (_civilianPortrait)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_civillian} - $large'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitLargePrefix,
                suffixText: Writer.portraitSuffix,
              ),
              controller: _civilianLargePortrait,
            ),
            const SizedBox(height: 4),
            Text(Translations.of(context)!.concat_sample(_samplePortraitPath)),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
      if (Character.hasGovernmentPosition(_positions))
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_civillian} - $small'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitSmallPrefix,
                suffixText: Writer.portraitSuffix,
              ),
              controller: _civilianSmallPortrait,
            ),
            const SizedBox(height: 4),
            Text(
              Translations.of(context)!.concat_sample(_sampleGFXPath),
            ),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
    ];
  }

  List<Widget> get _portraitsArmy {
    String large = Translations.of(context)!.hint_large;
    String small = Translations.of(context)!.hint_small;

    return <Widget>[
      if (_armyPortrait)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_army} - $large'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitLargePrefix,
                suffixText: Writer.portraitSuffix,
              ),
              controller: _armyLargePortrait,
            ),
            const SizedBox(height: 4),
            Text(Translations.of(context)!.concat_sample(_samplePortraitPath)),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
      if (Character.hasArmyPosition(_positions))
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_army} - $small'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitSmallPrefix,
                suffixText: Writer.portraitSuffix,
              ),
              controller: _armySmallPortrait,
            ),
            const SizedBox(height: 4),
            Text(
              Translations.of(context)!.concat_sample(_sampleGFXPath),
            ),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
    ];
  }

  List<Widget> get _portraitsNavy {
    String large = Translations.of(context)!.hint_large;
    String small = Translations.of(context)!.hint_small;

    return <Widget>[
      if (_navyPortrait)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_navy} - $large'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitLargePrefix,
                suffixText: Writer.portraitSuffix,
              ),
              controller: _navyLargePortrait,
            ),
            const SizedBox(height: 4),
            Text(Translations.of(context)!.concat_sample(_samplePortraitPath)),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
      if (Character.hasNavalPosition(_positions))
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_navy} - $small'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitSmallPrefix,
                suffixText: Writer.portraitSuffix,
              ),
              controller: _navySmallPortrait,
            ),
            const SizedBox(height: 4),
            Text(
              Translations.of(context)!.concat_sample(_sampleGFXPath),
            ),
            SizedBox(height: ThemeComponents.spacing),
          ],
        ),
    ];
  }

  Widget get _hosTraits {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ..._leaderTraits.map((trait) {
            return Chip(
              label: Text(trait),
              onDeleted: () {
                final List<String> traits = _leaderTraits;
                if (traits.contains(trait)) {
                  traits.remove(trait);
                  setState(() => _leaderTraits = traits);
                }
              },
            );
          }).toList(),
          ActionChip(
            avatar: const Icon(Icons.add),
            label: Text(Translations.of(context)!.button_add_trait),
            onPressed: () async {
              final result = await _triggerInput();
              if (result != null) {
                final traits = _leaderTraits;
                if (!traits.contains(result)) {
                  traits.add(result);
                  setState(() => _leaderTraits = traits);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(Translations.of(context)!.feedback_trait_exists),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget get _armyTraits {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ..._commanderLandTraits.map((trait) {
            return Chip(
              label: Text(trait),
              onDeleted: () {
                final List<String> traits = _commanderLandTraits;
                if (traits.contains(trait)) {
                  traits.remove(trait);
                  setState(() => _commanderLandTraits = traits);
                }
              },
            );
          }).toList(),
          ActionChip(
            avatar: const Icon(Icons.add),
            label: Text(Translations.of(context)!.button_add_trait),
            onPressed: () async {
              final result = await _triggerInput();
              if (result != null) {
                final traits = _commanderLandTraits;
                if (!traits.contains(result)) {
                  traits.add(result);
                  setState(() => _commanderLandTraits = traits);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(Translations.of(context)!.feedback_trait_exists),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget get _navyTraits {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ..._commanderSeaTraits.map((trait) {
            return Chip(
              label: Text(trait),
              onDeleted: () {
                final List<String> traits = _commanderSeaTraits;
                if (traits.contains(trait)) {
                  traits.remove(trait);
                  setState(() => _commanderSeaTraits = traits);
                }
              },
            );
          }).toList(),
          ActionChip(
            avatar: const Icon(Icons.add),
            label: Text(Translations.of(context)!.button_add_trait),
            onPressed: () async {
              final result = await _triggerInput();
              if (result != null) {
                final traits = _commanderSeaTraits;
                if (!traits.contains(result)) {
                  traits.add(result);
                  setState(() => _commanderSeaTraits = traits);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text(Translations.of(context)!.feedback_trait_exists),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> get _traits {
    return <Widget>[
      Text(
        Translations.of(context)!.hint_traits,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      SizedBox(height: ThemeComponents.spacing),
      Consumer<TraitsNotifier>(
        builder: (context, notifier, _) {
          return Column(
            children: [
              for (final position in _positions)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    notifier.traits[position] == null
                        ? TextFormField(
                            decoration: InputDecoration(
                              border: ThemeComponents.inputBorder,
                              hintText: position.getLocalization(context),
                            ),
                            onChanged: (trait) {
                              final traits = _ministerTraits;
                              traits[position] = trait;
                              setState(() => _ministerTraits = traits);
                            },
                          )
                        : DropdownInputField<String>(
                            selected: _ministerTraits[position] ??
                                notifier.traits[position]!.first,
                            items: notifier.traits[position]!,
                            onChange: (trait) {
                              final traits = _ministerTraits;
                              traits[position] = trait;
                              setState(() => _ministerTraits = traits);
                            },
                          ),
                    SizedBox(height: ThemeComponents.spacing),
                  ],
                )
            ],
          );
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ElevatedButton(
            onPressed: _onSave,
            child: Text(
              Translations.of(context)!.button_save,
            ),
          ),
        )
      ]),
      body: !_customPaths
          ? SingleChildScrollView(
              child: Padding(
                padding: ThemeComponents.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _form,
                ),
              ),
            )
          : Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: ThemeComponents.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _form,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: Padding(
                      padding: ThemeComponents.defaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._portraitsCivilian,
                          ..._portraitsArmy,
                          ..._portraitsNavy,
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  static const _samplePortraitPath =
      '${Writer.portraitLargePrefix}USA/Portrait_USA_Floyd_Olson.tga';
  static const _sampleGFXPath =
      '${Writer.portraitSmallPrefix}USA/USA_Floyd_Olson.tga';
}
