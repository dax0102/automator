import 'package:automator/shared/custom/header.dart';
import 'package:automator/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ThemeComponents.defaultPadding,
        child: Column(
          children: [
            Header(
              title: Translations.of(context)!.navigation_about,
            ),
            Card(
              child: Padding(
                padding: ThemeComponents.defaultPadding,
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage('assets/appicon.png'),
                      width: 256,
                      height: 256,
                    ),
                    Text(
                      Translations.of(context)!.about_app_title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: ThemeComponents.spacing),
                    Text(
                      Translations.of(context)!.about_app_subtitle,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(Translations.of(context)!.about_author),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
