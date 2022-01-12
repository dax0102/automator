import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';
import 'package:hive/hive.dart';

part 'ideologies.g.dart';

@HiveType(typeId: 2)
enum Ideology {
  @HiveField(0)
  none,
  @HiveField(1)
  vanguardist,
  @HiveField(2)
  collectivist,
  @HiveField(3)
  libertarianSocialist,
  @HiveField(4)
  socialDemocrat,
  @HiveField(5)
  socialLiberal,
  @HiveField(6)
  marketLiberal,
  @HiveField(7)
  socialConservative,
  @HiveField(8)
  authoritarianDemocrat,
  @HiveField(9)
  paternalAutocrat,
  @HiveField(10)
  nationalPopulist,
  @HiveField(11)
  valkist
}

extension IdeologyExtension on Ideology {
  static const prefixNan = "";
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
  static const tokenNan = "";
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
      case Ideology.none:
        return prefixNan;
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
      case Ideology.none:
        return tokenNan;
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
      case Ideology.none:
        return Translations.of(context)!.ideology_none;
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

  static Ideology parseFromPrefix(String prefix) {
    switch (prefix) {
      case prefixVan:
        return Ideology.vanguardist;
      case prefixCol:
        return Ideology.collectivist;
      case prefixLib:
        return Ideology.libertarianSocialist;
      case prefixSde:
        return Ideology.socialDemocrat;
      case prefixSli:
        return Ideology.socialLiberal;
      case prefixMli:
        return Ideology.marketLiberal;
      case prefixSco:
        return Ideology.socialConservative;
      case prefixAde:
        return Ideology.authoritarianDemocrat;
      case prefixPau:
        return Ideology.paternalAutocrat;
      case prefixNpo:
        return Ideology.nationalPopulist;
      case prefixVal:
        return Ideology.valkist;
      default:
        return Ideology.none;
    }
  }

  static List<Ideology> get left {
    return [
      Ideology.vanguardist,
      Ideology.collectivist,
      Ideology.libertarianSocialist
    ];
  }

  static List<Ideology> get center {
    return [
      Ideology.socialDemocrat,
      Ideology.socialLiberal,
      Ideology.marketLiberal,
      Ideology.socialConservative
    ];
  }

  static List<Ideology> get right {
    return [
      Ideology.authoritarianDemocrat,
      Ideology.paternalAutocrat,
      Ideology.nationalPopulist,
      Ideology.valkist
    ];
  }

  bool get isLeft {
    return left.contains(this);
  }

  bool get isCenter {
    return center.contains(this);
  }

  bool get isRight {
    return right.contains(this);
  }
}

@HiveType(typeId: 4)
enum IdeologyKR {
  @HiveField(0)
  totalist,
  @HiveField(1)
  syndicalist,
  @HiveField(2)
  radicalSocialist,
  @HiveField(3)
  socialDemocrat,
  @HiveField(4)
  socialLiberal,
  @HiveField(5)
  marketLiberal,
  @HiveField(6)
  socialConservative,
  @HiveField(7)
  authoritarianDemocrat,
  @HiveField(8)
  paternalAutocrat,
  @HiveField(9)
  nationalPopulist,
}

extension IdeologyKRExtension on IdeologyKR {
  static const prefixNan = "";
  static const prefixTot = "tot";
  static const prefixSyn = "syn";
  static const prefixRso = "rso";
  static const prefixSde = "sde";
  static const prefixSli = "sli";
  static const prefixMli = "mli";
  static const prefixSco = "sco";
  static const prefixAde = "ade";
  static const prefixPau = "pau";
  static const prefixNpo = "npo";
  static const tokenNan = "";
  static const tokenTot = "totalist";
  static const tokenSyn = "syndicalist";
  static const tokenRso = "radical_socialist";
  static const tokenSde = "social_democrat";
  static const tokenSli = "social_liberal";
  static const tokenMli = "market_liberal";
  static const tokenSco = "social_conservative";
  static const tokenAde = "authoritarian_democrat";
  static const tokenPau = "paternal_autocrat";
  static const tokenNpo = "national_populist";

  String get prefix {
    switch (this) {
      case IdeologyKR.totalist:
        return prefixTot;
      case IdeologyKR.syndicalist:
        return prefixSyn;
      case IdeologyKR.radicalSocialist:
        return prefixRso;
      case IdeologyKR.socialDemocrat:
        return prefixSde;
      case IdeologyKR.socialLiberal:
        return prefixSli;
      case IdeologyKR.marketLiberal:
        return prefixMli;
      case IdeologyKR.socialConservative:
        return prefixSco;
      case IdeologyKR.authoritarianDemocrat:
        return prefixAde;
      case IdeologyKR.paternalAutocrat:
        return prefixPau;
      case IdeologyKR.nationalPopulist:
        return prefixNpo;
    }
  }

  String get token {
    switch (this) {
      case IdeologyKR.totalist:
        return tokenTot;
      case IdeologyKR.syndicalist:
        return tokenSyn;
      case IdeologyKR.radicalSocialist:
        return tokenRso;
      case IdeologyKR.socialDemocrat:
        return tokenSde;
      case IdeologyKR.socialLiberal:
        return tokenSli;
      case IdeologyKR.marketLiberal:
        return tokenMli;
      case IdeologyKR.socialConservative:
        return tokenSco;
      case IdeologyKR.authoritarianDemocrat:
        return tokenAde;
      case IdeologyKR.paternalAutocrat:
        return tokenPau;
      case IdeologyKR.nationalPopulist:
        return tokenNpo;
    }
  }

  String getLocalization(BuildContext context) {
    switch (this) {
      case IdeologyKR.totalist:
        return Translations.of(context)!.ideology_tot;
      case IdeologyKR.syndicalist:
        return Translations.of(context)!.ideology_syn;
      case IdeologyKR.radicalSocialist:
        return Translations.of(context)!.ideology_rso;
      case IdeologyKR.socialDemocrat:
        return Translations.of(context)!.ideology_sde;
      case IdeologyKR.socialLiberal:
        return Translations.of(context)!.ideology_sli;
      case IdeologyKR.marketLiberal:
        return Translations.of(context)!.ideology_mli;
      case IdeologyKR.socialConservative:
        return Translations.of(context)!.ideology_sco;
      case IdeologyKR.authoritarianDemocrat:
        return Translations.of(context)!.ideology_ade;
      case IdeologyKR.paternalAutocrat:
        return Translations.of(context)!.ideology_pau;
      case IdeologyKR.nationalPopulist:
        return Translations.of(context)!.ideology_npo;
    }
  }
}
