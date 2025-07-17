import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import '../entities/iqama_entities.dart';

abstract class BaseIqamaRepository {
  Future<Either<Failure, List<IqamaRenewalGroup>>> getIqamaRenewalGroups();
}
