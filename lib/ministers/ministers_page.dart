import 'package:animations/animations.dart';
import 'package:automator/core/position.dart';
import 'package:automator/core/writer.dart';
import 'package:automator/ministers/minister.dart';
import 'package:automator/ministers/minister_editor.dart';
import 'package:automator/ministers/ministers_notifier.dart';
import 'package:automator/ministers/ministers_table.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class MinistersPage extends StatefulWidget {
  const MinistersPage({Key? key}) : super(key: key);

  @override
  _MinistersPageState createState() => _MinistersPageState();
}

class _MinistersPageState extends State<MinistersPage> {
  void _onAdd() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => const MinisterEditor(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  void _onEdit(Minister minister) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, _, __) => MinisterEditor(
          minister: minister,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
      ),
    );
  }

  void _onRemove(Minister minister) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_remove_character),
          content:
              Text(Translations.of(context)!.dialog_remove_character_subtitle),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_remove),
              onPressed: () {
                Provider.of<MinistersNotifier>(context, listen: false)
                    .remove(minister);
                Navigator.pop(context);
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

  void _onExport() async {
    final List<Minister> raw =
        Provider.of<MinistersNotifier>(context, listen: false).ministers;
    Map<Position, List<Minister>> ministers = {};
    for (Position position in Position.values) {
      ministers[position] = [];
      for (Minister minister in raw) {
        if (minister.positions.contains(position)) {
          final items = ministers[position] ?? [];
          ministers[position] = [minister, ...items];
        }
      }
    }
    if (raw.isNotEmpty) {
      String? core = await FilePicker.platform.saveFile(
        fileName: 'ministers.txt',
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );
      if (core != null) {
        await Writer.saveMinistersCore(core, ministers);
      }

      String? localization = await FilePicker.platform.saveFile(
        fileName: 'localization.yml',
        type: FileType.custom,
        allowedExtensions: ['yml'],
      );
      if (localization != null) {
        await Writer.saveMinistersLoc(localization, ministers);
      }

      String? gfx = await FilePicker.platform.saveFile(
        fileName: 'ministers.gfx',
        type: FileType.custom,
        allowedExtensions: ['gfx'],
      );
      if (gfx != null) {
        await Writer.saveMinistersGFX(gfx, ministers);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Translations.of(context)!.feedbacK_empty_output),
        ),
      );
    }
  }

  Widget _getHeader(MinistersNotifier notifier) {
    final ministers = notifier.ministers;
    return Header(
      title: Translations.of(context)!.navigation_ministers,
      actions: Header.getDefault(
        context,
        onAdd: _onAdd,
        onImport: () {},
        onExport: _onExport,
        onReset: ministers.isNotEmpty ? notifier.reset : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MinistersNotifier>(builder: (context, notifier, _) {
      final ministers = notifier.ministers;
      return ministers.isEmpty
          ? Padding(
              padding: ThemeComponents.defaultPadding,
              child: Column(
                children: [
                  _getHeader(notifier),
                ],
              ))
          : SingleChildScrollView(
              child: Padding(
                padding: ThemeComponents.defaultPadding,
                child: Column(
                  children: [
                    _getHeader(notifier),
                    MinistersTable(
                        ministers: ministers,
                        onEdit: _onEdit,
                        onRemove: _onRemove)
                  ],
                ),
              ),
            );
    });
  }
}
