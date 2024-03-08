import 'package:office_day_sdk/src/model/user_auth_data.dart';

import '../model/office_day.dart';

abstract class OfficeDayRemoteDataSource {
  Future<bool> addOrUpdateOfficeDay(OfficeDay officeDay);
  Future<bool> addOrUpdateOfficeDays(List<OfficeDay> officeDays);
  Future<bool> deleteAll();
  Future<List<OfficeDay>> getOfficeDays();
  void setUser(UserAuth? userAuth);
  void signOut();
}
