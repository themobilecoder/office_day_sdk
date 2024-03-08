import 'package:hive/hive.dart';

import 'office_status_hive.dart';

part 'office_day_hive.g.dart';

@HiveType(typeId: 0)
class OfficeDayHive extends HiveObject {
  @HiveField(0)
  late DateTime day;

  @HiveField(1)
  late OfficeStatusHive status;
}
