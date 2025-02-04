import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:office_day_sdk/office_day_sdk.dart';

import 'office_day_repo_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OfficeDayLocalDataSource>()])
void main() {
  late OfficeDayRepoImpl officeDayRepo;
  late OfficeDayLocalDataSource mockOfficeDayLocalDataSource;

  setUp(() {
    mockOfficeDayLocalDataSource = MockOfficeDayLocalDataSource();
    officeDayRepo = OfficeDayRepoImpl(
      officeDayLocalDataSource: mockOfficeDayLocalDataSource,
    );
  });

  group('OfficeDayRepoImpl', () {
    test('should return officeDays from local data source', () {
      // Arrange
      final officeDays = [
        OfficeDay(day: DateTime(2023, 1, 1), status: OfficeStatus.office),
        OfficeDay(day: DateTime(2023, 1, 2), status: OfficeStatus.sick)
      ];
      when(mockOfficeDayLocalDataSource.officeDays).thenReturn(officeDays);

      // Act
      final result = officeDayRepo.officeDays;

      // Assert
      expect(result, officeDays);
      verify(mockOfficeDayLocalDataSource.officeDays).called(1);
    });

    test('should add an office day', () async {
      // Arrange
      final officeDay = OfficeDay(
        day: DateTime(2023, 1, 1),
        status: OfficeStatus.office,
      );
      when(mockOfficeDayLocalDataSource.addOrUpdate(officeDay))
          .thenReturn(true);

      // Act
      final result = await officeDayRepo.addOrUpdateOfficeDay(officeDay);

      // Assert
      expect(result, true);
      verify(mockOfficeDayLocalDataSource.addOrUpdate(officeDay)).called(1);
    });

    test('should add multiple office days', () async {
      // Arrange
      final officeDays = [
        OfficeDay(day: DateTime(2023, 1, 1), status: OfficeStatus.office),
        OfficeDay(day: DateTime(2023, 1, 2), status: OfficeStatus.sick)
      ];
      when(mockOfficeDayLocalDataSource.addAllOrUpdateAll(officeDays));

      // Act
      final result = await officeDayRepo.addOrUpdateOfficeDays(officeDays);

      // Assert
      expect(result, true);
      verify(mockOfficeDayLocalDataSource.addAllOrUpdateAll(officeDays))
          .called(1);
    });
  });
}
