import 'package:hive_ce/hive.dart';

import 'office_day_hive.dart';
import 'office_status_hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters(
    [AdapterSpec<OfficeDayHive>(), AdapterSpec<OfficeStatusHive>()])
// Annotations must be on some element
// ignore: unused_element
void _() {}
