import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/payslips/data/datasources/payslip_remote_data_source.dart';
import 'package:flex_ops_hr/features/payslips/domain/entities/payslip_entities.dart';
import 'package:flex_ops_hr/features/payslips/domain/repositories/base_payslip_repository.dart';

class PayslipRepositoryImpl extends BasePayslipRepository {
  final PayslipRemoteDataSource remoteDataSource;

  PayslipRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PayslipGroup>>> getPayslips() async {
    try {
      final result = await remoteDataSource.getPayslips();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
    failure.messageModel.statusMessage, 
    failure.messageModel.statusCode
    
      ));
    }
  }
}
