import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

enum Ideology {
  vanguardist,
  collectivist,
  libertarianSocialist,
  socialDemocrat,
  socialLiberal,
  marketLiberal,
  socialConservative,
  authoritarianDemocrat,
  paternalAutocrat,
  nationalPopulist,
  valkist
}

extension IdeologyExtension on Ideology {
  static const prefixVan = "van";
  static const prefixCol = "col";
  static const prefixLib = "lib";
  static const prefixSde = "sde";
  static const prefixSli = "sli";
  static const prefixMli = "mli";
  static const prefixSco = "sco";
  static const prefixAde = "ade";
  static const prefixPau = "pau";
  static const prefixNpo = "npo";
  static const prefixVal = "val";
  static const tokenVan = "vanguardist";
  static const tokenCol = "collectivist";
  static const tokenLib = "libertarian_socialist";
  static const tokenSde = "social_democrat";
  static const tokenSli = "social_liberal";
  static const tokenMli = "market_liberal";
  static const tokenSco = "social_conservative";
  static const tokenAde = "authoritarian_democrat";
  static const tokenPau = "paternal_autocrat";
  static const tokenNpo = "national_populist";
  static const tokenVal = "valkist";

  String get prefix {
    switch (this) {
      case Ideology.vanguardist:
        return prefixVan;
      case Ideology.collectivist:
        return prefixCol;
      case Ideology.libertarianSocialist:
        return prefixLib;
      case Ideology.socialDemocrat:
        return prefixSde;
      case Ideology.socialLiberal:
        return prefixSli;
      case Ideology.marketLiberal:
        return prefixMli;
      case Ideology.socialConservative:
        return prefixSco;
      case Ideology.authoritarianDemocrat:
        return prefixAde;
      case Ideology.paternalAutocrat:
        return prefixPau;
      case Ideology.nationalPopulist:
        return prefixNpo;
      case Ideology.valkist:
        return prefixVal;
    }
  }

  String get token {
    switch (this) {
      case Ideology.vanguardist:
        return tokenVan;
      case Ideology.collectivist:
        return tokenCol;
      case Ideology.libertarianSocialist:
        return tokenLib;
      case Ideology.socialDemocrat:
        return tokenSde;
      case Ideology.socialLiberal:
        return tokenSli;
      case Ideology.marketLiberal:
        return tokenMli;
      case Ideology.socialConservative:
        return tokenSco;
      case Ideology.authoritarianDemocrat:
        return tokenAde;
      case Ideology.paternalAutocrat:
        return tokenPau;
      case Ideology.nationalPopulist:
        return tokenNpo;
      case Ideology.valkist:
        return tokenVal;
    }
  }

  String getLocalization(BuildContext context) {
    switch (this) {
      case Ideology.vanguardist:
        return Translations.of(context)!.ideology_van;
      case Ideology.collectivist:
        return Translations.of(context)!.ideology_col;
      case Ideology.libertarianSocialist:
        return Translations.of(context)!.ideology_lib;
      case Ideology.socialDemocrat:
        return Translations.of(context)!.ideology_sde;
      case Ideology.socialLiberal:
        return Translations.of(context)!.ideology_sli;
      case Ideology.marketLiberal:
        return Translations.of(context)!.ideology_mli;
      case Ideology.socialConservative:
        return Translations.of(context)!.ideology_sco;
      case Ideology.authoritarianDemocrat:
        return Translations.of(context)!.ideology_ade;
      case Ideology.paternalAutocrat:
        return Translations.of(context)!.ideology_pau;
      case Ideology.nationalPopulist:
        return Translations.of(context)!.ideology_npo;
      case Ideology.valkist:
        return Translations.of(context)!.ideology_val;
    }
  }
}
