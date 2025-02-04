import 'dart:async';
import 'dart:developer';

import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../model/office_day.dart';
import '../../model/office_status.dart';
import '../office_day_local_data_source.dart';
import 'hive_adapters.dart';
import 'office_day_hive.dart';
import 'office_status_hive.dart';

class HiveOfficeDayLocalDataSource extends OfficeDayLocalDataSource {
  bool _isInitialized = false;
  late Box<OfficeDayHive> _box;

  final StreamController<List<OfficeDay>> _officeDaysStreamController =
      StreamController();

  /// Initializes the Hive database for storing office day data.
  ///
  /// This method sets up the Hive database by performing the following steps:
  /// 1. Checks if the database is already initialized.
  /// 2. Retrieves the application documents directory path.
  /// 3. Initializes Hive with the retrieved path.
  /// 4. Registers the [OfficeDayHiveAdapter] and [OfficeStatusHiveAdapter] adapters.
  /// 5. Opens a Hive box named 'officeDay'.
  /// 6. Sets the initialization flag to true.
  /// 7. Listens for changes in the Hive box and updates the [_officeDaysStreamController]
  ///    with the converted [OfficeDay] objects.
  ///
  /// This method is asynchronous and returns a [Future] that completes when the
  /// initialization is done.
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

  /// Adds or updates an [OfficeDay] entry in the Hive database.
  ///
  /// The [officeDay] parameter is the [OfficeDay] object to be added or updated.
  /// The method generates a unique key based on the date of the [officeDay]
  /// and stores the serialized [officeDay] object in the Hive box.
  ///
  /// Returns `true` upon successful addition or update.
  @override
  bool addOrUpdate(OfficeDay officeDay) {
    final day = officeDay.day;
    final key = '${day.year}-${day.month}-${day.day}';
    _box.put(key, officeDay.toOfficeDayHive());
    return true;
  }

  /// Adds or updates a list of [OfficeDay] objects in the local Hive database.
  ///
  /// This method converts each [OfficeDay] object to its corresponding
  /// [OfficeDayHive] representation and stores them in a map with keys
  /// formatted as 'year-month-day'. The map is then used to update the
  /// Hive box with the new or updated entries.
  ///
  /// If an error occurs during the operation, the error and stack trace
  /// are logged.
  ///
  /// [officeDays] - The list of [OfficeDay] objects to be added or updated.
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

  /// Deletes all entries from the Hive box.
  ///
  /// This method retrieves all the keys from the Hive box and deletes
  /// all the corresponding entries.
  ///
  /// Returns `true` upon successful deletion of all entries.
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

  /// Retrieves a list of [OfficeDay] objects from the Hive box.
  ///
  /// This getter maps the values stored in the Hive box to [OfficeDay] objects
  /// using the `toOfficeDay` method and returns them as a list.
  ///
  /// Returns:
  ///   A list of [OfficeDay] objects.
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
    return OfficeDayHive(
      day: day,
      status: status.toOfficeStatusHive(),
    );
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
    switch (this) {
      case OfficeStatusHive.office:
        return OfficeStatus.office;
      case OfficeStatusHive.remote:
        return OfficeStatus.remote;
      case OfficeStatusHive.holiday:
        return OfficeStatus.holiday;
      case OfficeStatusHive.sick:
        return OfficeStatus.sick;
      case OfficeStatusHive.none:
        return OfficeStatus.none;
      default:
        return OfficeStatus.none;
    }
  }
}
