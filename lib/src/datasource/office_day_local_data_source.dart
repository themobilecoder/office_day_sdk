import '../model/office_day.dart';

abstract class OfficeDayLocalDataSource {
  Stream<List<OfficeDay>> get officeDaysStream;
  List<OfficeDay> get officeDays;
  bool addOrUpdate(OfficeDay officeDay);
  bool deleteAll();
  void addAllOrUpdateAll(List<OfficeDay> officeDays);
  Future<void> initialize();
}
