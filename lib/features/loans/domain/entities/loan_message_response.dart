import 'package:equatable/equatable.dart';

class LoanMessageResponse extends Equatable {
  final String message;
  final int? loanId;

  const LoanMessageResponse({
    required this.message,
    this.loanId,
  });

  @override
  List<Object?> get props => [message, loanId];
}
