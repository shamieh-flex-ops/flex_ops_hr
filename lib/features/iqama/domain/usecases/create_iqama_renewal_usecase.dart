import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/create_iqama_renewal_response.dart';
import 'package:flex_ops_hr/features/iqama/domain/repository/base_iqama_repository.dart';

class CreateIqamaRenewalUseCase extends BaseUseCase<CreateIqamaRenewalResponse, CreateIqamaRenewalParams> {
  final BaseIqamaRepository repository;

  CreateIqamaRenewalUseCase(this.repository);

  @override
  Future<Either<Failure, CreateIqamaRenewalResponse>> call(CreateIqamaRenewalParams params) async {
    return await repository.createIqamaRenewal(params);
  }
}

class CreateIqamaRenewalParams {
  final String newIqamaId;
  final String renewalDate;
  final String note;
  final String document;

  const CreateIqamaRenewalParams({
    required this.newIqamaId,
    required this.renewalDate,
    required this.note,
    required this.document,
  });

  Map<String, dynamic> toJson() {
    return {
      "new_iqama_id": newIqamaId,
      "renewal_date": renewalDate,
      "note": note,
      "document": document,
    };
  }
}
