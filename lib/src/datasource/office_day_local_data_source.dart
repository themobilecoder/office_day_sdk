import '../model/office_day.dart';

/// An abstract class that defines the local data source for office days.
abstract class OfficeDayLocalDataSource {
  /// A stream that provides a list of office days.
  Stream<List<OfficeDay>> get officeDaysStream;

  /// A list of office days.
  List<OfficeDay> get officeDays;

  /// Adds or updates an office day.
  ///
  /// Returns `true` if the operation was successful, otherwise `false`.
  ///
  /// - Parameters:
  ///   - officeDay: The office day to add or update.
  bool addOrUpdate(OfficeDay officeDay);

  /// Deletes all office days.
  ///
  /// Returns `true` if the operation was successful, otherwise `false`.
  bool deleteAll();

  /// Adds or updates a list of office days.
  ///
  /// - Parameters:
  ///   - officeDays: The list of office days to add or update.
  void addAllOrUpdateAll(List<OfficeDay> officeDays);

  /// Initializes the data source.
  ///
  /// Returns a [Future] that completes when the initialization is done.
  Future<void> initialize();
}
