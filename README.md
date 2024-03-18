# Office Day SDK

## Features

- Save the office days containing information on where you work.
- Uses `hive` for local storage.
- Uses `Firebase Firestore` for remote storage.
- Can use `Google sign-in` or `anonymous` for authentication


## Import to your project

Add this to your `pubspec.yaml` under `dependencies:` to use the latest released version.

```
  office_day_sdk:
    git:
      url: https://github.com/themobilecoder/office_day_sdk
      ref: 2.1.0
```

## Example

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:office_day_sdk/office_day_sdk.dart';

Future<void> main() async {
  //Initialize Flutter and Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  //DefaultFirebaseOptions generated from `flutterfire configure`
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Create officeDayRepo
  final OfficeDayRepo officeDayRepo = OfficeDayRepoImpl(
    officeDayLocalDataSource: HiveOfficeDayLocalDataSource(),
    officeDayRemoteDataSource: FirebaseOfficeDayRemoteDataSource(),
  );

  //Set user
  final UserAuthRepo userAuthRepo = FirebaseUserAuthRepo();
  final userAuth = await userAuthRepo.signinAnonymously();
  officeDayRepo.setUser(userAuth);

  //Read office days
  List<OfficeDay> officeDays = officeDayRepo.officeDays;

  //Update office day
  await officeDayRepo.updateOfficeDay(
    OfficeDay(day: DateTime.now(), status: OfficeStatus.inOffice),
  );
}
```

## Building the SDK

### Local Database
This SDK uses `hive` as the library for saving data locally. When updating `@Hive` objects, make sure to run:

```shell
dart run build_runner build
```

## Using the SDK in your project

For saving and reading `OfficeDay` objects, you can use the `OfficeDayRepo` interface. An implementation using `Hive` and `Firebase` is provided when using the `OfficeDayRepoImpl` class.


### Firebase Remote Storage

**Setup**

The `FirebaseOfficeDayRemoteDataSource` uses `cloud_firestore` of `Firebase` to save the office days remotely. See `FirebaseOfficeDayRemoteDataSource` on how the documents are structured.

To use the `FirebaseOfficeDayRemoteDataSource`, you app needs to use the `firebase_core` package to initialise `Firebase`.

```
flutter pub add firebase_core
```

Make sure you have added `Firebase` options in your project. Add Firebase using `FlutterFire` and follow the configuration.

```
flutterfire configure
```

Once all the necessary Firebase-related files are configured, initialise `Firebase` at the entry point of your app (usually in `main.dart`) with:

```dart
Future<void> main() async{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
```

where `DefaultFirebaseOptions` is one of the generated files from `flutterfire confgure`.

**Setting up UserAuth for FirebaseOfficeDayRemoteDataSource**

In order to use `FirebaseOfficeDayRemoteDataSource`, a user profile is needed. You can use the provided `UserAuthRepo` interface to provide this data. The `FirebaseUserAuthRepo` contains the implementation of signing up and logging in to get a `UserAuth` data.

The `UserAuth` can be used to set the user in `FirebaseOfficeDayRemoteDataSource` through the `OfficeDayRepo`.

```dart
final userAuth = await userAuthRepo.signinAnonymously();
officeDayRepo.setUser(userAuth);
List<OfficeDay> officeDays = officeDayRepo.officeDays;
```

## Troubleshooting

### Installing on iOS

If you are getting errors with Fireabse when building the app regarding CocoaPods:

```
Error: CocoaPods's specs repository is too out-of-date to satisfy dependencies.
To update the CocoaPods specs, run:
  pod repo update

Error running pod install
Error launching application on iPhone 15 Pro.
```

then you might need to do the following:

1. `cd ios`
2. `pod repo update`
3. `pod install`
