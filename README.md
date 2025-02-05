# Office Day SDK

[![Office Day SDK Workflow](https://github.com/themobilecoder/office_day_sdk/actions/workflows/dart.yml/badge.svg)](https://github.com/themobilecoder/office_day_sdk/actions/workflows/dart.yml)

## Features

- Save the office days containing information on where you work.
- Uses `hive_ce` for local storage.

## Import to your project

Add this to your `pubspec.yaml` under `dependencies:` to use the latest released version.

```
  office_day_sdk:
    git:
      url: https://github.com/themobilecoder/office_day_sdk
      ref: 3.0.0
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:office_day_sdk/office_day_sdk.dart';

Future<void> main() async {
  //Initialize Flutter and Firebase
  WidgetsFlutterBinding.ensureInitialized();

  //Create officeDayRepo
  final OfficeDayRepo officeDayRepo = OfficeDayRepoImpl(
    officeDayLocalDataSource: HiveOfficeDayLocalDataSource(),
  );

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

This SDK uses `hive_ce` as the library for saving data locally. When updating `@Hive` objects, make sure to run:

```shell
dart run build_runner build --delete-conflicting-outputs
```

## Using the SDK in your project

For saving and reading `OfficeDay` objects, you can use the `OfficeDayRepo` interface. An implementation using `Hive` is provided when using the `OfficeDayRepoImpl` class.
