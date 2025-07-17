import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_message_response.dart';
import 'package:flex_ops_hr/features/loans/domain/repositories/base_loan_repository.dart';

class CreateLoanUseCase extends BaseUseCase<LoanMessageResponse, CreateLoanParams> {
  final BaseLoanRepository repository;

  CreateLoanUseCase(this.repository);

  @override
  Future<Either<Failure, LoanMessageResponse>> call(CreateLoanParams parameters) async {
    return await repository.createLoan(parameters);
  }
}

class CreateLoanParams extends Equatable {
  final double loanAmount;
  final int installment;
  final String paymentDate;
  final String reason;

  const CreateLoanParams({
    required this.loanAmount,
    required this.installment,
    required this.paymentDate,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      "loan_amount": loanAmount,
      "installment": installment,
      "payment_date": paymentDate,
      "reason": reason,
    };
  }

  @override
  List<Object> get props => [loanAmount, installment, paymentDate, reason];
}
