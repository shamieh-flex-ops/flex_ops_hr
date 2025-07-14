import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/profile/domain/entities/user_profile.dart';
import 'package:flex_ops_hr/features/profile/domain/usecases/get_user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final GetUserProfile getUserProfileUseCase;

  ProfileProvider({required this.getUserProfileUseCase});

  bool isLoading = false;
  UserProfile? profile;
  String? errorMessage;

  Future<void> fetchUserProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final Either<Failure, UserProfile> result =
        await getUserProfileUseCase(const NoParameters());

    result.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (data) {
        profile = data;
      },
    );

    isLoading = false;
    notifyListeners();
  }
}
