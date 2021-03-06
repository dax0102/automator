import 'dart:io';

import 'package:automator/core/position.dart';
import 'package:automator/core/reader.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/custom/state.dart';
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

  Future _onImport() async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final source = File(result.files.single.path!);
        final traits = await Traits.fetch(source);
        Provider.of<TraitsNotifier>(context, listen: false).change(traits);
      }
    } on RangeError {
      messenger.showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_invalid_file),
        ),
      );
    } on MissingContentError {
      messenger.showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_empty_file),
        ),
      );
    } on InvalidSourceError {
      messenger.showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedback_invalid_file),
        ),
      );
    }
  }

  Widget _getHeader(TraitsNotifier notifier) {
    final traits = notifier.traits;
    return Header(
      title: Translations.of(context)!.navigation_traits,
      actions: Header.getDefault(
        context,
        onImport: _onImport,
        onReset: traits.isNotEmpty ? notifier.reset : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TraitsNotifier>(builder: (context, notifier, _) {
      final traits = notifier.traits;

      return traits.isEmpty
          ? Padding(
              padding: ThemeComponents.defaultPadding,
              child: Column(
                children: [
                  _getHeader(notifier),
                  EmptyState(
                    title: Translations.of(context)!.state_empty_traits,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: ThemeComponents.defaultPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getHeader(notifier),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          selectedColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
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
                          selectedColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
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
                                itemCount: traits[position]?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      notifier.traits[position]![index],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: ThemeComponents.codeFont,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
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
