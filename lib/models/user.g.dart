// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatAdapter extends TypeAdapter<Stat> {
  @override
  final int typeId = 11;

  @override
  Stat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stat(name: fields[0] as StatName, value: fields[1] as int);
  }

  @override
  void write(BinaryWriter writer, Stat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CharacterAdapter extends TypeAdapter<Character> {
  @override
  final int typeId = 12;

  @override
  Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Character(
      name: fields[0] as String,
      edge: fields[1] as Stat,
      heart: fields[2] as Stat,
      iron: fields[3] as Stat,
      shadow: fields[4] as Stat,
      wits: fields[5] as Stat,
    );
  }

  @override
  void write(BinaryWriter writer, Character obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.edge)
      ..writeByte(2)
      ..write(obj.heart)
      ..writeByte(3)
      ..write(obj.iron)
      ..writeByte(4)
      ..write(obj.shadow)
      ..writeByte(5)
      ..write(obj.wits);
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

class StatNameAdapter extends TypeAdapter<StatName> {
  @override
  final int typeId = 10;

  @override
  StatName read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StatName.edge;
      case 1:
        return StatName.heart;
      case 2:
        return StatName.iron;
      case 3:
        return StatName.shadow;
      case 4:
        return StatName.wits;
      default:
        return StatName.edge;
    }
  }

  @override
  void write(BinaryWriter writer, StatName obj) {
    switch (obj) {
      case StatName.edge:
        writer.writeByte(0);
      case StatName.heart:
        writer.writeByte(1);
      case StatName.iron:
        writer.writeByte(2);
      case StatName.shadow:
        writer.writeByte(3);
      case StatName.wits:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
