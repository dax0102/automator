import 'package:automator/characters/characters.dart';
import 'package:automator/core/navigation.dart';
import 'package:automator/localization/locales.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/tags/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const Automator());
}

class Automator extends StatelessWidget {
  const Automator({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: dark,
      home: const MainPage(),
      supportedLocales: Locales.all,
      localizationsDelegates: const [
        Translations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      onGenerateTitle: (context) => Translations.of(context)!.app_name,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  Widget get page {
    switch (_index) {
      case 0:
        return const CharactersPage();
      case 1:
        return const TagsPage();
      default:
        throw Exception("Invalid Route");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Navigation(
          selectedIndex: _index,
          onDestinationChanged: (index) {
            setState(() => _index = index);
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: page,
          ),
        )
      ],
    ));
  }
}
