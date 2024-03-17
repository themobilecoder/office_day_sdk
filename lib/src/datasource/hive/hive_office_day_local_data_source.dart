import 'dart:async';
import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/office_day.dart';
import '../../model/office_status.dart';
import '../office_day_local_data_source.dart';
import 'office_day_hive.dart';
import 'office_status_hive.dart';

class HiveOfficeDayLocalDataSource extends OfficeDayLocalDataSource {
  bool _isInitialized = false;
  late Box<OfficeDayHive> _box;

  final StreamController<List<OfficeDay>> _officeDaysStreamController =
      StreamController();

  @override
  Future<void> initialize() async {
    if (!_isInitialized) {
      final path = await getApplicationDocumentsDirectory();
      Hive.init(path.path);
      Hive.registerAdapter(OfficeDayHiveAdapter());
      Hive.registerAdapter(OfficeStatusHiveAdapter());

      _box = await Hive.openBox('officeDay');
      _isInitialized = true;
      _box.watch().listen(
        (_) {
          _officeDaysStreamController.add(_box.values
              .map(
                (e) => e.toOfficeDay(),
              )
              .toList());
        },
      );
    }
  }

  @override
  bool addOrUpdate(OfficeDay officeDay) {
    final day = officeDay.day;
    final key = '${day.year}-${day.month}-${day.day}';
    _box.put(key, officeDay.toOfficeDayHive());
    return true;
  }

  @override
  void addAllOrUpdateAll(List<OfficeDay> officeDays) {
    Map<String, OfficeDayHive> map = {};
    for (var officeDay in officeDays) {
      final day = officeDay.day;
      final key = '${day.year}-${day.month}-${day.day}';
      final officeDayHive = officeDay.toOfficeDayHive();
      map[key] = officeDayHive;
    }
    _box.putAll(map).onError((error, stackTrace) => log(stackTrace.toString()));
  }

  @override
  bool deleteAll() {
    final keys = _box.keys;
    _box.deleteAll(keys);
    return true;
  }

  @override
  Stream<List<OfficeDay>> get officeDaysStream {
    return _officeDaysStreamController.stream;
  }

  @override
  List<OfficeDay> get officeDays {
    return _box.values.map((e) => e.toOfficeDay()).toList();
  }
}

extension _OfficeDayConversion on OfficeDayHive {
  OfficeDay toOfficeDay() {
    return OfficeDay(
      day: day,
      status: status.toOfficeStatus(),
    );
  }
}

extension _OfficeDayHiveConversion on OfficeDay {
  OfficeDayHive toOfficeDayHive() {
    return OfficeDayHive()
      ..day = day
      ..status = status.toOfficeStatusHive();
  }
}

extension _OfficeStatusHiveConversion on OfficeStatus {
  OfficeStatusHive toOfficeStatusHive() {
    late OfficeStatusHive statusHive;
    switch (this) {
      case OfficeStatus.office:
        statusHive = OfficeStatusHive.office;
        break;
      case OfficeStatus.remote:
        statusHive = OfficeStatusHive.remote;
        break;
      case OfficeStatus.holiday:
        statusHive = OfficeStatusHive.holiday;
        break;
      case OfficeStatus.sick:
        statusHive = OfficeStatusHive.sick;
        break;
      case OfficeStatus.none:
        statusHive = OfficeStatusHive.none;
        break;
      default:
        break;
    }
    return statusHive;
  }
}

extension _OfficeStatusConversion on OfficeStatusHive {
  OfficeStatus toOfficeStatus() {
    late OfficeStatus statusHive;
    if (this == OfficeStatusHive.office) {
      statusHive = OfficeStatus.office;
    } else if (this == OfficeStatusHive.remote) {
      statusHive = OfficeStatus.remote;
    }
    if (this == OfficeStatusHive.holiday) {
      statusHive = OfficeStatus.holiday;
    }
    if (this == OfficeStatusHive.none) {
      statusHive = OfficeStatus.none;
    }
    return statusHive;
  }
}
