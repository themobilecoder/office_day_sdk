import 'dart:developer';

import '../datasource/office_day_local_data_source.dart';
import '../datasource/office_day_remote_data_source.dart';
import '../model/office_day.dart';
import '../model/user_auth_data.dart';

abstract class OfficeDayRepo {
  Future<bool> updateOfficeDay(OfficeDay officeDay);
  Future<bool> updateOfficeDays(List<OfficeDay> officeDays);
  Stream<List<OfficeDay>> get officeDaysStream;
  List<OfficeDay> get officeDays;
  bool setUser(UserAuth? userAuth);
}

class OfficeDayRepoImpl extends OfficeDayRepo {
  OfficeDayRepoImpl({
    required officeDayLocalDataSource,
    required officeDayRemoteDataSource,
  })  : _officeDayLocalDataSource = officeDayLocalDataSource,
        _officeDayRemoteDataSource = officeDayRemoteDataSource;

  final OfficeDayLocalDataSource _officeDayLocalDataSource;
  final OfficeDayRemoteDataSource _officeDayRemoteDataSource;

  @override
  List<OfficeDay> get officeDays {
    _officeDayRemoteDataSource.getOfficeDays().then((value) {
      _officeDayLocalDataSource.addAllOrUpdateAll(value);
    });
    return _officeDayLocalDataSource.officeDays;
  }

  @override
  Stream<List<OfficeDay>> get officeDaysStream =>
      _officeDayLocalDataSource.officeDaysStream;

  @override
  Future<bool> updateOfficeDay(OfficeDay officeDay) {
    final result = _officeDayLocalDataSource.addOrUpdate(officeDay);
    _officeDayRemoteDataSource.addOrUpdateOfficeDay(officeDay).onError(
      (error, stackTrace) {
        log("Error updating office day remotely");
        return false;
      },
    );
    return Future.value(result);
  }

  @override
  Future<bool> updateOfficeDays(List<OfficeDay> officeDays) {
    _officeDayLocalDataSource.addAllOrUpdateAll(officeDays);
    _officeDayRemoteDataSource.addOrUpdateOfficeDays(officeDays).onError(
      (error, stackTrace) {
        log("Error updating office days remotely");
        return false;
      },
    );
    return Future.value(true);
  }

  @override
  bool setUser(UserAuth? userAuth) {
    _officeDayRemoteDataSource.setUser(userAuth);
    return true;
  }
}
