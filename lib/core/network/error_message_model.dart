import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final int statusCode;
  final String statusMessage;
  final bool success;

  const MessageModel({
    required this.statusCode,
    required this.statusMessage,
    required this.success,
  });

factory MessageModel.fromJson(Map<String, dynamic> json) {
    final result = json["result"];

  return MessageModel(
    statusCode: json["status_code"] ?? 0,
    statusMessage: result is Map<String, dynamic> && result["error"] != null
        ? result["error"]
        : json["status_message"] ?? 'Unexpected error', 
           success: json["success"] ?? false,
  );
}

  @override
  List<Object?> get props => [
        statusCode,
        statusMessage,
        success,
      ];
}