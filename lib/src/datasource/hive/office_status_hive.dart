import 'package:hive/hive.dart';

part 'office_status_hive.g.dart';

@HiveType(typeId: 1)
enum OfficeStatusHive {
  @HiveField(0)
  office,

  @HiveField(1)
  remote,

  @HiveField(2)
  holiday,

  @HiveField(3)
  sick,

  @HiveField(4)
  none,
}
