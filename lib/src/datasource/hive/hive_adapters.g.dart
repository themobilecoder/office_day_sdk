// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
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
    return OfficeDayHive(
      day: fields[0] as DateTime,
      status: fields[1] as OfficeStatusHive,
    );
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

class OfficeStatusHiveAdapter extends TypeAdapter<OfficeStatusHive> {
  @override
  final int typeId = 1;

  @override
  OfficeStatusHive read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OfficeStatusHive.office;
      case 1:
        return OfficeStatusHive.remote;
      case 2:
        return OfficeStatusHive.holiday;
      case 3:
        return OfficeStatusHive.sick;
      case 4:
        return OfficeStatusHive.none;
      default:
        return OfficeStatusHive.office;
    }
  }

  @override
  void write(BinaryWriter writer, OfficeStatusHive obj) {
    switch (obj) {
      case OfficeStatusHive.office:
        writer.writeByte(0);
      case OfficeStatusHive.remote:
        writer.writeByte(1);
      case OfficeStatusHive.holiday:
        writer.writeByte(2);
      case OfficeStatusHive.sick:
        writer.writeByte(3);
      case OfficeStatusHive.none:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfficeStatusHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
