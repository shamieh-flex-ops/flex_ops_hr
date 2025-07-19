// lib/features/timeoff/presentation/screens/request_time_off_page.dart
import 'package:flex_ops_hr/core/utils/app_theme.dart';

import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/create_time_off_request_provider.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/date_input_widget.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/leave_type_dropdown.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/reason_input_widget.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';

class RequestTimeOffPage extends StatefulWidget {
  const RequestTimeOffPage({super.key});

  @override
  State<RequestTimeOffPage> createState() => _RequestTimeOffPageState();
}

class _RequestTimeOffPageState extends State<RequestTimeOffPage> {
  HolidayStatusIdEntity? _selectedTimeOffType;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimeOffStatusProvider>(context, listen: false)
          .fetchTimeOffStatusGroupsAndTypes();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _handleTimeOffTypeChanged(HolidayStatusIdEntity? newValue) {
    setState(() {
      _selectedTimeOffType = newValue;
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }

        if (_startDate != null &&
            _endDate != null &&
            _endDate!.isBefore(_startDate!)) {
          if (isStartDate) {
            _endDate = null;
          } else {
            _startDate = null;
          }
        }
      });
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final int holidayStatusId = _selectedTimeOffType!.id;
      final String requestDateFrom =
          DateFormat('yyyy-MM-dd').format(_startDate!);
      final String requestDateTo =
          DateFormat('yyyy-MM-dd').format(_endDate ?? _startDate!);

      double numberOfDays;
      if (_endDate == null || _startDate == _endDate) {
        numberOfDays = 1.0;
      } else {
        final Duration difference = _endDate!.difference(_startDate!);
        numberOfDays = difference.inDays.toDouble() + 1;
      }

      final String? notes =
          _reasonController.text.isNotEmpty ? _reasonController.text : null;
      final String? attachment = null;

      final CreateTimeOffParamsEntity params = CreateTimeOffParamsEntity(
        holidayStatusId: holidayStatusId,
        numberOfDays: numberOfDays,
        requestDateFrom: requestDateFrom,
        requestDateTo: requestDateTo,
        notes: notes,
        attachment: attachment,
      );

      final createProvider =
          Provider.of<CreateTimeOffRequestProvider>(context, listen: false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('جاري إرسال طلب الإجازة...'),
            duration: Duration(seconds: 2)),
      );

      await createProvider.createTimeOffRequest(params);

      if (createProvider.state == AppRequesState.loaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(createProvider.timeOffMessage?.message ??
                  'تم إرسال طلب الإجازة بنجاح!')),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          // تأخير بسيط
          if (mounted) {
            context.pushReplacement('/home');
            Provider.of<TimeOffStatusProvider>(context, listen: false)
                .fetchTimeOffStatusGroupsAndTypes();
          }
        });
      } else if (createProvider.state == AppRequesState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(createProvider.errorMessage ??
                  'فشل إرسال طلب الإجازة. يرجى المحاولة مرة أخرى.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: const Text('Request Time Off (Annual & Others)'),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: LeaveTypeDropdown(
                  selectedLeaveType: _selectedTimeOffType,
                  onChanged: _handleTimeOffTypeChanged,
                  isForTimeOffPage: true,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    DateInputWidget(
                      label: 'Start Date',
                      date: _startDate,
                      onTap: (ctx) => _selectDate(ctx, true),
                      hint: 'Select Start Date',
                      isRequired: true,
                    ),
                    SizedBox(height: 16.h),
                    DateInputWidget(
                      label: 'End Date',
                      date: _endDate,
                      onTap: (ctx) => _selectDate(ctx, false),
                      hint: 'Select End Date',
                      isRequired: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: ReasonInputWidget(
                  controller: _reasonController,
                ),
              ),
              SizedBox(height: 24.h),
              SubmitButton(
                onSubmit: _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
