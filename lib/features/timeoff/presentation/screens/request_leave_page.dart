// lib/features/timeoff/presentation/screens/request_leave_page.dart

import 'dart:convert';
import 'dart:io';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/create_time_off_request_provider.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/date_input_widget.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/leave_type_dropdown.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/reason_input_widget.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/submit_button.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/attachment_input_widget.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/widgets/time_input_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  HolidayStatusIdEntity? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedAttachmentPath;
  final _formKey = GlobalKey<FormState>();

  bool get _isHourlyLeave => _selectedLeaveType?.name == 'Permission';

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

  void _handleLeaveTypeChanged(HolidayStatusIdEntity? newValue) {
    setState(() {
      _selectedLeaveType = newValue;
      _startDate = null;
      _endDate = null;
      _startTime = null;
      _endTime = null;
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

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _handleBrowseAttachment() async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload Document'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFileFromStorage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Pick Image from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFileFromStorage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedAttachmentPath = base64Encode(bytes);
      });
    } else {
      setState(() {
        _selectedAttachmentPath = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('لم يتم اختيار أي ملف.'),
            duration: Duration(seconds: 2)),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedAttachmentPath = base64Encode(bytes);
      });
    }
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final int holidayStatusId = _selectedLeaveType!.id;
      final String requestDateFrom =
          DateFormat('yyyy-MM-dd').format(_startDate!);
      final String requestDateTo =
          DateFormat('yyyy-MM-dd').format(_endDate ?? _startDate!);

      double numberOfDays;

      if (_isHourlyLeave) {
        if (_startTime == null || _endTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('الرجاء اختيار وقت البدء والانتهاء للإجازة الساعية.'),
                duration: Duration(seconds: 3)),
          );
          return;
        }
        numberOfDays = 1.0;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'الإجازات الساعية يتم إرسالها كإجازة يوم كامل حاليًا. يرجى مراجعة دعم API.'),
              duration: Duration(seconds: 4)),
        );
      } else {
        if (_endDate == null || _startDate == _endDate) {
          numberOfDays = 1.0;
        } else {
          final Duration difference = _endDate!.difference(_startDate!);
          numberOfDays = difference.inDays.toDouble() + 1;
        }
      }

      final String? notes =
          _reasonController.text.isNotEmpty ? _reasonController.text : null;
      final String? attachment = _selectedAttachmentPath;

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            context.go('/home');
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
        title: const Text('Request Leave (Sick/Hourly)'),
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
                  selectedLeaveType: _selectedLeaveType,
                  onChanged: _handleLeaveTypeChanged,
                  isForTimeOffPage: false,
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
                      label: _isHourlyLeave ? 'Date' : 'Start Date',
                      date: _startDate,
                      onTap: (ctx) => _selectDate(ctx, true),
                      hint:
                          _isHourlyLeave ? 'Select Date' : 'Select Start Date',
                      isRequired: true,
                    ),
                    SizedBox(height: 16.h),
                    if (!_isHourlyLeave)
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
              if (_isHourlyLeave)
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
                      TimeInputWidget(
                        label: 'Start Time',
                        time: _startTime,
                        onTap: (ctx) => _selectTime(ctx, true),
                        hint: 'Select Start Time',
                      ),
                      SizedBox(height: 16.h),
                      TimeInputWidget(
                        label: 'End Time',
                        time: _endTime,
                        onTap: (ctx) => _selectTime(ctx, false),
                        hint: 'Select End Time',
                      ),
                    ],
                  ),
                ),
              if (_isHourlyLeave) SizedBox(height: 16.h),
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
                child: AttachmentInputWidget(
                  selectedAttachmentPath: _selectedAttachmentPath,
                  onBrowsePressed: _handleBrowseAttachment,
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
