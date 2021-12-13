import 'package:automator/characters/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CharacterEditor extends StatefulWidget {
  const CharacterEditor({Key? key}) : super(key: key);

  @override
  _CharacterEditorState createState() => _CharacterEditorState();
}

class _CharacterEditorState extends State<CharacterEditor> {
  List<Position> _positions = [];

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

  Widget get _forms {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: InputDecoration(
            border: _inputBorder,
            hintText: Translations.of(context)!.hint_name,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            border: _inputBorder,
            hintText: Translations.of(context)!.hint_tag,
          ),
          maxLength: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            border: _inputBorder,
            hintText: Translations.of(context)!.hint_ideology,
          ),
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
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
                  Expanded(child: _forms),
                  Expanded(
                    child: Column(
                      children: [],
                    ),
                  )
                ],
              )
            : _forms,
      ),
    );
  }
}
