// lib/features/payslips/domain/repositories/payslip_repositorypayslip_repository.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import '../entities/payslip_entities.dart';

abstract class BasePayslipRepository {
  Future<Either<Failure, List<PayslipGroup>>> getPayslips();
}
