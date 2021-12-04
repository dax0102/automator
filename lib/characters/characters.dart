import 'package:automator/shared/custom/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({Key? key}) : super(key: key);

  @override
  _CharactersPageState createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: Translations.of(context)!.navigation_characters,
          actions: Header.getDefault(
            context,
            onAdd: () {},
            onEdit: () {},
            onRemove: () {},
          ),
        ),
      ],
    );
  }
}
