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
  bool _customPaths = false;
  List<Position> _positions = [];
  List<String> _leaderTraits = [];
  List<String> _commanderTraits = [];
  List<String> _ministerTraits = [];
  Ideology _ideology = Ideology.vanguardist;
  bool _headOfState = false;
  bool _fieldMarshal = false;
  bool _corpCommander = false;
  bool _admiral = false;
  bool _randomTraits = true;

  void _onSave() {
    final character = Character(
      name: _nameController.text,
      tag: _tagController.text,
      ideology: _ideology,
      positions: _positions,
      leaderTraits: _leaderTraits,
      commanderTraits: _commanderTraits,
      ministerTraits: _ministerTraits,
      headOfState: _headOfState,
      fieldMarshal: _fieldMarshal,
      corpCommander: _corpCommander,
      admiral: _admiral,
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
                            onChanged: (text) {
                              if (!_ministerTraits.contains(text)) {
                                _ministerTraits.add(text);
                              }
                            },
                          )
                        : DropdownInputField<String>(
                            selected: _ministerTraits.firstWhere(
                                (trait) => trait.startsWith(position.prefix),
                                orElse: () {
                              return notifier.traits[position]!.first;
                            }),
                            items: notifier.traits[position]!,
                            onChange: (trait) {
                              if (!_ministerTraits.contains(trait)) {
                                _ministerTraits.add(trait);
                              }
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
        },
      ),
      CheckboxForm(
        title: Text(Translations.of(context)!.hint_field_marshal),
        value: _fieldMarshal,
        enabled: !_corpCommander,
        onChanged: (selected) {
          setState(() => _fieldMarshal = selected ?? false);
        },
      ),
      if (_fieldMarshal)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._commanderTraits.map((trait) {
              return Chip(
                label: Text(trait),
                onDeleted: () {
                  final List<String> traits = _commanderTraits;
                  if (traits.contains(trait)) {
                    traits.remove(trait);
                    setState(() => _commanderTraits = traits);
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
                  final traits = _commanderTraits;
                  if (!traits.contains(result)) {
                    traits.add(result);
                    setState(() => _commanderTraits = traits);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            Translations.of(context)!.feedback_trait_exists),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      CheckboxForm(
        title: Text(Translations.of(context)!.hint_corps_commander),
        value: _corpCommander,
        enabled: !_fieldMarshal,
        onChanged: (selected) {
          setState(() => _corpCommander = selected ?? false);
        },
      ),
      CheckboxForm(
        value: _admiral,
        onChanged: (selected) {
          setState(() => _admiral = selected ?? false);
        },
        title: Text(Translations.of(context)!.hint_admiral),
      ),
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
      CheckboxForm(
        value: _randomTraits,
        enabled: _positions.isNotEmpty,
        onChanged: (selected) {
          setState(() => _randomTraits = selected ?? true);
        },
        title: Text(Translations.of(context)!.hint_random_traits),
      ),
      SizedBox(height: ThemeComponents.spacing),
      if (!_randomTraits && _positions.isNotEmpty) ..._traits,
    ];
  }

  List<Widget> get _portraitsCivilian {
    String large = Translations.of(context)!.hint_large;
    String small = Translations.of(context)!.hint_small;

    return <Widget>[
      if (_headOfState)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_civillian} - $large'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitLargePrefix,
              ),
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
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Translations.of(context)!.concat_sample(_sampleGFXPath),
            ),
          ],
        ),
    ];
  }

  List<Widget> get _portraitsArmy {
    String large = Translations.of(context)!.hint_large;
    String small = Translations.of(context)!.hint_small;

    return <Widget>[
      if (_fieldMarshal || _corpCommander)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_army} - $large'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitLargePrefix,
              ),
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
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Translations.of(context)!.concat_sample(_sampleGFXPath),
            ),
          ],
        ),
    ];
  }

  List<Widget> get _portraitsNavy {
    String large = Translations.of(context)!.hint_large;
    String small = Translations.of(context)!.hint_small;

    return <Widget>[
      if (_admiral)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${Translations.of(context)!.hint_navy} - $large'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: InputDecoration(
                border: ThemeComponents.inputBorder,
                prefixText: Writer.portraitLargePrefix,
              ),
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
              ),
            ),
            const SizedBox(height: 4),
            Text(
              Translations.of(context)!.concat_sample(_sampleGFXPath),
            ),
          ],
        ),
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
                          if (_headOfState ||
                              Character.hasGovernmentPosition(_positions))
                            ..._portraitsCivilian,
                          if (_fieldMarshal ||
                              _corpCommander ||
                              Character.hasArmyPosition(_positions))
                            ..._portraitsArmy,
                          if (_admiral ||
                              Character.hasNavalPosition(_positions))
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
