import 'package:automator/characters/characters_page.dart';
import 'package:automator/core/navigation.dart';
import 'package:automator/localization/locales.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/tags/tags_page.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:automator/traits/traits_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Automator());
}

class Automator extends StatelessWidget {
  const Automator({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TraitsNotifier()),
      ],
      child: MaterialApp(
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
      ),
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
        return const TraitsPage();
      case 2:
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
          child: SizedBox(child: page, height: double.infinity),
        )
      ],
    ));
  }
}
