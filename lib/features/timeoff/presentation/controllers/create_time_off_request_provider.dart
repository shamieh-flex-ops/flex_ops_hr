// lib/features/time_off/presentation/controller/create_time_off_request_provider.dart
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_message_response_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/usecases/create_time_off_usecase.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';

class CreateTimeOffRequestProvider extends ChangeNotifier {
  final CreateTimeOffUseCase createTimeOffUseCase;

  CreateTimeOffRequestProvider({
    required this.createTimeOffUseCase,
  });

  AppRequesState _state = AppRequesState.initial;

  AppRequesState get state => _state;

  TimeOffMessageResponseEntity? _timeOffMessage;

  TimeOffMessageResponseEntity? get timeOffMessage => _timeOffMessage;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> createTimeOffRequest(CreateTimeOffParamsEntity params) async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, TimeOffMessageResponseEntity> result =
        await createTimeOffUseCase.call(params);

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (message) {
        _state = AppRequesState.loaded;
        _timeOffMessage = message;
      },
    );

    notifyListeners();
  }
}
