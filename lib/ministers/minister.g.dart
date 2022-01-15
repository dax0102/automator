// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minister.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MinisterAdapter extends TypeAdapter<Minister> {
  @override
  final int typeId = 3;

  @override
  Minister read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Minister(
      name: fields[0] as String,
      tag: fields[1] as String,
      ideology: fields[2] as IdeologyKR,
      positions: (fields[3] as List).cast<Position>(),
      traits: (fields[4] as List).cast<String>(),
      id: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Minister obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tag)
      ..writeByte(2)
      ..write(obj.ideology)
      ..writeByte(3)
      ..write(obj.positions)
      ..writeByte(4)
      ..write(obj.traits)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinisterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
