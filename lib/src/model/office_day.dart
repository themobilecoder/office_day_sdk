import 'package:equatable/equatable.dart';

import 'office_status.dart';

class OfficeDay extends Equatable {
  const OfficeDay({
    required this.day,
    required this.status,
  });

  final DateTime day;
  final OfficeStatus status;

  @override
  List<Object?> get props => [day, status];
}
