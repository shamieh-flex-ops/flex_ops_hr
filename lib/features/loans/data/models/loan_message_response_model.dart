import 'package:flex_ops_hr/features/loans/domain/entities/loan_message_response.dart';

class LoanMessageResponseModel extends LoanMessageResponse {
  const LoanMessageResponseModel({
    required super.message,
    required super.loanId,
  });

  factory LoanMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return LoanMessageResponseModel(
      message: json['msg'] ?? '',
      loanId: json['loan_id'] ?? 0,
    );
  }
}
