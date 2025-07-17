import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/get_resignation_groups_usecase.dart';

class ResignationProvider extends ChangeNotifier {
  final GetResignationGroupsUseCase getResignationGroupsUseCase;

  ResignationProvider({required this.getResignationGroupsUseCase});

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  List<ResignationGroup> _resignationGroups = [];
  List<ResignationGroup> get resignationGroups => _resignationGroups;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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
      (data) {
        _resignationGroups = data;
        _state = AppRequesState.loaded;
      },
    );

    notifyListeners();
  }
}
