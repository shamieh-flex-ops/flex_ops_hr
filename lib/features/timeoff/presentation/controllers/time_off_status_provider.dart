// lib/features/time_off/presentation/controller/time_off_status_provider.dart

import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/usecases/get_time_off_status_groups_usecase.dart';
import 'package:flex_ops_hr/features/timeoff/domain/usecases/get_available_leave_types_usecase.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';

class TimeOffStatusProvider extends ChangeNotifier {
  final GetTimeOffStatusGroupsUseCase getTimeOffStatusGroupsUseCase;
  final GetAvailableLeaveTypesUseCase
      getAvailableLeaveTypesUseCase;

  TimeOffStatusProvider({
    required this.getTimeOffStatusGroupsUseCase,
    required this.getAvailableLeaveTypesUseCase,
  });

  AppRequesState _state = AppRequesState.initial;

  AppRequesState get state => _state;

  List<TimeOffStatusGroupEntity> _timeOffStatusGroups = [];

  List<TimeOffStatusGroupEntity> get timeOffStatusGroups =>
      _timeOffStatusGroups;

  List<HolidayStatusIdEntity> _availableTimeOffTypes = [];

  List<HolidayStatusIdEntity> get availableTimeOffTypes =>
      _availableTimeOffTypes;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> fetchAvailableLeaveTypes() async {
    print('TimeOffStatusProvider: fetchAvailableLeaveTypes started');
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, List<HolidayStatusIdEntity>> result =
        await getAvailableLeaveTypesUseCase.call(NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
        print(
            'TimeOffStatusProvider: Error fetching available leave types: ${_errorMessage}');
      },
      (data) {
        _availableTimeOffTypes = data;
        _state = AppRequesState
            .loaded;
        print(
            'TimeOffStatusProvider: Successfully fetched available leave types. Count: ${data.length}');
        for (var type in _availableTimeOffTypes) {
          print('  - Fetched Available Type: ${type.name} (ID: ${type.id})');
        }
      },
    );
    notifyListeners();
  }

  Future<void> fetchTimeOffStatusGroupsAndTypes() async {
    print('TimeOffStatusProvider: fetchTimeOffStatusGroupsAndTypes started');
    _state = AppRequesState.loading;
    notifyListeners();
    print('TimeOffStatusProvider: State set to loading');

    final Either<Failure, List<TimeOffStatusGroupEntity>> result =
        await getTimeOffStatusGroupsUseCase.call(NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
        print(
            'TimeOffStatusProvider: Error State: ${_errorMessage}');
      },
      (data) {
        _state = AppRequesState.loaded;
        _timeOffStatusGroups = data;

        final Set<HolidayStatusIdEntity> uniqueTypes = {};
        for (var group in data) {
          for (var timeOff in group.leaves) {
            uniqueTypes.add(timeOff.holidayStatusId);
          }
        }
        _availableTimeOffTypes = uniqueTypes.toList();
        print(
            'TimeOffStatusProvider: Loaded State. Number of groups: ${_timeOffStatusGroups.length}');
        print(
            'TimeOffStatusProvider: Number of unique types: ${_availableTimeOffTypes.length}');
        for (var type in _availableTimeOffTypes) {
          print(
              '  - Available Type from groups: ${type.name} (ID: ${type.id})');
        }
      },
    );

    notifyListeners();
    print(
        'TimeOffStatusProvider: notifyListeners called');
  }
}
