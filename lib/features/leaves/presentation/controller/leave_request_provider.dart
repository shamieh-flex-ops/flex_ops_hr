// import 'package:flutter/material.dart';
// import 'package:dartz/dartz.dart';
//
// import '../../../../core/error/failure.dart';
// import '../../../../core/usecase/base_usecase.dart';
// import '../../../../core/utils/enums.dart';
// import '../../domain/entities/leave_request_entity.dart';
// import '../../domain/usecases/request_leave_usecase.dart';
//
// class LeaveRequestProvider extends ChangeNotifier {
//   final RequestLeaveUseCase requestLeaveUseCase;
//
//   LeaveRequestProvider({required this.requestLeaveUseCase});
//
//   AppRequesState _state = AppRequesState.initial;
//   AppRequesState get state => _state;
//
//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;
//
//   bool _isSubmitted = false;
//   bool get isSubmitted => _isSubmitted;
//
//   Future<void> submitLeave(LeaveRequestParameters parameters) async {
//     _state = AppRequesState.loading;
//     _isSubmitted = false;
//     notifyListeners();
//
//     final Either<Failure, bool> result = await requestLeaveUseCase(parameters);
//
//     result.fold(
//           (failure) {
//         _state = AppRequesState.error;
//         _errorMessage = failure.message;
//       },
//           (success) {
//         _state = AppRequesState.loaded;
//         _isSubmitted = success;
//       },
//     );
//
//     notifyListeners();
//   }
//
//   void reset() {
//     _state = AppRequesState.initial;
//     _errorMessage = null;
//     _isSubmitted = false;
//     notifyListeners();
//   }
// }
