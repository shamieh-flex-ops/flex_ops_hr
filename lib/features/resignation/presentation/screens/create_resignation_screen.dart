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

class CreateResignationScreen extends StatefulWidget {
  const CreateResignationScreen({super.key});

  @override
  State<CreateResignationScreen> createState() => _CreateResignationScreenState();
}

class _CreateResignationScreenState extends State<CreateResignationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noticePeriodController = TextEditingController();
  final TextEditingController _leaveDateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _base64Document;

Future<void> _pickDocument() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg'], // تدعم ملفات وصور
  );

  if (result != null && result.files.single.path != null) {
    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    setState(() {
      _base64Document = base64Encode(bytes);
    });
  }
}

  void _submit() {
    if (!_formKey.currentState!.validate() ) return;
//|| _base64Document == null
    final params = CreateResignationParams(
      noticePeriod: int.parse(_noticePeriodController.text),
      leaveDate: _leaveDateController.text,
      note: _noteController.text,
      document: _base64Document!,
    );

    final provider = Provider.of<ResignationProvider>(context, listen: false);
    provider.createResignation(params).then((_) {
      if (provider.state == AppRequesState.loaded) {
        Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(provider.createResignationResponse!.msg),
                                backgroundColor: Colors.green,
                              ),
                            );
      } else if (provider.state == AppRequesState.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Something went wrong')),
        );
      }
    });
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
      appBar: AppBar(
        title: const Text('Create Resignation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFieldItem(
                label: 'Notice Period (days)',
                controller: _noticePeriodController,
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              DateTimePickerField(
                label: 'Leave Date',
                controller: _leaveDateController,
              ),
              SizedBox(height: 16.h),
              TextFieldItem(
                label: 'Note',
                controller: _noteController,
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: _pickDocument,
                child: Text(_base64Document == null ? 'Upload Document' : 'Document Selected'),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: provider.state == AppRequesState.loading ? null : _submit,
                child: provider.state == AppRequesState.loading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class TextFieldItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const TextFieldItem({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}


class DateTimePickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const DateTimePickerField({
    super.key,
    required this.label,
    required this.controller,
  });

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        ),
      ),
    );
  }
}
