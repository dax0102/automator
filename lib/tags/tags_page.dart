import 'dart:io';

import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/tags/tags.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({Key? key}) : super(key: key);

  @override
  _TagsPageState createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  List<String> _tags = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeComponents.defaultPadding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              title: Translations.of(context)!.navigation_tags,
              actions: Header.getDefault(
                context,
                onAdd: () {},
                onImport: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    final file = File(result.files.single.path!);
                    final tags = await Tag.getTags(file);
                    setState(() => _tags = tags);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
