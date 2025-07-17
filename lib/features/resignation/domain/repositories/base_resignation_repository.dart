// lib/features/resignation/domain/repositories/base_resignation_repository.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/create_resignation_response.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/create_resignation_usecase.dart';

abstract class BaseResignationRepository {

  Future<Either<Failure, List<ResignationGroup>>> getResignationGroups();
      Future<Either<Failure, CreateResignationResponse>> createResignation(CreateResignationParams params);

}