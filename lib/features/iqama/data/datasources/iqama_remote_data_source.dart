import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/iqama/data/models/iqama_renewal_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';

abstract class IqamaRemoteDataSource {
  Future<List<IqamaRenewalGroupModel>> getIqamaRenewalGroups();
}

class IqamaRemoteDataSourceImpl implements IqamaRemoteDataSource {
  final Dio dio;

  IqamaRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<IqamaRenewalGroupModel>> getIqamaRenewalGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.get(
        ApiConstance.getIqamaRenewals,
        options: Options(headers: {
          'token': token,
          'Content-Type': 'application/json',
        }),
      );

      final result = response.data['result'] as List;
      return result
          .map((e) => IqamaRenewalGroupModel.fromJson(e))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  ServerException _handleError(dynamic e) {
    if (e is DioError && e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data;
      final result = data['result'];
      final message = result is Map<String, dynamic> && result['error'] != null
          ? result['error']
          : 'Something went wrong with the server response.';

      return ServerException(
        messageModel: MessageModel(
          statusCode: e.response?.statusCode ?? 500,
          statusMessage: message,
          success: false,
        ),
      );
    } else {
      return const ServerException(
        messageModel: MessageModel(
          statusCode: 500,
          statusMessage: 'Unexpected error occurred.',
          success: false,
        ),
      );
    }
  }
}
