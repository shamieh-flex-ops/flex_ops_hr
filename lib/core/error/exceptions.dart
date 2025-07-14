import 'package:flex_ops_hr/core/network/error_message_model.dart';

class ServerException implements Exception {
 final MessageModel messageModel;
  const ServerException({required this.messageModel});
}


class LocalDatabaseException implements Exception {
  final String message;
  const LocalDatabaseException({required this.message});
}