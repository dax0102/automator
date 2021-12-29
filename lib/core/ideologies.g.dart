// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ideologies.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdeologyAdapter extends TypeAdapter<Ideology> {
  @override
  final int typeId = 2;

  @override
  Ideology read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Ideology.none;
      case 1:
        return Ideology.vanguardist;
      case 2:
        return Ideology.collectivist;
      case 3:
        return Ideology.libertarianSocialist;
      case 4:
        return Ideology.socialDemocrat;
      case 5:
        return Ideology.socialLiberal;
      case 6:
        return Ideology.marketLiberal;
      case 7:
        return Ideology.socialConservative;
      case 8:
        return Ideology.authoritarianDemocrat;
      case 9:
        return Ideology.paternalAutocrat;
      case 10:
        return Ideology.nationalPopulist;
      case 11:
        return Ideology.valkist;
      default:
        return Ideology.none;
    }
  }

  @override
  void write(BinaryWriter writer, Ideology obj) {
    switch (obj) {
      case Ideology.none:
        writer.writeByte(0);
        break;
      case Ideology.vanguardist:
        writer.writeByte(1);
        break;
      case Ideology.collectivist:
        writer.writeByte(2);
        break;
      case Ideology.libertarianSocialist:
        writer.writeByte(3);
        break;
      case Ideology.socialDemocrat:
        writer.writeByte(4);
        break;
      case Ideology.socialLiberal:
        writer.writeByte(5);
        break;
      case Ideology.marketLiberal:
        writer.writeByte(6);
        break;
      case Ideology.socialConservative:
        writer.writeByte(7);
        break;
      case Ideology.authoritarianDemocrat:
        writer.writeByte(8);
        break;
      case Ideology.paternalAutocrat:
        writer.writeByte(9);
        break;
      case Ideology.nationalPopulist:
        writer.writeByte(10);
        break;
      case Ideology.valkist:
        writer.writeByte(11);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeologyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
