// lib/features/resignation/presentation/screens/create_resignation_screen.dart

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/create_resignation_usecase.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/components/app_text_field.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:image_picker/image_picker.dart';

class CreateResignationScreen extends StatefulWidget {
  const CreateResignationScreen({super.key});

  @override
  State<CreateResignationScreen> createState() =>
      _CreateResignationScreenState();
}

class _CreateResignationScreenState extends State<CreateResignationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noticePeriodController = TextEditingController();
  final TextEditingController _leaveDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _base64Document;
  String? _documentFileName;

  Future<void> _pickDocument() async {
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
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      setState(() {
        _base64Document = base64Encode(bytes);
        _documentFileName = result.files.single.name;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      setState(() {
        _base64Document = base64Encode(bytes);
        _documentFileName = pickedFile.name;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
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
        _leaveDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_base64Document == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload a document.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final params = CreateResignationParams(
      noticePeriod: int.parse(_noticePeriodController.text),
      leaveDate: _leaveDateController.text,
      note: _noteController.text,
      document: _base64Document!,
    );

    final provider = Provider.of<ResignationProvider>(context, listen: false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Submitting resignation request...'),
          duration: Duration(seconds: 2)),
    );

    await provider.createResignation(params);

    if (provider.state == AppRequesState.loaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.createResignationResponse?.msg ??
              'Resignation requested successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/home');
      Provider.of<TimeOffStatusProvider>(context, listen: false)
          .fetchTimeOffStatusGroupsAndTypes();
    } else if (provider.state == AppRequesState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Something went wrong'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _noticePeriodController.dispose();
    _leaveDateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResignationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          'Create Resignation',
          style: AppTextStyles.headline1.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16.h),
              AppTextField(
                controller: _noticePeriodController,
                keyboardType: TextInputType.number,
                labelText: 'Notice Period (days)',
                hintText: 'e.g., 30',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter notice period'
                    : null,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _leaveDateController,
                labelText: 'Leave Date',
                hintText: 'YYYY-MM-DD',
                readOnly: true,
                onTap: () => _selectDate(context),
                suffixIcon:
                    Icon(Icons.calendar_today, color: AppColors.primaryBlue),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select leave date'
                    : null,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _noteController,
                labelText: 'Note',
                hintText: 'e.g., Reason for resignation',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a note'
                    : null,
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                onPressed: _pickDocument,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  _documentFileName == null
                      ? 'Upload Document'
                      : 'Document: $_documentFileName',
                  style: AppTextStyles.buttonText,
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      provider.state == AppRequesState.loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 4,
                  ),
                  child: provider.state == AppRequesState.loading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Submit Resignation Request',
                          style: AppTextStyles.buttonText,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
