import 'package:automator/characters/character.dart';
import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CharacterTable extends StatelessWidget {
  const CharacterTable({
    Key? key,
    required this.characters,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  final List<Character> characters;
  final Function(Character) onEdit;
  final Function(Character) onRemove;

  TableRow _getHeaders(BuildContext context) {
    return TableRow(children: [
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Translations.of(context)!.hint_tag,
            textAlign: ThemeComponents.textAlignment,
          ),
        ),
      ),
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
            Translations.of(context)!.hint_positions,
            textAlign: ThemeComponents.textAlignment,
          ),
        ),
      ),
      TableCell(
        verticalAlignment: ThemeComponents.cellAlignment,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Translations.of(context)!.hint_head_of_state,
            textAlign: ThemeComponents.textAlignment,
          ),
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
          padding: const EdgeInsets.all(8.0),
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
            Translations.of(context)!.button_edit,
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.surface,
      ),
      columnWidths: const {
        0: FractionColumnWidth(0.05),
        1: FractionColumnWidth(0.15),
        2: FractionColumnWidth(0.15),
        3: FractionColumnWidth(0.25)
      },
      children: [
        _getHeaders(context),
        ...characters.map((character) {
          return TableRow(children: [
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(character.tag),
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(character.name),
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(character.ideology.getLocalization(context)),
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
                      label: Text(position.getLocalization(context)),
                    );
                  }).toList(),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Icon(character.headOfState ? Icons.check : Icons.clear),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Icon(character.fieldMarshal ? Icons.check : Icons.clear),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Icon(character.corpCommander ? Icons.check : Icons.clear),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Icon(character.admiral ? Icons.check : Icons.clear),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  onEdit(character);
                },
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  onRemove(character);
                },
              ),
            ),
          ]);
        })
      ],
    );
  }
}
