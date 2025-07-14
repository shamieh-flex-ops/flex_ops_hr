import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/features/profile/data/models/user_profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfileModel> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await dio.get(
      ApiConstance.profile,
      options: Options(
        headers: {
          'token': token,
        },
      ),
    );
print("--------------------------------");
    print(response.data['result']);
    return UserProfileModel.fromJson(response.data['result']);
  }
}
