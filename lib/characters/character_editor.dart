import 'package:automator/characters/character.dart';
import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/core/ideologies.dart';
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
      body: _randomTraits || _positions.isEmpty
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: ThemeComponents.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _traits,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
