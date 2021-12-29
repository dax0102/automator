import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/shared/custom/checkbox_form.dart';
import 'package:automator/shared/custom/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CharacterEditor extends StatefulWidget {
  const CharacterEditor({Key? key}) : super(key: key);

  @override
  _CharacterEditorState createState() => _CharacterEditorState();
}

class _CharacterEditorState extends State<CharacterEditor> {
  String _name = "";
  String _tag = "";
  List<Position> _positions = [];
  Ideology _ideology = Ideology.vanguardist;
  bool _headOfState = false;
  bool _fieldMarshal = false;
  bool _corpCommander = false;
  bool _admiral = false;
  bool _randomTraits = true;

  InputBorder get _inputBorder => const OutlineInputBorder();

  void _modifyPosition(Position position) {
    final positions = _positions;
    if (positions.contains(position)) {
      positions.remove(position);
    } else {
      positions.add(position);
    }
    setState(() => _positions = positions);
  }

  String get nameToken {
    return _name.replaceAll(" ", "_").toLowerCase();
  }

  List<Widget> get _preview {
    return [
      if (nameToken.isNotEmpty && _tag.isNotEmpty)
        Text('${_tag.toUpperCase()}_$nameToken = {'),
      if (nameToken.isNotEmpty) Text('\tname = "$_name"'),
      if (_headOfState)
        Text(
            '\tcountry_leader = {\n\t\t\t\tideology = ${_ideology.token}\n\t\t\t\texpire = "1965.1.1"\n\t}'),
    ];
  }

  List<Widget> get _form {
    return [
      TextFormField(
        decoration: InputDecoration(
          border: _inputBorder,
          hintText: Translations.of(context)!.hint_name,
        ),
        onChanged: (name) {
          setState(() => _name = name);
        },
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: TextFormField(
              decoration: InputDecoration(
                border: _inputBorder,
                hintText: Translations.of(context)!.hint_tag,
              ),
              onChanged: (tag) {
                setState(() => _tag = tag);
              },
              maxLength: 3,
            ),
          ),
          const SizedBox(width: 16),
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
      const SizedBox(height: 16),
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
      const SizedBox(height: 16),
      Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 8,
        spacing: 8,
        children: Position.values.map((position) {
          return ChoiceChip(
            label: Text(position.getLocalization(context)),
            selected: _positions.contains(position),
            onSelected: (_) {
              _modifyPosition(position);
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 16),
      CheckboxForm(
        value: _randomTraits,
        onChanged: (selected) {
          setState(() => _randomTraits = selected ?? true);
        },
        title: Text(Translations.of(context)!.hint_random_traits),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              Translations.of(context)!.button_save,
            ),
          ),
        )
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: width >= height
            ? Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _form,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _preview,
                    ),
                  )
                ],
              )
            : Column(
                children: _form,
              ),
      ),
    );
  }
}
