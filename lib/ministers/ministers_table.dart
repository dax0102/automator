import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/ministers/minister.dart';
import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class MinistersTable extends StatelessWidget {
  const MinistersTable({
    Key? key,
    required this.ministers,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  final List<Minister> ministers;
  final Function(Minister) onEdit;
  final Function(Minister) onRemove;

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
        1: FractionColumnWidth(0.2),
        2: FractionColumnWidth(0.15),
        3: FractionColumnWidth(0.45)
      },
      children: [
        _getHeaders(context),
        ...ministers.map((minister) {
          return TableRow(children: [
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(minister.tag),
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(minister.name),
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(minister.ideology.getLocalization(context)),
              ),
            ),
            TableCell(
              verticalAlignment: ThemeComponents.cellAlignment,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: minister.positions.map((position) {
                    return Chip(
                      label: Text(position.getLocalization(context)),
                    );
                  }).toList(),
                ),
              ),
            ),
            TableCell(
                child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                onEdit(minister);
              },
            )),
            TableCell(
                child: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                onRemove(minister);
              },
            )),
          ]);
        })
      ],
    );
  }
}
