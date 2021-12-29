import 'package:animations/animations.dart';
import 'package:automator/characters/character_editor.dart';
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
            onAdd: () async {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, _, __) => const CharacterEditor(),
                  transitionsBuilder: (context, animation, secondaryAnimation,
                          child) =>
                      SharedAxisTransition(
                          animation: animation,
                          secondaryAnimation: secondaryAnimation,
                          transitionType: SharedAxisTransitionType.horizontal,
                          child: child),
                ),
              );
            },
            onEdit: () {},
            onRemove: () {},
          ),
        ),
      ],
    );
  }
}
