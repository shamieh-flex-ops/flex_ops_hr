import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/loans/data/datasources/loan_remote_data_source.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_message_response.dart';
import 'package:flex_ops_hr/features/loans/domain/repositories/base_loan_repository.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';

class LoanRepositoryImpl extends BaseLoanRepository {
  final LoanRemoteDataSource remoteDataSource;

  LoanRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<LoanGroup>>> getLoanGroups() async {
    try {
      final result = await remoteDataSource.getLoanGroups();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.messageModel.statusMessage, failure.messageModel.statusCode));
    }
  }

  @override
  Future<Either<Failure, LoanMessageResponse>> createLoan(
      CreateLoanParams params) async {
    try {
      final result = await remoteDataSource.createLoan(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }
}
