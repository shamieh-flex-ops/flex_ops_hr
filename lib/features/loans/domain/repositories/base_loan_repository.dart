import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_message_response.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';

abstract class BaseLoanRepository {
  Future<Either<Failure, List<LoanGroup>>> getLoanGroups();

  Future<Either<Failure, LoanMessageResponse>> createLoan(CreateLoanParams params);

}
