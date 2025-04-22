// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 1;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      name: fields[0] as String,
      rank: fields[1] as QuestRank,
      progress: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.rank)
      ..writeByte(2)
      ..write(obj.progress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestRankAdapter extends TypeAdapter<QuestRank> {
  @override
  final int typeId = 0;

  @override
  QuestRank read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestRank.troublesome;
      case 1:
        return QuestRank.dangerous;
      case 2:
        return QuestRank.formidable;
      case 3:
        return QuestRank.extreme;
      case 4:
        return QuestRank.epic;
      default:
        return QuestRank.troublesome;
    }
  }

  @override
  void write(BinaryWriter writer, QuestRank obj) {
    switch (obj) {
      case QuestRank.troublesome:
        writer.writeByte(0);
      case QuestRank.dangerous:
        writer.writeByte(1);
      case QuestRank.formidable:
        writer.writeByte(2);
      case QuestRank.extreme:
        writer.writeByte(3);
      case QuestRank.epic:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestRankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
