import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';
import 'package:flex_ops_hr/features/leaves/domain/usecases/get_leave_status_groups_usecase.dart';

class LeaveStatusProvider extends ChangeNotifier {
  final GetLeaveStatusGroupsUseCase getLeaveStatusGroupsUseCase;

  LeaveStatusProvider({required this.getLeaveStatusGroupsUseCase});

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  List<LeaveStatusGroup> _leaveStatusGroups = [];
  List<LeaveStatusGroup> get leaveStatusGroups => _leaveStatusGroups;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLeaveStatusGroups() async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, List<LeaveStatusGroup>> result =
    await getLeaveStatusGroupsUseCase.call(NoParameters());

    result.fold(
          (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
          (data) {
        _state = AppRequesState.loaded;
        _leaveStatusGroups = data;
      },
    );

    notifyListeners();
  }
}
