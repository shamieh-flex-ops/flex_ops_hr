// lib/features/resignation/domain/usecases/create_resignation_usecase.dart

import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/create_resignation_response.dart';
import 'package:flex_ops_hr/features/resignation/domain/repositories/base_resignation_repository.dart';

class CreateResignationUseCase extends BaseUseCase<CreateResignationResponse, CreateResignationParams> {
  final BaseResignationRepository repository;

  CreateResignationUseCase(this.repository);

  @override
  Future<Either<Failure, CreateResignationResponse>> call(CreateResignationParams parameters) {
    return repository.createResignation(parameters);
  }
}


class CreateResignationParams extends Equatable {
  final int noticePeriod;
  final String leaveDate;
  final String note;
  final String document;

  const CreateResignationParams({
    required this.noticePeriod,
    required this.leaveDate,
    required this.note,
    required this.document,
  });

  Map<String, dynamic> toJson() {
    return {
      "notice_period": noticePeriod,
      "leave_date": leaveDate,
      "note": note,
      "document": document,
    };
  }

  @override
  List<Object> get props => [noticePeriod, leaveDate, note, document];
}
