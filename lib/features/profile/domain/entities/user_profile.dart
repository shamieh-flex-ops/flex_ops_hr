import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String position;
  final String startDate;
  final String salary;
  final String imageUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.position,
    required this.startDate,
    required this.salary,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        address,
        position,
        startDate,
        salary,
        imageUrl,
      ];

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? position,
    String? startDate,
    String? salary,
    String? imageUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      salary: salary ?? this.salary,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
