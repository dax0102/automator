import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    this.actions = const [],
  }) : super(key: key);
  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 16),
        if (actions.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: actions.map((widget) {
              return Padding(
                child: widget,
                padding: actions.first == widget
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.symmetric(horizontal: 8),
              );
            }).toList(),
          ),
        if (actions.isNotEmpty) const SizedBox(height: 16),
      ],
    );
  }

  static List<Widget> getDefault(
    BuildContext context, {
    Function()? onAdd,
    Function()? onEdit,
    Function()? onRemove,
    Function()? onImport,
    Function()? onExport,
    Function()? onReset,
  }) {
    return [
      if (onAdd != null)
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text(Translations.of(context)!.button_add),
        ),
      if (onEdit != null)
        ElevatedButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: Text(Translations.of(context)!.button_edit),
        ),
      if (onRemove != null)
        ElevatedButton.icon(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outlined),
          label: Text(Translations.of(context)!.button_remove),
        ),
      if (onImport != null)
        ElevatedButton.icon(
          onPressed: onImport,
          icon: const Icon(Icons.upload_file_outlined),
          label: Text(Translations.of(context)!.button_import),
        ),
      if (onExport != null)
        ElevatedButton.icon(
          onPressed: onExport,
          icon: const Icon(Icons.download_outlined),
          label: Text(Translations.of(context)!.button_export),
        ),
      if (onReset != null)
        ElevatedButton.icon(
          onPressed: onReset,
          icon: const Icon(Icons.clear_outlined),
          label: Text(Translations.of(context)!.button_reset),
        )
    ];
  }
}
