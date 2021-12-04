import 'dart:io';

import 'package:automator/shared/custom/header.dart';
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
    return Column(
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
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 2),
            itemCount: _tags.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                child: Text(_tags[index]),
              );
            },
          ),
        )
      ],
    );
  }
}
