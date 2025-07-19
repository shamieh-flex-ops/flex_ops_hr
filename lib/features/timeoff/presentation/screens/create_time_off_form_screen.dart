// lib/features/time_off/presentation/screens/create_time_off_form_screen.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/create_time_off_request_provider.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

// استيرادات الملفات الأساسية
import 'package:flex_ops_hr/core/utils/enums.dart';

class CreateTimeOffFormScreen extends StatefulWidget {
  final TimeOffFormType formType;

  const CreateTimeOffFormScreen({
    super.key,
    required this.formType,
  });

  @override
  State<CreateTimeOffFormScreen> createState() =>
      _CreateTimeOffFormScreenState();
}

class _CreateTimeOffFormScreenState extends State<CreateTimeOffFormScreen> {
  final _formKey = GlobalKey<FormState>();
  HolidayStatusIdEntity? _selectedHolidayStatus;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedAttachmentPath;
  bool _isSickLeaveSelected = false;

  List<HolidayStatusIdEntity> _localAvailableTypes =
      []; // قائمة محلية لتخزين الأنواع المتاحة

  @override
  void initState() {
    super.initState();
    // جلب الأنواع المتاحة من TimeOffStatusProvider عند تهيئة الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timeOffStatusProvider =
          Provider.of<TimeOffStatusProvider>(context, listen: false);

      // قم بجلب البيانات فقط إذا كانت في حالة "أولية" أو "خطأ" لتجنب المكالمات غير الضرورية
      if (timeOffStatusProvider.state == AppRequesState.initial ||
          timeOffStatusProvider.state == AppRequesState.error) {
        timeOffStatusProvider.fetchTimeOffStatusGroupsAndTypes();
      }

      // تهيئة _localAvailableTypes بناءً على الحالة الحالية للـ Provider
      // سيتم تحديث هذا لاحقًا بواسطة الـ Consumer عند تحميل البيانات بالكامل
      _updateLocalTypes(timeOffStatusProvider.availableTimeOffTypes);
    });
  }

  // دالة لمسح الأنواع المحلية وتعيينها، وتحديد النوع المختار إذا كان واحدًا فقط
  void _updateLocalTypes(List<HolidayStatusIdEntity> types) {
    setState(() {
      _localAvailableTypes = types;
      // إذا كان هناك نوع واحد فقط متاح بعد الجلب، حدده افتراضيًا
      if (_localAvailableTypes.length == 1) {
        _selectedHolidayStatus = _localAvailableTypes.first;
        _updateSickLeaveStatus();
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  // تحديث حالة ما إذا كانت الإجازة المختارة هي "إجازة مرضية"
  void _updateSickLeaveStatus() {
    setState(() {
      // ✅ ملاحظة: استخدام .name بدلاً من .description حيث أن الكيان HolidayStatusIdEntity يحتوي على name
      _isSickLeaveSelected = (_selectedHolidayStatus?.name == 'Sick Leave');
      if (!_isSickLeaveSelected) {
        _selectedAttachmentPath = null; // مسح المرفق إذا لم تكن إجازة مرضية
      }
    });
  }

  // دالة لاختيار التاريخ (تاريخ البدء أو الانتهاء)
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
          if (_selectedHolidayStatus?.name == 'Permission (Hourly)') {
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
          _fromTime = picked;
        } else {
          _toTime = picked;
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
                leading: const Icon(Icons.photo_library),
                title: const Text('اختيار من المعرض'),
                onTap: () async {
                  Navigator.pop(bc);
                  final pickedFile = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedAttachmentPath = pickedFile.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقاط صورة'),
                onTap: () async {
                  Navigator.pop(bc);
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedAttachmentPath = pickedFile.path;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('اختيار من الملفات (PDF/Word)'),
                onTap: () async {
                  Navigator.pop(bc);
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx'],
                  );
                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      _selectedAttachmentPath = result.files.single.path;
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

  Widget _buildPageTitle() {
    String titleText = '';
    if (widget.formType == TimeOffFormType.timeOff) {
      titleText = 'طلب إجازة سنوية، عارضة، أو إجازات طويلة الأمد أخرى:';
    } else {
      titleText = 'طلب إجازة خاصة (مثل: إجازة مرضية، إذن بالساعة):';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildLeaveTypeDropdown() {
    return Consumer<TimeOffStatusProvider>(
      builder: (context, timeOffStatusProvider, child) {
        final List<HolidayStatusIdEntity> filteredTypes =
            timeOffStatusProvider.availableTimeOffTypes.where((type) {
          if (widget.formType == TimeOffFormType.timeOff) {
            return type.name != 'Permission (Hourly)' &&
                type.name != 'Sick Leave';
          } else {
            // TimeOffFormType.specificLeaves
            return type.name == 'Permission (Hourly)' ||
                type.name == 'Sick Leave';
          }
        }).toList();

        if (!const DeepCollectionEquality()
            .equals(_localAvailableTypes, filteredTypes)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateLocalTypes(filteredTypes);
          });
        }

        if (timeOffStatusProvider.state == AppRequesState.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (timeOffStatusProvider.state == AppRequesState.error) {
          return Center(
              child: Text(
                  'خطأ في تحميل أنواع الإجازات: ${timeOffStatusProvider.errorMessage ?? "غير معروف"}'));
        } else if (filteredTypes.isEmpty) {
          return const Center(child: Text('لا توجد أنواع إجازات متاحة.'));
        }

        if (filteredTypes.length == 1 &&
            widget.formType == TimeOffFormType.specificLeaves) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'نوع الإجازة',
                style:
                    AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: AppColors.textDark, width: 1),
                ),
                child: Text(
                  _selectedHolidayStatus!.name,
                  style: AppTextStyles.bodyText1,
                ),
              ),
              SizedBox(height: 16.h),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نوع الإجازة',
              style:
                  AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<HolidayStatusIdEntity>(
              value: _selectedHolidayStatus,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                hintText: 'اختر نوع الإجازة',
              ),
              items: filteredTypes.map((HolidayStatusIdEntity type) {
                return DropdownMenuItem<HolidayStatusIdEntity>(
                  value: type,
                  child: Text(type.name,
                      style: AppTextStyles.bodyText1),
                );
              }).toList(),
              onChanged: (HolidayStatusIdEntity? newValue) {
                setState(() {
                  _selectedHolidayStatus = newValue;
                  _updateSickLeaveStatus();


                  if (_selectedHolidayStatus?.name != 'Permission (Hourly)') {
                    _fromTime = null;
                    _toTime = null;
                  }
                  if (_selectedHolidayStatus?.name == 'Permission (Hourly)' &&
                      _startDate != null) {
                    _endDate = _startDate;
                  } else if (_selectedHolidayStatus?.name !=
                          'Permission (Hourly)' &&
                      _endDate == _startDate) {
                    _endDate = null;
                  }
                });
              },
              validator: (value) =>
                  value == null ? 'الرجاء اختيار نوع الإجازة' : null,
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }

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
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: TextEditingController(
                text: date == null ? '' : DateFormat('yyyy-MM-dd').format(date),
              ),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                hintText: hint,
                suffixIcon: Icon(Icons.calendar_today,
                    color: AppColors.textMedium, size: 20.sp),
              ),
              validator: (value) =>
                  isRequired && (value == null || value.isEmpty)
                      ? 'الرجاء اختيار $label'
                      : null,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

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
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: TextEditingController(
                text: time == null ? '' : time.format(context),
              ),
              readOnly: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                hintText: hint,
                suffixIcon: Icon(Icons.access_time,
                    color: AppColors.textMedium, size: 20.sp),
              ),
              validator: (value) =>
                  isRequired && (value == null || value.isEmpty)
                      ? 'الرجاء اختيار $label'
                      : null,
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السبب',
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _reasonController,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            hintText: 'أدخل سبب الإجازة...',
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'الرجاء إدخال السبب' : null,
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    if (!_isSickLeaveSelected) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرفق (شهادة طبية)',
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 8.h),
        ElevatedButton.icon(
          onPressed: _pickAttachment,
          icon: Icon(Icons.attach_file, color: AppColors.white, size: 20.sp),
          label: Text(
            _selectedAttachmentPath == null
                ? 'رفع ملف'
                : _selectedAttachmentPath!.split('/').last,
            style: AppTextStyles.buttonText.copyWith(fontSize: 14.sp),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: Consumer<CreateTimeOffRequestProvider>(
        builder: (context, provider, child) {
          final bool isSubmitting = provider.state == AppRequesState.loading;
          return ElevatedButton(
            onPressed: isSubmitting ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 64.w, vertical: 16.h),
            ),
            child: isSubmitting
                ? SizedBox(
                    width: 20.sp,
                    height: 20.sp,
                    child: const CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'إرسال الطلب',
                    style: AppTextStyles.buttonText.copyWith(fontSize: 16.sp),
                  ),
          );
        },
      ),
    );
  }

  double _calculateNumberOfDays() {
    if (_startDate == null || _endDate == null) {
      return 0.0;
    }
    return (_endDate!.difference(_startDate!).inDays + 1).toDouble();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // تحقق من أن نوع الإجازة مختار قبل المتابعة
      if (_selectedHolidayStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('الرجاء اختيار نوع الإجازة قبل الإرسال.')),
        );
        return;
      }

      if (_selectedHolidayStatus?.name == 'Permission (Hourly)') {
        if (_fromTime == null || _toTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('الرجاء اختيار وقتي البدء والانتهاء لإذن الساعة.')),
          );
          return;
        }
        final fromDateTime = DateTime(_startDate!.year, _startDate!.month,
            _startDate!.day, _fromTime!.hour, _fromTime!.minute);
        final toDateTime = DateTime(_startDate!.year, _startDate!.month,
            _startDate!.day, _toTime!.hour, _toTime!.minute);
        if (toDateTime.isBefore(fromDateTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('وقت الانتهاء لا يمكن أن يكون قبل وقت البدء.')),
          );
          return;
        }
      } else {
        if (_endDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرجاء اختيار تاريخ الانتهاء.')),
          );
          return;
        }
        if (_endDate!.isBefore(_startDate!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('تاريخ الانتهاء لا يمكن أن يكون قبل تاريخ البدء.')),
          );
          return;
        }
      }

      final double calculatedNumberOfDays = _calculateNumberOfDays();

      // إنشاء كيان CreateTimeOffParamsEntity
      final createParams = CreateTimeOffParamsEntity(
        holidayStatusId: _selectedHolidayStatus!.id,
        numberOfDays: calculatedNumberOfDays,
        requestDateFrom: DateFormat('yyyy-MM-dd').format(_startDate!),
        requestDateTo: DateFormat('yyyy-MM-dd').format(_endDate!),
        notes:
            _reasonController.text.isNotEmpty ? _reasonController.text : null,
        attachment: _selectedAttachmentPath,
      );

      final createTimeOffRequestProvider =
          Provider.of<CreateTimeOffRequestProvider>(context, listen: false);
      await createTimeOffRequestProvider.createTimeOffRequest(createParams);

      if (createTimeOffRequestProvider.state == AppRequesState.loaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إرسال طلب ${_selectedHolidayStatus!.name} بنجاح!',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );

        _formKey.currentState!.reset();
        _reasonController.clear();
        setState(() {
          _selectedHolidayStatus = null;
          _startDate = null;
          _endDate = null;
          _fromTime = null;
          _toTime = null;
          _selectedAttachmentPath = null;
          _isSickLeaveSelected = false;
        });

        if (mounted) {
          context.go(
              '/home/time_off/status');
        }
      } else if (createTimeOffRequestProvider.state == AppRequesState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              createTimeOffRequestProvider.errorMessage ??
                  'فشل في إرسال طلب الوقت البديل.',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد عنوان الـ AppBar بناءً على نوع الفورم
    String appBarTitle = widget.formType == TimeOffFormType.timeOff
        ? 'طلب وقت بديل'
        : 'طلب إجازة خاصة';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: AppTextStyles.headline1
              .copyWith(color: AppColors.textDark, fontSize: 20.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBackground,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.backgroundLightBlue,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPageTitle(),
              _buildLeaveTypeDropdown(),
              // هذا الجزء سيستخدم Consumer لجلب البيانات
              _buildDateField(
                label: 'تاريخ البدء',
                date: _startDate,
                onTap: (ctx) => _selectDate(ctx, true),
                hint: 'اختر تاريخ البدء',
                isRequired: true,
              ),
              if (_selectedHolidayStatus?.name != 'Permission (Hourly)')
                _buildDateField(
                  label: 'تاريخ الانتهاء',
                  date: _endDate,
                  onTap: (ctx) => _selectDate(ctx, false),
                  hint: 'اختر تاريخ الانتهاء',
                  isRequired: true,
                ),
              if (_selectedHolidayStatus?.name == 'Permission (Hourly)')
                Column(
                  children: [
                    _buildTimeField(
                      label: 'من الساعة',
                      time: _fromTime,
                      onTap: (ctx) => _selectTime(ctx, true),
                      hint: 'اختر وقت البدء',
                      isRequired: true,
                    ),
                    _buildTimeField(
                      label: 'إلى الساعة',
                      time: _toTime,
                      onTap: (ctx) => _selectTime(ctx, false),
                      hint: 'اختر وقت الانتهاء',
                      isRequired: true,
                    ),
                  ],
                ),
              _buildReasonField(),
              _buildAttachmentSection(),
              SizedBox(height: 32.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}
