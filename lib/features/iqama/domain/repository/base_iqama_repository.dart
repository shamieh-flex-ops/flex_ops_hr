import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/create_iqama_renewal_response.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/create_iqama_renewal_usecase.dart';
import '../entities/iqama_entities.dart';

abstract class BaseIqamaRepository {
  Future<Either<Failure, List<IqamaRenewalGroup>>> getIqamaRenewalGroups();
    Future<Either<Failure, CreateIqamaRenewalResponse>> createIqamaRenewal(
    CreateIqamaRenewalParams params,
  );
}
