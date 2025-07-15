// lib/features/payslips/domain/usecases/get_payslips_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/payslips/domain/entities/payslip_entities.dart';
import 'package:flex_ops_hr/features/payslips/domain/repositories/base_payslip_repository.dart';

class GetPayslipsUseCase extends BaseUseCase<List<PayslipGroup>, NoParameters> {
  final BasePayslipRepository repository;

  GetPayslipsUseCase(this.repository);

  @override
  Future<Either<Failure, List<PayslipGroup>>> call(NoParameters parameters) {
    return repository.getPayslips();
  }
}
