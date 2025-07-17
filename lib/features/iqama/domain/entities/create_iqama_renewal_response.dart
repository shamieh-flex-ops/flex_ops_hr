import 'package:equatable/equatable.dart';

class CreateIqamaRenewalResponse extends Equatable {
  final String message;
  final int renewIqamaId;

  const CreateIqamaRenewalResponse({
    required this.message,
    required this.renewIqamaId,
  });

  @override
  List<Object?> get props => [message, renewIqamaId];
}
