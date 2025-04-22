// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackDataAdapter extends TypeAdapter<TrackData> {
  @override
  final int typeId = 100;

  @override
  TrackData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackData(
      label: fields[0] as String,
      min: fields[1] as int,
      current: fields[2] as int,
      max: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TrackData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.min)
      ..writeByte(2)
      ..write(obj.current)
      ..writeByte(3)
      ..write(obj.max);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
