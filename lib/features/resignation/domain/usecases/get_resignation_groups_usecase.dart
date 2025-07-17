import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';
import 'package:flex_ops_hr/features/resignation/domain/repositories/base_resignation_repository.dart';

class GetResignationGroupsUseCase
    extends BaseUseCase<List<ResignationGroup>, NoParameters> {
  final BaseResignationRepository baseResignationRepository;

  GetResignationGroupsUseCase(this.baseResignationRepository);

  @override
  Future<Either<Failure, List<ResignationGroup>>> call(
      NoParameters parameters) async {
    return await baseResignationRepository.getResignationGroups();
  }
}
