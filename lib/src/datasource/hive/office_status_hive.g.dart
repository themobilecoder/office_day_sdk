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
        return OfficeStatusHive.inOffice;
      case 1:
        return OfficeStatusHive.outOffice;
      case 2:
        return OfficeStatusHive.leave;
      case 3:
        return OfficeStatusHive.none;
      default:
        return OfficeStatusHive.inOffice;
    }
  }

  @override
  void write(BinaryWriter writer, OfficeStatusHive obj) {
    switch (obj) {
      case OfficeStatusHive.inOffice:
        writer.writeByte(0);
        break;
      case OfficeStatusHive.outOffice:
        writer.writeByte(1);
        break;
      case OfficeStatusHive.leave:
        writer.writeByte(2);
        break;
      case OfficeStatusHive.none:
        writer.writeByte(3);
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
