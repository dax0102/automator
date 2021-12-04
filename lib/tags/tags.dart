import 'package:automator/shared/custom/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: Translations.of(context)!.navigation_tags,
          actions: [
            ...Header.getDefault(
              context,
              onAdd: () {},
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_file_outlined),
              label: Text(Translations.of(context)!.button_import),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined),
              label: Text(Translations.of(context)!.button_export),
            )
          ],
        ),
      ],
    );
  }
}
