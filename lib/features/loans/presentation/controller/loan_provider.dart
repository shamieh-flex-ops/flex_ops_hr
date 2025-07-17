// lib/features/loans/presentation/controller/loan_provider.dart

import 'package:flex_ops_hr/features/loans/domain/entities/loan_message_response.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/get_loan_groups_usecase.dart';

class LoanProvider extends ChangeNotifier {
  final GetLoanGroupsUseCase getLoanGroupsUseCase;
  final CreateLoanUseCase createLoanUseCase;

  LoanProvider({
    required this.getLoanGroupsUseCase,
    required this.createLoanUseCase,
  });

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  List<LoanGroup> _loanGroups = [];
  List<LoanGroup> get loanGroups => _loanGroups;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoanMessageResponse? _loanMessage;
  LoanMessageResponse? get loanMessage => _loanMessage;

  Future<void> fetchLoanGroups() async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, List<LoanGroup>> result =
        await getLoanGroupsUseCase.call(NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (data) {
        _state = AppRequesState.loaded;
        _loanGroups = data;
      },
    );

    notifyListeners();
  }

  Future<void> createLoan(CreateLoanParams params) async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, LoanMessageResponse> result =
        await createLoanUseCase.call(params);
print(result);
    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (message) {
        _state = AppRequesState.loaded;
        _loanMessage = message;
      },
    );

    notifyListeners();
  }
}
