import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../model/office_day.dart';
import '../../model/office_status.dart';
import '../../model/user_auth_data.dart';
import '../office_day_remote_data_source.dart';

class FirebaseOfficeDayRemoteDataSource extends OfficeDayRemoteDataSource {
  UserAuth? _userAuth;

  @override
  Future<List<OfficeDay>> getOfficeDays() async {
    if (_userAuth == null) {
      log("Cannot get office days remotely. User is not logged in");
      return Future.value([]);
    }
    List<OfficeDay> officeDays = [];
    final querySnapshot = await FirebaseFirestore.instance
        .officeDaysDirectory(_userAuth!.id)
        .get();
    for (var docSnapshot in querySnapshot.docs) {
      final date = docSnapshot.data()['day'];
      final status = docSnapshot.data()['status'];
      officeDays.add(_toOfficeDay(date, status));
    }
    return Future.value(officeDays);
  }

  @override
  Future<bool> addOrUpdateOfficeDay(OfficeDay officeDay) {
    if (_userAuth == null) {
      log("Update remote failed. User not logged in");
      return Future.value(false);
    }

    final year = officeDay.day.year;
    final month = officeDay.day.month;
    final day = officeDay.day.day;
    final status = officeDay.status.name;
    final data = {
      'day': '$year-$month-$day',
      'status': status,
    };

    try {
      return FirebaseFirestore.instance
          .officeDaysDirectory(_userAuth!.id)
          .doc('$year-$month-$day')
          .set(data)
          .then((value) => true);
    } on Error catch (e) {
      log(e.toString());
      return Future.value(false);
    }
  }

  @override
  Future<bool> addOrUpdateOfficeDays(List<OfficeDay> officeDays) {
    if (_userAuth == null) {
      log("Update remote failed. User not logged in");
      return Future.value(false);
    }
    for (var officeDay in officeDays) {
      final year = officeDay.day.year;
      final month = officeDay.day.month;
      final day = officeDay.day.day;
      final status = officeDay.status.name;
      final data = {
        'day': '$year-$month-$day',
        'status': status,
      };

      try {
        FirebaseFirestore.instance
            .officeDaysDirectory(_userAuth!.id)
            .doc('$year-$month-$day')
            .set(data);
      } on Error catch (e) {
        log(e.toString());
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  @override
  Future<bool> deleteAll() async {
    if (_userAuth == null) {
      log("Delete all remote failed. User not logged in");
      return Future.value(false);
    }
    final snapshots = await FirebaseFirestore.instance
        .officeDaysDirectory(_userAuth!.id)
        .get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    return Future.value(true);
  }

  @override
  void setUser(UserAuth? userAuth) {
    _userAuth = userAuth;
  }

  @override
  void signOut() {
    _userAuth = null;
  }

  OfficeDay _toOfficeDay(String yearMonthDay, String status) {
    OfficeStatus statusEnum;
    final statusLowerCase = status.toLowerCase();
    if (statusLowerCase == OfficeStatus.inOffice.name.toLowerCase()) {
      statusEnum = OfficeStatus.inOffice;
    } else if (statusLowerCase == OfficeStatus.outOffice.name.toLowerCase()) {
      statusEnum = OfficeStatus.outOffice;
    } else if (statusLowerCase == OfficeStatus.leave.name.toLowerCase()) {
      statusEnum = OfficeStatus.leave;
    } else {
      statusEnum = OfficeStatus.none;
    }
    return OfficeDay(
      day: yearMonthDay.toDateTimeFromYearMonthDay(),
      status: statusEnum,
    );
  }
}

extension _OfficeDayFirestoreUtils on FirebaseFirestore {
  CollectionReference<Map<String, dynamic>> officeDaysDirectory(String uid) {
    return collection("officeids").doc(uid).collection('officedays');
  }
}

extension _DateFormatFunctions on String {
  DateTime toDateTimeFromYearMonthDay() {
    return DateFormat('y-M-d').parse(this);
  }
}
