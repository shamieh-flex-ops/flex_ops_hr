// lib/features/loans/domain/usecases/get_loan_groups_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';
import 'package:flex_ops_hr/features/loans/domain/repositories/base_loan_repository.dart';

class GetLoanGroupsUseCase extends BaseUseCase<List<LoanGroup>, NoParameters> {
  final BaseLoanRepository baseLoanRepository;

  GetLoanGroupsUseCase(this.baseLoanRepository);

  @override
  Future<Either<Failure, List<LoanGroup>>> call(NoParameters parameters) async {
    return await baseLoanRepository.getLoanGroups();
  }
}
