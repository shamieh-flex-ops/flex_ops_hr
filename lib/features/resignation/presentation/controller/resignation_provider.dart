
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';

import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/create_resignation_response.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/get_resignation_groups_usecase.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/create_resignation_usecase.dart';

class ResignationProvider extends ChangeNotifier {
  final GetResignationGroupsUseCase getResignationGroupsUseCase;
  final CreateResignationUseCase createResignationUseCase;

  ResignationProvider({
    required this.getResignationGroupsUseCase,
    required this.createResignationUseCase,
  });

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ResignationGroup> _resignationGroups = [];
  List<ResignationGroup> get resignationGroups => _resignationGroups;

  CreateResignationResponse? _createResignationResponse;
  CreateResignationResponse? get createResignationResponse => _createResignationResponse;

  /// Get resignation groups
  Future<void> fetchResignationGroups() async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, List<ResignationGroup>> result =
        await getResignationGroupsUseCase.call(NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (groups) {
        _resignationGroups = groups;
        _state = AppRequesState.loaded;
      },
    );

    notifyListeners();
  }

  /// Create resignation
  Future<void> createResignation(CreateResignationParams params) async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, CreateResignationResponse> result =
        await createResignationUseCase.call(params);

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (response) {
        _createResignationResponse = response;
        _state = AppRequesState.loaded;
      },
    );

    notifyListeners();
  }
}


