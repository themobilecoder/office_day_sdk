import 'package:hive/hive.dart';

part 'office_status_hive.g.dart';

@HiveType(typeId: 1)
enum OfficeStatusHive {
  @HiveField(0)
  inOffice,

  @HiveField(1)
  outOffice,

  @HiveField(2)
  leave,

  @HiveField(3)
  none,
}
