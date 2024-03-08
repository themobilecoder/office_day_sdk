import 'package:office_day_sdk/src/model/user_auth_data.dart';

abstract class UserAuthRepo {
  UserAuth? get currentUser;
  Stream<UserAuth?> watchUserAuth();
  Future<UserAuth> signinAnonymously();
  Future<UserAuth?> signinWithGoogle();
  Future<bool> signOut();
}
