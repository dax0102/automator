import 'package:automator/settings/settings_notifier.dart';
import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future _onBrowsePrompt() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(Translations.of(context)!.dialog_browse_directory),
          content:
              Text(Translations.of(context)!.dialog_browse_directory_subtitle),
          actions: <Widget>[
            TextButton(
              child: Text(Translations.of(context)!.button_continue),
              onPressed: () {
                Navigator.pop(context, Future.value(true));
              },
            )
          ],
        );
      },
    );
  }

  Widget _getHeader(SettingsNotifier notifier) {
    return Header(title: Translations.of(context)!.navigation_settings);
  }

  Future _onBrowseDirectory() async {
    bool? response = await _onBrowsePrompt();

    if (response != null) {
      final preferences = Provider.of<SettingsNotifier>(context, listen: false);
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        preferences.setWorkspaceDirectory(directory);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Translations.of(context)!.feedback_workspace_directory_set,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(
      builder: (context, notifier, _) {
        return Padding(
          padding: ThemeComponents.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _getHeader(notifier),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      Translations.of(context)!.settings_workspace_directory,
                    ),
                    subtitle: Text(
                      Translations.of(context)!
                          .settings_workspace_directory_subtitle,
                    ),
                    trailing: IconButton(
                      onPressed: _onBrowseDirectory,
                      icon: const Icon(Icons.folder_outlined),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
