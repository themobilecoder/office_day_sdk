import 'package:equatable/equatable.dart';

class UserAuth extends Equatable {
  const UserAuth({
    required this.id,
    required this.accessToken,
    this.name,
    this.emailAddress,
  });

  final String id;
  final String accessToken;
  final String? name;
  final String? emailAddress;

  @override
  List<Object?> get props => [
        id,
        accessToken,
        name,
        emailAddress,
      ];
}
