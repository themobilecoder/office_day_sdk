import '../datasource/office_day_local_data_source.dart';
import '../model/office_day.dart';

abstract class OfficeDayRepo {
  /// Adds or updates an [OfficeDay] in the repository.
  ///
  /// If the [OfficeDay] already exists, it will be updated with the new data.
  /// If it does not exist, it will be added to the repository.
  ///
  /// Returns a [Future] that completes with `true` if the operation was successful,
  /// or `false` otherwise.
  Future<bool> addOrUpdateOfficeDay(OfficeDay officeDay);

  /// Adds or updates a list of [OfficeDay] objects.
  ///
  /// This method takes a list of [OfficeDay] objects and either adds them
  /// to the repository or updates the existing entries if they already exist.
  ///
  /// Returns a [Future] that completes with `true` if the operation is
  /// successful, or `false` otherwise.
  ///
  /// [officeDays]: The list of [OfficeDay] objects to be added or updated.
  Future<bool> addOrUpdateOfficeDays(List<OfficeDay> officeDays);

  /// A stream that provides a list of [OfficeDay] objects.
  ///
  /// This stream can be used to listen for updates to the list of office days.
  /// Each event in the stream contains the current list of [OfficeDay] objects.
  Stream<List<OfficeDay>> get officeDaysStream;

  /// Retrieves a list of [OfficeDay] objects.
  List<OfficeDay> get officeDays;
}

class OfficeDayRepoImpl extends OfficeDayRepo {
  OfficeDayRepoImpl({required officeDayLocalDataSource})
      : _officeDayLocalDataSource = officeDayLocalDataSource;

  final OfficeDayLocalDataSource _officeDayLocalDataSource;

  @override
  List<OfficeDay> get officeDays {
    return _officeDayLocalDataSource.officeDays;
  }

  @override
  Stream<List<OfficeDay>> get officeDaysStream =>
      _officeDayLocalDataSource.officeDaysStream;

  @override
  Future<bool> addOrUpdateOfficeDay(OfficeDay officeDay) {
    final result = _officeDayLocalDataSource.addOrUpdate(officeDay);
    return Future.value(result);
  }

  @override
  Future<bool> addOrUpdateOfficeDays(List<OfficeDay> officeDays) {
    _officeDayLocalDataSource.addAllOrUpdateAll(officeDays);
    return Future.value(true);
  }
}
