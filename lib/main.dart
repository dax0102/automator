import 'package:automator/characters/characters_notifier.dart';
import 'package:automator/characters/characters_page.dart';
import 'package:automator/core/navigation.dart';
import 'package:automator/database/database.dart';
import 'package:automator/localization/locales.dart';
import 'package:automator/ministers/ministers_notifier.dart';
import 'package:automator/ministers/ministers_page.dart';
import 'package:automator/others/about_page.dart';
import 'package:automator/others/guides_page.dart';
import 'package:automator/settings/settings_notifier.dart';
import 'package:automator/settings/settings_page.dart';
import 'package:automator/shared/theme.dart';
import 'package:automator/traits/traits_notifier.dart';
import 'package:automator/traits/traits_page.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  await HiveDatabase.init();
  runApp(const Automator());
}

class Automator extends StatefulWidget {
  const Automator({Key? key}) : super(key: key);

  static const appName = "Automator";

  @override
  State<Automator> createState() => _AutomatorState();
}

class _AutomatorState extends State<Automator> {
  @override
  void initState() {
    super.initState();
    _initWindow();
  }

  void _initWindow() async {
    await DesktopWindow.setMinWindowSize(const Size(1000, 600));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TraitsNotifier()),
        ChangeNotifierProvider(create: (_) => CharactersNotifier()),
        ChangeNotifierProvider(create: (_) => MinistersNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsNotifier())
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
        return const MinistersPage();
      case 2:
        return const TraitsPage();
      case 3:
        return const SettingsPage();
      case 4:
        return const GuidesPage();
      case 5:
        return const AboutPage();
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
      ),
    );
  }
}
