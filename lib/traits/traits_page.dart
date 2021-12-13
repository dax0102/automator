import 'dart:io';

import 'package:automator/characters/character.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/traits/traits.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class TraitsPage extends StatefulWidget {
  const TraitsPage({Key? key}) : super(key: key);

  @override
  _TraitsPageState createState() => _TraitsPageState();
}

class _TraitsPageState extends State<TraitsPage> {
  int _index = 0;

  List<Position> _getPosition() {
    return _index == 0
        ? PositionExtension.government
        : PositionExtension.military;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TraitsNotifier>(builder: (context, notifier, _) {
      return Padding(
        padding: ThemeComponents.defaultPadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                title: Translations.of(context)!.navigation_traits,
                actions: Header.getDefault(context, onImport: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    final source = File(result.files.single.path!);
                    final traits = await Traits.fetch(source);
                    notifier.change(traits);
                  }
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    selected: _index == 0,
                    label: Text(
                      Translations.of(context)!.position_type_government,
                      style: TextStyle(
                        color: _index == 0
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                      ),
                    ),
                    onSelected: (checked) {
                      setState(() => _index = 0);
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    selected: _index == 1,
                    label: Text(
                      Translations.of(context)!.position_type_military,
                      style: TextStyle(
                        color: _index == 1
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                      ),
                    ),
                    onSelected: (checked) {
                      setState(() => _index = 1);
                    },
                  )
                ],
              ),
              SizedBox(height: ThemeComponents.spacing),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getPosition().map((position) {
                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          position.getLocalization(context),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: ThemeComponents.spacing),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: notifier.traits[position]?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                notifier.traits[position]![index],
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => const Divider(),
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      );
    });
  }
}