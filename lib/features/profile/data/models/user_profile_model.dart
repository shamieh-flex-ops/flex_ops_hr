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
      name: json['employee_name'] ?? '',
      email: json['employee_work_email'] ?? '',
      phone: json['employee_work_phone'] ?? '',
      address: json['employee_department']?['name'] ?? '',
      position: json['employee_job']?['name'] ?? '',
      startDate: json['contract_start_date'] ?? '',
      salary: json['basic_salary']?.toString() ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }}

