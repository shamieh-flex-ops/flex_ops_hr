import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';

import 'package:flex_ops_hr/features/iqama/domain/entities/iqama_entities.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/create_iqama_renewal_response.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/get_iqama_renewal_groups_usecase.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/create_iqama_renewal_usecase.dart';

class IqamaProvider extends ChangeNotifier {
  final GetIqamaRenewalGroupsUseCase getIqamaRenewalGroupsUseCase;
  final CreateIqamaRenewalUseCase createIqamaRenewalUseCase;

  IqamaProvider({
    required this.getIqamaRenewalGroupsUseCase,
    required this.createIqamaRenewalUseCase,
  });

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<IqamaRenewalGroup> _iqamaGroups = [];
  List<IqamaRenewalGroup> get iqamaGroups => _iqamaGroups;

  CreateIqamaRenewalResponse? _createIqamaRenewalResponse;
  CreateIqamaRenewalResponse? get createIqamaRenewalResponse => _createIqamaRenewalResponse;

  /// Get iqama groups
  Future<void> fetchIqamaRenewalGroups() async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, List<IqamaRenewalGroup>> result =
        await getIqamaRenewalGroupsUseCase.call(NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (groups) {
        _iqamaGroups = groups;
        _state = AppRequesState.loaded;
      },
    );

    notifyListeners();
  }

  /// Create iqama renewal
  Future<void> createIqamaRenewal(CreateIqamaRenewalParams params) async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, CreateIqamaRenewalResponse> result =
        await createIqamaRenewalUseCase.call(params);

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (response) {
        _createIqamaRenewalResponse = response;
        _state = AppRequesState.loaded;
      },
    );

    notifyListeners();
  }
}
