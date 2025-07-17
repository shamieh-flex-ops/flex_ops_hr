import 'package:equatable/equatable.dart';
import 'leave_status.dart';

class LeaveStatusGroup extends Equatable {
  final int leaveCount;
  final String description;
  final List<LeaveStatus> leaves;

  const LeaveStatusGroup({
    required this.leaveCount,
    required this.description,
    required this.leaves,
  });

  @override
  List<Object?> get props => [leaveCount, description, leaves];
}
