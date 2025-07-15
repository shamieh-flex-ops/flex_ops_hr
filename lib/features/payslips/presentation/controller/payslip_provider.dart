// lib/features/payslips/presentation/provider/payslip_provider.dart

import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flex_ops_hr/features/payslips/domain/entities/payslip_entities.dart';
import 'package:flex_ops_hr/features/payslips/domain/usecases/get_payslips_usecase.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:dartz/dartz.dart';



class PayslipProvider extends ChangeNotifier {
  final GetPayslipsUseCase getPayslipsUseCase;

  PayslipProvider({required this.getPayslipsUseCase});

  AppRequesState _state = AppRequesState.initial;
  AppRequesState get state => _state;

  List<PayslipGroup> _payslipGroups = [];
  List<PayslipGroup> get payslipGroups => _payslipGroups;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPayslips() async {
    _state = AppRequesState.loading;
    notifyListeners();

    final Either<Failure, List<PayslipGroup>> result = await getPayslipsUseCase.call(NoParameters());

    result.fold(
      (failure) {
        _state = AppRequesState.error;
        _errorMessage = failure.message;
      },
      (data) {
        _state = AppRequesState.loaded;
        _payslipGroups = data;
      },
    );

    notifyListeners();
  }
}
