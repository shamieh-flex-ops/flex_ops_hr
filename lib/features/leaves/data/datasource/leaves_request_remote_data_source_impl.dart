// lib/features/leaves/data/datasource/leaves_request_remote_data_source_impl.dart

import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flex_ops_hr/features/leaves/data/datasource/base_leaves_request_remote_data_source.dart';
import 'package:flex_ops_hr/features/leaves/data/models/leave_type_model.dart';
import 'package:flex_ops_hr/features/leaves/data/models/time_off_request_model.dart';
import 'package:flex_ops_hr/features/leaves/data/models/leave_request_model.dart';
// ✅ تأكد من استيراد LeaveStatusGroupModel هنا
import 'package:flex_ops_hr/features/leaves/data/models/leave_status_group_model.dart';

class LeavesRequestRemoteDataSourceImpl
    implements BaseLeavesRequestRemoteDataSource {
  final Dio dio;

  LeavesRequestRemoteDataSourceImpl(this.dio);

  // دالة مساعدة لمعالجة الأخطاء
  ServerException _handleError(dynamic e) {
    if (e is DioException && e.response?.data is Map<String, dynamic>) {
      final messageModel = MessageModel.fromJson(e.response!.data);
      return ServerException(messageModel: messageModel);
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

  @override
  Future<bool> requestTimeOff(TimeOffRequestModel params) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.post(
        ApiConstance.createTimeOff, // يُفترض أنه الرابط الصحيح لإنشاء طلب وقت إضافي
        data: params.toJson(),
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data['success'] ?? false;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<bool> requestLeave(LeaveRequestModel params) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // ⚠️ مراجعة مهمة: هل هذا هو الرابط الصحيح لـ "طلب إجازة"؟
      // إذا كان لديك رابط API مختلف لإنشاء طلب إجازة عن طلب الوقت الإضافي،
      // يجب تحديث ApiConstance واستخدامه هنا (مثلاً: ApiConstance.createLeave).
      final response = await dio.post(
        ApiConstance.createTimeOff, // افتراضياً يستخدم نفس رابط الوقت الإضافي
        data: params.toJson(),
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data['success'] ?? false;
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');


      final response = await dio.get(
        ApiConstance.createTimeOff,
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      final result = response.data['result'] as List;
      return result.map((e) => LeaveTypeModel.fromJson(e)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<LeaveStatusGroup>> getLeaveStatusGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.get(
        ApiConstance.leaveState,
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Leave Status API Response: ${response.data}');

      if (response.statusCode == 200) {

        final List<dynamic> jsonList = response.data['result'] as List;

        return jsonList
            .map((json) => LeaveStatusGroupModel.fromJson(json))
            .toList();
      } else {
        throw ServerException(
            messageModel: MessageModel.fromJson(response.data));
      }
    } catch (e) {
      throw _handleError(e);
    }
  }
}