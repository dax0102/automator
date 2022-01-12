import 'package:automator/core/ideologies.dart';
import 'package:automator/core/position.dart';
import 'package:automator/ministers/minister.dart';
import 'package:automator/ministers/ministers_notifier.dart';
import 'package:automator/shared/custom/dropdown_field.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/shared/tools.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class MinisterEditor extends StatefulWidget {
  const MinisterEditor({Key? key, this.minister}) : super(key: key);

  final Minister? minister;

  @override
  _MinisterEditorState createState() => _MinisterEditorState();
}

class _MinisterEditorState extends State<MinisterEditor> {
  late TextEditingController _nameController;
  late TextEditingController _tagController;
  IdeologyKR _ideology = IdeologyKR.totalist;
  List<Position> _positions = [];
  Map<Position, String> _ministerTraits = {};

  @override
  void initState() {
    super.initState();
    try {
      final minister = widget.minister;

      _nameController = TextEditingController(text: minister?.name);
      _tagController = TextEditingController(text: minister?.tag);
      _positions = minister?.positions ?? [];
      _ministerTraits = {
        for (var item in minister?.traits ?? [])
          PositionExtension.getFromPrefix(item.substring(0, item.indexOf('_'))):
              item
      };
      _ideology = minister?.ideology ?? IdeologyKR.totalist;
    } on InvalidPrefixError {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_invalid_trait),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _onSave() {
    final tag = _tagController.text;

    final minister = Minister(
      name: _nameController.text,
      ideology: _ideology,
      tag: tag,
      positions: _positions,
      traits: _ministerTraits.values.toList(),
    );
    Provider.of<MinistersNotifier>(context, listen: false).put(minister);
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
            child: DropdownInputField<IdeologyKR>(
              selected: _ideology,
              items: IdeologyKR.values,
              labels: IdeologyKR.values
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
      if (_positions.isNotEmpty) ..._traits,
    ];
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
      body: SingleChildScrollView(
        child: Padding(
          padding: ThemeComponents.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _form,
          ),
        ),
      ),
    );
  }
}
