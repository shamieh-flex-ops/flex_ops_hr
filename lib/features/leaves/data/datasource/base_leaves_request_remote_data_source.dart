// lib/features/leaves/data/datasource/base_leaves_request_remote_data_source.dart

import 'package:flex_ops_hr/features/leaves/data/models/leave_type_model.dart';
import 'package:flex_ops_hr/features/leaves/data/models/time_off_request_model.dart';
import 'package:flex_ops_hr/features/leaves/data/models/leave_request_model.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';

abstract class BaseLeavesRequestRemoteDataSource {
  Future<bool> requestTimeOff(TimeOffRequestModel params);
  Future<bool> requestLeave(LeaveRequestModel params);
  Future<List<LeaveTypeModel>> getLeaveTypes();

  Future<List<LeaveStatusGroup>> getLeaveStatusGroups();
}