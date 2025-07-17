// lib/features/resignation/domain/entities/create_resignation_response.dart

import 'package:equatable/equatable.dart';

class CreateResignationResponse extends Equatable {
  final String msg;
  final int resignationId;

  const CreateResignationResponse({
    required this.msg,
    required this.resignationId,
  });

  @override
  List<Object> get props => [msg, resignationId];
}
