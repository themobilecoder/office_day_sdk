import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:office_day_sdk/src/model/user_auth_data.dart';
import 'package:office_day_sdk/src/repo/user_auth_repo.dart';

class FirebaseUserAuthRepo extends UserAuthRepo {
  FirebaseUserAuthRepo();

  @override
  UserAuth? get currentUser {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return null;
    } else {
      return UserAuth(
        id: currentUser.uid,
        accessToken: '',
        emailAddress: currentUser.email,
        name: currentUser.displayName,
      );
    }
  }

  @override
  Future<bool> signOut() async {
    GoogleSignIn().signOut();
    return FirebaseAuth.instance.signOut().then((value) => true).onError(
      (error, stackTrace) {
        log('$error');
        return false;
      },
    );
  }

  @override
  Future<UserAuth> signinAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      return UserAuth(
        id: userCredential.user!.uid,
        accessToken: userCredential.credential?.accessToken ?? '',
      );
    } on Error catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserAuth?> signinWithGoogle() async {
    log("Signing in with Google");
    // Trigger the authentication flow
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await GoogleSignIn().signIn();
    } catch (e) {
      log(e.toString());
      return Future.value(null);
    }
    if (googleUser == null) {
      log('Google login flow cancelled');
      return Future.value(null);
    }

    try {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        log("Sign in with Google successful");
        return UserAuth(
          id: userCredential.user!.uid,
          accessToken: userCredential.credential?.accessToken ?? '',
          name: userCredential.user?.displayName,
          emailAddress: userCredential.user?.email,
        );
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return Future.value(null);
    }
  }

  @override
  Stream<UserAuth?> watchUserAuth() {
    return FirebaseAuth.instance.authStateChanges().map(
      (user) {
        if (user == null) {
          return null;
        } else {
          return UserAuth(
            id: user.uid,
            accessToken: '',
            name: user.displayName,
            emailAddress: user.email,
          );
        }
      },
    );
  }
}
