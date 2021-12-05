import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';

class CharacterImport extends StatefulWidget {
  const CharacterImport({
    Key? key,
    required this.tag,
    required this.names,
  }) : super(key: key);
  final String tag;
  final List<String> names;

  @override
  _CharacterImportState createState() => _CharacterImportState();
}

class _CharacterImportState extends State<CharacterImport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: ThemeComponents.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.tag),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.names.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(widget.names[index]),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
