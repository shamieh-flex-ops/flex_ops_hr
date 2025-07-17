import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import '../entities/iqama_entities.dart';
import '../repository/base_iqama_repository.dart';

class GetIqamaRenewalGroupsUseCase extends BaseUseCase<List<IqamaRenewalGroup>, NoParameters> {
  final BaseIqamaRepository repository;

  GetIqamaRenewalGroupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<IqamaRenewalGroup>>> call(NoParameters parameters) {
    return repository.getIqamaRenewalGroups();
  }
}
