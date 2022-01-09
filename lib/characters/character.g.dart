// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 0;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      name: fields[0] as String,
      tag: fields[1] as String,
      ideology: fields[2] as Ideology,
      positions: (fields[3] as List).cast<Position>(),
      leaderTraits: (fields[4] as List).cast<String>(),
      commanderLandTraits: (fields[5] as List).cast<String>(),
      commanderSeaTraits: (fields[6] as List).cast<String>(),
      ministerTraits: (fields[7] as List).cast<String>(),
      headOfState: fields[8] as bool,
      fieldMarshal: fields[9] as bool,
      corpCommander: fields[10] as bool,
      admiral: fields[11] as bool,
      civilianPortrait: fields[12] as bool,
      armyPortrait: fields[13] as bool,
      navyPortrait: fields[14] as bool,
      skills: fields[15] as String?,
      civilianLargePortrait: fields[16] as String?,
      civilianSmallPortrait: fields[17] as String?,
      armyLargePortrait: fields[18] as String?,
      armySmallPortait: fields[19] as String?,
      navyLargePortrait: fields[20] as String?,
      navySmallPortrait: fields[21] as String?,
      cost: fields[22] as int,
      spanLeftistIdeologies: fields[23] as bool?,
      spanCentristIdeologies: fields[24] as bool?,
      spanRightistIdeologies: fields[25] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tag)
      ..writeByte(2)
      ..write(obj.ideology)
      ..writeByte(3)
      ..write(obj.positions)
      ..writeByte(4)
      ..write(obj.leaderTraits)
      ..writeByte(5)
      ..write(obj.commanderLandTraits)
      ..writeByte(6)
      ..write(obj.commanderSeaTraits)
      ..writeByte(7)
      ..write(obj.ministerTraits)
      ..writeByte(8)
      ..write(obj.headOfState)
      ..writeByte(9)
      ..write(obj.fieldMarshal)
      ..writeByte(10)
      ..write(obj.corpCommander)
      ..writeByte(11)
      ..write(obj.admiral)
      ..writeByte(12)
      ..write(obj.civilianPortrait)
      ..writeByte(13)
      ..write(obj.armyPortrait)
      ..writeByte(14)
      ..write(obj.navyPortrait)
      ..writeByte(15)
      ..write(obj.skills)
      ..writeByte(16)
      ..write(obj.civilianLargePortrait)
      ..writeByte(17)
      ..write(obj.civilianSmallPortrait)
      ..writeByte(18)
      ..write(obj.armyLargePortrait)
      ..writeByte(19)
      ..write(obj.armySmallPortait)
      ..writeByte(20)
      ..write(obj.navyLargePortrait)
      ..writeByte(21)
      ..write(obj.navySmallPortrait)
      ..writeByte(22)
      ..write(obj.cost)
      ..writeByte(23)
      ..write(obj.spanLeftistIdeologies)
      ..writeByte(24)
      ..write(obj.spanCentristIdeologies)
      ..writeByte(25)
      ..write(obj.spanRightistIdeologies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
