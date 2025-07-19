// lib/features/timeoff/data/models/my_leaves_info_response_model.dart

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/holiday_status_id_model.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';

class MyLeavesInfoResponseModel extends Equatable {
  final List<HolidayStatusIdModel> leaveTypes; // هنا ستكون قائمة بالـ Models

  const MyLeavesInfoResponseModel({required this.leaveTypes});

  factory MyLeavesInfoResponseModel.fromJson(String source) =>
      MyLeavesInfoResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory MyLeavesInfoResponseModel.fromMap(Map<String, dynamic> map) {
    final List<dynamic> resultList = map['result'] as List<dynamic>? ?? [];
    return MyLeavesInfoResponseModel(
      leaveTypes: resultList
          .map((e) => HolidayStatusIdModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  List<HolidayStatusIdEntity> toEntities() {
    return leaveTypes.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [leaveTypes];
}