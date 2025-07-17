// lib/features/leaves/presentation/provider/leaves_request_provider.dart

import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart'; // For Either
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart'; // For NoParameters
import 'package:flex_ops_hr/core/utils/enums.dart'; // For AppRequesState
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/time_off_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/get_leave_types_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/request_leave_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/request_time_off_usecase.dart';

class LeavesRequestProvider extends ChangeNotifier {
  final GetLeaveTypesUseCase getLeaveTypesUseCase;
  final RequestTimeOffUseCase requestTimeOffUseCase;
  final RequestLeaveUseCase requestLeaveUseCase;

  LeavesRequestProvider({
    required this.getLeaveTypesUseCase,
    required this.requestTimeOffUseCase,
    required this.requestLeaveUseCase,
  });

  // --- States for Get Leave Types ---
  AppRequesState _getLeaveTypesState = AppRequesState.initial;

  AppRequesState get getLeaveTypesState => _getLeaveTypesState;

  List<LeaveTypeEntity> _leaveTypes = [];

  List<LeaveTypeEntity> get leaveTypes => _leaveTypes;

  String? _getLeaveTypesErrorMessage;

  String? get getLeaveTypesErrorMessage => _getLeaveTypesErrorMessage;

  // --- States for Request Time Off ---
  AppRequesState _requestTimeOffState = AppRequesState.initial;

  AppRequesState get requestTimeOffState => _requestTimeOffState;

  String? _requestTimeOffMessage; // Message from successful request or error
  String? get requestTimeOffMessage => _requestTimeOffMessage;

  // --- States for Request Leave ---
  AppRequesState _requestLeaveState = AppRequesState.initial;

  AppRequesState get requestLeaveState => _requestLeaveState;

  String? _requestLeaveMessage; // Message from successful request or error
  String? get requestLeaveMessage => _requestLeaveMessage;

  // --- Methods ---

  Future<void> fetchLeaveTypes() async {
    _getLeaveTypesState = AppRequesState.loading;
    _getLeaveTypesErrorMessage = null; // Clear previous error
    notifyListeners();

    final Either<Failure, List<LeaveTypeEntity>> result =
        await getLeaveTypesUseCase.call(const NoParameters());

    result.fold(
      (failure) {
        _getLeaveTypesState = AppRequesState.error;
        _getLeaveTypesErrorMessage = failure.message;
      },
      (data) {
        _getLeaveTypesState = AppRequesState.loaded;
        _leaveTypes = data;
      },
    );

    notifyListeners();
  }

  Future<void> submitTimeOffRequest(TimeOffRequestEntity request) async {
    _requestTimeOffState = AppRequesState.loading;
    _requestTimeOffMessage = null; // Clear previous message
    notifyListeners();

    final Either<Failure, bool> result =
        await requestTimeOffUseCase.call(request);

    result.fold(
      (failure) {
        _requestTimeOffState = AppRequesState.error;
        _requestTimeOffMessage = failure.message;
      },
      (success) {
        _requestTimeOffState = AppRequesState.loaded;
        _requestTimeOffMessage = success
            ? 'Time off request submitted successfully.'
            : 'Failed to submit time off request. Please try again.';
      },
    );

    notifyListeners();
  }

  Future<void> submitLeaveRequest(LeaveRequestEntity request) async {
    _requestLeaveState = AppRequesState.loading;
    _requestLeaveMessage = null; // Clear previous message
    notifyListeners();

    final Either<Failure, bool> result =
        await requestLeaveUseCase.call(request);

    result.fold(
      (failure) {
        _requestLeaveState = AppRequesState.error;
        _requestLeaveMessage = failure.message;
      },
      (success) {
        _requestLeaveState = AppRequesState.loaded;
        _requestLeaveMessage = success
            ? 'Leave request submitted successfully.'
            : 'Failed to submit leave request. Please try again.';
      },
    );

    notifyListeners();
  }

  // Method to reset the state of time off request after displaying message
  void resetRequestTimeOffState() {
    _requestTimeOffState = AppRequesState.initial;
    _requestTimeOffMessage = null;
    notifyListeners();
  }

  // Method to reset the state of leave request after displaying message
  void resetRequestLeaveState() {
    _requestLeaveState = AppRequesState.initial;
    _requestLeaveMessage = null;
    notifyListeners();
  }
}
