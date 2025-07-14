import 'package:flex_ops_hr/features/profile/domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    required super.email,
    required super.phone,
    required super.address,
    required super.position,
    required super.startDate,
    required super.salary,
    required super.imageUrl,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      position: json['position'] ?? '',
      startDate: json['start_date'] ?? '',
      salary: json['salary'] ?? '',
      imageUrl: json['image'] ?? '',
    );
  }
}
