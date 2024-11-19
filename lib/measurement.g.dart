// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeasurementAdapter extends TypeAdapter<Measurement> {
  @override
  final int typeId = 0;

  @override
  Measurement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Measurement(
      shoeName: fields[0] as String,
      category: fields[1] as String,
      shoeSize: fields[2] as double,
      footLength: fields[3] as double,
      footWidthHeel: fields[4] as double,
      footWidthForefoot: fields[5] as double,
      toeBoxWidth: fields[6] as double?,
      archLength: fields[7] as double?,
      heelToToeDiagonal: fields[8] as double?,
      gender: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Measurement obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.shoeName)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.shoeSize)
      ..writeByte(3)
      ..write(obj.footLength)
      ..writeByte(4)
      ..write(obj.footWidthHeel)
      ..writeByte(5)
      ..write(obj.footWidthForefoot)
      ..writeByte(6)
      ..write(obj.toeBoxWidth)
      ..writeByte(7)
      ..write(obj.archLength)
      ..writeByte(8)
      ..write(obj.heelToToeDiagonal)
      ..writeByte(9)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
