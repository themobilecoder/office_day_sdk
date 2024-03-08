// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_day_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfficeDayHiveAdapter extends TypeAdapter<OfficeDayHive> {
  @override
  final int typeId = 0;

  @override
  OfficeDayHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfficeDayHive()
      ..day = fields[0] as DateTime
      ..status = fields[1] as OfficeStatusHive;
  }

  @override
  void write(BinaryWriter writer, OfficeDayHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfficeDayHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
