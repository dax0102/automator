// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionAdapter extends TypeAdapter<Position> {
  @override
  final int typeId = 1;

  @override
  Position read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Position.headOfGovernment;
      case 1:
        return Position.foreignMinister;
      case 2:
        return Position.economyMinister;
      case 3:
        return Position.securityMinister;
      case 4:
        return Position.chiefOfStaff;
      case 5:
        return Position.chiefOfArmy;
      case 6:
        return Position.chiefOfNavy;
      case 7:
        return Position.chiefOfAirForce;
      default:
        return Position.headOfGovernment;
    }
  }

  @override
  void write(BinaryWriter writer, Position obj) {
    switch (obj) {
      case Position.headOfGovernment:
        writer.writeByte(0);
        break;
      case Position.foreignMinister:
        writer.writeByte(1);
        break;
      case Position.economyMinister:
        writer.writeByte(2);
        break;
      case Position.securityMinister:
        writer.writeByte(3);
        break;
      case Position.chiefOfStaff:
        writer.writeByte(4);
        break;
      case Position.chiefOfArmy:
        writer.writeByte(5);
        break;
      case Position.chiefOfNavy:
        writer.writeByte(6);
        break;
      case Position.chiefOfAirForce:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
