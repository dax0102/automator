import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum Route { characters, traits, about }

extension RouteExtension on Route {
  static const characters = "characters";

  Widget get icon {
    switch (this) {
      case Route.characters:
        return const Icon(Icons.face_outlined);
      case Route.traits:
        return const Icon(Icons.military_tech_outlined);
      case Route.about:
        return const Icon(Icons.info_outline_rounded);
    }
  }

  Widget get selectedIcon {
    switch (this) {
      case Route.characters:
        return const Icon(Icons.face);
      case Route.traits:
        return const Icon(Icons.military_tech);
      case Route.about:
        return const Icon(Icons.info_rounded);
    }
  }

  String getLocalization(BuildContext context) {
    switch (this) {
      case Route.characters:
        return Translations.of(context)!.navigation_characters;
      case Route.traits:
        return Translations.of(context)!.navigation_traits;
      case Route.about:
        return Translations.of(context)!.navigation_about;
    }
  }
}

class Navigation extends StatelessWidget {
  const Navigation(
      {Key? key,
      required this.selectedIndex,
      required this.onDestinationChanged})
      : super(key: key);
  final int selectedIndex;
  final Function(int) onDestinationChanged;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: selectedIndex,
      destinations: Route.values.map((route) {
        return NavigationRailDestination(
          icon: route.icon,
          selectedIcon: route.selectedIcon,
          label: Text(
            route.getLocalization(context),
          ),
        );
      }).toList(),
      onDestinationSelected: onDestinationChanged,
      labelType: NavigationRailLabelType.selected,
    );
  }
}
