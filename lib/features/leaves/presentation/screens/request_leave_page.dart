// lib/presentation/pages/leaves/request_leave_page.dart

import 'package:flex_ops_hr/components/app_text_field.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/time_off_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/presentation/controller/leave_request_provider.dart';
import 'package:flex_ops_hr/features/leaves/presentation/widgets/leave_type_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  final _formKey = GlobalKey<FormState>();
  LeaveTypeEntity? _selectedLeaveType;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _fromHour;
  TimeOfDay? _toHour;
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedAttachmentPath;
  String? _selectedAttachmentName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ تم تغيير getLeaveTypes() إلى fetchLeaveTypes() كما هو موجود في LeavesRequestProvider
      Provider.of<LeavesRequestProvider>(context, listen: false).fetchLeaveTypes();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  bool get _isHourlyPermissionSelected => _selectedLeaveType?.name == 'Permission (Hourly)';
  bool get _isSickLeaveSelected => _selectedLeaveType?.name == 'Sick Leave';

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.white,
              onSurface: AppColors.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _endDate!.isBefore(_startDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isFromTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: AppColors.white,
              onSurface: AppColors.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFromTime) {
          _fromHour = picked;
        } else {
          _toHour = picked;
        }
      });
    }
  }

  Future<void> _pickAttachment() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library, size: 24.w),
                title: Text('Pick from Gallery', style: AppTextStyles.bodyText1.copyWith(fontSize: 14.sp)),
                onTap: () async {
                  Navigator.pop(bc);
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedAttachmentPath = pickedFile.path;
                      _selectedAttachmentName = pickedFile.name;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, size: 24.w),
                title: Text('Take a Photo', style: AppTextStyles.bodyText1.copyWith(fontSize: 14.sp)),
                onTap: () async {
                  Navigator.pop(bc);
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedAttachmentPath = pickedFile.path;
                      _selectedAttachmentName = pickedFile.name;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.insert_drive_file, size: 24.w),
                title: Text('Pick from Files (PDF/Word)', style: AppTextStyles.bodyText1.copyWith(fontSize: 14.sp)),
                onTap: () async {
                  Navigator.pop(bc);
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
                  );
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      _selectedAttachmentPath = result.files.single.path;
                      _selectedAttachmentName = result.files.single.name;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ استخدام AppTextField هنا
  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required Function(BuildContext) onTap,
    required String hint,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: AppTextField( // ✅ استخدام AppTextField
              controller: TextEditingController(
                text: date == null ? '' : DateFormat('yyyy-MM-dd').format(date),
              ),
              readOnly: true,
              hintText: hint,
              suffixIcon: Icon(Icons.calendar_today, color: AppColors.textMedium, size: 20.w),
              validator: (value) => isRequired && (value == null || value.isEmpty)
                  ? 'Please select a $label'
                  : null,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  // ✅ استخدام AppTextField هنا
  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required Function(BuildContext) onTap,
    required String hint,
    required bool isRequired,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: AppTextField( // ✅ استخدام AppTextField
              controller: TextEditingController(
                text: time == null ? '' : time.format(context),
              ),
              readOnly: true,
              hintText: hint,
              suffixIcon: Icon(Icons.access_time, color: AppColors.textMedium, size: 20.w),
              validator: (value) => isRequired && (value == null || value.isEmpty)
                  ? 'Please select a $label'
                  : null,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all required fields correctly.', AppColors.error);
      return;
    }

    if (_selectedLeaveType == null) {
      _showSnackBar('Please select a leave type.', AppColors.error);
      return;
    }
    if (_startDate == null) {
      _showSnackBar('Please select a start date.', AppColors.error);
      return;
    }

    final provider = Provider.of<LeavesRequestProvider>(context, listen: false);

    if (_isHourlyPermissionSelected) {
      if (_fromHour == null || _toHour == null) {
        _showSnackBar('Please select both start and end times for hourly permission.', AppColors.error);
        return;
      }
      final fromDateTime = DateTime(_startDate!.year, _startDate!.month,
          _startDate!.day, _fromHour!.hour, _fromHour!.minute);
      final toDateTime = DateTime(_startDate!.year, _startDate!.month,
          _startDate!.day, _toHour!.hour, _toHour!.minute);
      if (toDateTime.isBefore(fromDateTime)) {
        _showSnackBar('End time cannot be before start time.', AppColors.error);
        return;
      }
      final timeOffRequest = TimeOffRequestEntity(
        leaveTypeId: _selectedLeaveType!.id,
        requestDateFrom: DateFormat('yyyy-MM-dd').format(_startDate!), // Ensure date format matches entity
        requestDateTo: DateFormat('yyyy-MM-dd').format(_startDate!),   // Ensure date format matches entity
        numberOfDays: 0.0, // For hourly, days are usually 0 or handled differently in backend
        reason: _reasonController.text.trim(),
      );
      await provider.submitTimeOffRequest(timeOffRequest);
    } else {
      if (_endDate == null) {
        _showSnackBar('Please select an end date.', AppColors.error);
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        _showSnackBar('End date cannot be before start date.', AppColors.error);
        return;
      }
      if (_isSickLeaveSelected && (_selectedAttachmentPath == null || _selectedAttachmentPath!.isEmpty)) {
        _showSnackBar('Please attach a medical certificate for sick leave.', AppColors.error);
        return;
      }
      final leaveRequest = LeaveRequestEntity(
        leaveTypeId: _selectedLeaveType!.id,
        requestDateFrom: DateFormat('yyyy-MM-dd').format(_startDate!), // Ensure date format matches entity
        requestDateTo: DateFormat('yyyy-MM-dd').format(_endDate!),     // Ensure date format matches entity
        numberOfDays: (_endDate!.difference(_startDate!).inDays + 1).toDouble(),
        reason: _reasonController.text.trim(),
        attachmentPath: _selectedAttachmentPath,
      );
      await provider.submitLeaveRequest(leaveRequest);
    }


    if (_isHourlyPermissionSelected) {
      if (provider.requestTimeOffState == AppRequesState.loaded) {
        _showSnackBar(provider.requestTimeOffMessage ?? 'Time off request submitted successfully!', AppColors.success);
        _resetForm();
        if (mounted) {
          context.go('/home');
        }
      } else if (provider.requestTimeOffState == AppRequesState.error) {
        _showSnackBar(provider.requestTimeOffMessage ?? 'Failed to submit time off request. Please try again.', AppColors.error);
      }
      provider.resetRequestTimeOffState();
    } else { // Regular Leave Request
      if (provider.requestLeaveState == AppRequesState.loaded) {
        _showSnackBar(provider.requestLeaveMessage ?? 'Leave request submitted successfully!', AppColors.success);
        _resetForm();
        if (mounted) {
          context.go('/home/leaves');
        }
      } else if (provider.requestLeaveState == AppRequesState.error) {
        _showSnackBar(provider.requestLeaveMessage ?? 'Failed to submit leave request. Please try again.', AppColors.error);
      }
      provider.resetRequestLeaveState();
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontSize: 14.sp)),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _reasonController.clear();
    setState(() {
      _selectedLeaveType = null;
      _startDate = null;
      _endDate = null;
      _fromHour = null;
      _toHour = null;
      _selectedAttachmentPath = null;
      _selectedAttachmentName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Leave',
          style: AppTextStyles.headline1.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
        toolbarHeight: 60.h,
      ),
      backgroundColor: AppColors.backgroundLightBlue,
      body: Consumer<LeavesRequestProvider>(
        builder: (context, provider, child) {
          // ✅ التحقق من حالة جلب أنواع الإجازات
          if (provider.getLeaveTypesState == AppRequesState.loading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue, strokeWidth: 3.w));
          }

          if (provider.getLeaveTypesState == AppRequesState.error) {
            // ✅ استخدام errorMessage من الـ Provider
            String errorMessage = provider.getLeaveTypesErrorMessage ?? 'Failed to load leave types. Please try again.';
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText1.copyWith(color: AppColors.error, fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => provider.fetchLeaveTypes(), // ✅ استدعاء الدالة الصحيحة
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text('Retry', style: AppTextStyles.buttonText.copyWith(fontSize: 16.sp)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.leaveTypes.isEmpty && provider.getLeaveTypesState == AppRequesState.loaded) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No leave types available. Please contact support or retry.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => provider.fetchLeaveTypes(), // ✅ استدعاء الدالة الصحيحة
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: Text('Refresh Leave Types', style: AppTextStyles.buttonText.copyWith(fontSize: 16.sp)),
                    ),
                  ],
                ),
              ),
            );
          }

          // ✅ تحديد ما إذا كان هناك عملية إرسال (leave أو time off) قيد التقدم
          final bool isSubmitting = provider.requestLeaveState == AppRequesState.loading ||
              provider.requestTimeOffState == AppRequesState.loading;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fill in the details for your leave request:',
                    style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
                  ),
                  SizedBox(height: 24.h),

                  // Leave Type Dropdown
                  LeaveTypeDropdownField(
                    value: _selectedLeaveType,
                    items: provider.leaveTypes,
                    onChanged: (LeaveTypeEntity? newValue) {
                      setState(() {
                        _selectedLeaveType = newValue;
                        _startDate = null;
                        _endDate = null;
                        _fromHour = null;
                        _toHour = null;
                        _selectedAttachmentPath = null;
                        _selectedAttachmentName = null;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a leave type' : null,
                    hintText: 'Select Leave Type',
                  ),
                  SizedBox(height: 16.h),

                  // Start Date
                  _buildDateField(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: (ctx) => _selectDate(ctx, true),
                    hint: 'Select Start Date',
                    isRequired: true,
                  ),

                  // End Date - Hidden for hourly permission
                  if (!_isHourlyPermissionSelected)
                    _buildDateField(
                      label: 'End Date',
                      date: _endDate,
                      onTap: (ctx) => _selectDate(ctx, false),
                      hint: 'Select End Date',
                      isRequired: true,
                    ),

                  // From/To Time - Only for hourly permission
                  if (_isHourlyPermissionSelected)
                    Column(
                      children: [
                        _buildTimeField(
                          label: 'From Time',
                          time: _fromHour,
                          onTap: (ctx) => _selectTime(ctx, true),
                          hint: 'Select From Time',
                          isRequired: true,
                        ),
                        _buildTimeField(
                          label: 'To Time',
                          time: _toHour,
                          onTap: (ctx) => _selectTime(ctx, false),
                          hint: 'Select To Time',
                          isRequired: true,
                        ),
                      ],
                    ),

                  // Reason Field using AppTextField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reason',
                        style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
                      ),
                      SizedBox(height: 8.h),
                      AppTextField( // ✅ استخدام AppTextField لحقل السبب
                        controller: _reasonController,
                        maxLines: 3,
                        hintText: 'Enter reason for leave...',
                        validator: (value) => value!.isEmpty ? 'Please enter a reason' : null,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),

                  // Attachment - Only for sick leave
                  if (_isSickLeaveSelected)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Attachment (Medical Certificate)',
                          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton.icon(
                          onPressed: _pickAttachment,
                          icon: Icon(Icons.attach_file, color: AppColors.white, size: 20.w),
                          label: Text(
                            _selectedAttachmentName == null || _selectedAttachmentName!.isEmpty
                                ? 'Upload File'
                                : _selectedAttachmentName!,
                            style: AppTextStyles.buttonText.copyWith(fontSize: 16.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),

                  SizedBox(height: 32.h),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // ✅ تعطيل الزر إذا كانت هناك عملية إرسال قيد التقدم
                      onPressed: isSubmitting ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: isSubmitting
                          ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.w,
                        ),
                      )
                          : Text(
                        'Submit Request',
                        style: AppTextStyles.buttonText.copyWith(fontSize: 18.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}