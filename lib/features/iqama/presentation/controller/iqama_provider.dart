import 'package:flex_ops_hr/core/services/services_locator.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/iqama_entities.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/get_iqama_renewal_groups_usecase.dart';

class IqamaProvider extends ChangeNotifier {
  final GetIqamaRenewalGroupsUseCase _getIqamaRenewalGroupsUseCase =
      sl<GetIqamaRenewalGroupsUseCase>();

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  List<IqamaRenewalGroup> _iqamaGroups = [];
  List<IqamaRenewalGroup> get iqamaGroups => _iqamaGroups;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> getIqamaRenewalGroups() async {
    _state = AppRequesState.loading;
    notifyListeners();

    final result = await _getIqamaRenewalGroupsUseCase.call(const NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (groups) {
        _iqamaGroups = groups;
        _state = AppRequesState.loaded;
        notifyListeners();
      },
    );
  }
}
