import 'package:hive_ce/hive.dart';

import 'office_status_hive.dart';

class OfficeDayHive extends HiveObject {
  OfficeDayHive({
    required this.day,
    required this.status,
  });

  final DateTime day;

  final OfficeStatusHive status;
}
