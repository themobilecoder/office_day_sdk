// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_status_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
        break;
      case OfficeStatusHive.remote:
        writer.writeByte(1);
        break;
      case OfficeStatusHive.holiday:
        writer.writeByte(2);
        break;
      case OfficeStatusHive.sick:
        writer.writeByte(3);
        break;
      case OfficeStatusHive.none:
        writer.writeByte(4);
        break;
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
