// lib/features/loans/presentation/screens/create_loan_screen.dart

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:flex_ops_hr/components/app_text_field.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';

class CreateLoanScreen extends StatefulWidget {
  const CreateLoanScreen({super.key});

  @override
  State<CreateLoanScreen> createState() => _CreateLoanScreenState();
}

class _CreateLoanScreenState extends State<CreateLoanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _installmentController = TextEditingController();
  final TextEditingController _paymentDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
                foregroundColor:
                    AppColors.primaryBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _paymentDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _installmentController.dispose();
    _paymentDateController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          "Request New Loan",
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
                controller: _amountController,
                keyboardType: TextInputType.number,
                labelText: 'Loan Amount',
                hintText: 'e.g., 5000',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the loan amount'
                    : null,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _installmentController,
                keyboardType: TextInputType.number,
                labelText: 'Number of Installments',
                hintText: 'e.g., 12',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the number of installments'
                    : null,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _paymentDateController,
                labelText: 'First Payment Date',
                hintText: 'YYYY-MM-DD',
                readOnly: true,
                onTap: () => _selectDate(context),
                suffixIcon:
                    Icon(Icons.calendar_today, color: AppColors.primaryBlue),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select the payment date'
                    : null,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _reasonController,
                labelText: 'Reason for Loan',
                hintText: 'e.g., House Renovation',
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the reason for the loan'
                    : null,
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loanProvider.state == AppRequesState.loading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final params = CreateLoanParams(
                              loanAmount: double.parse(_amountController.text),
                              installment:
                                  int.parse(_installmentController.text),
                              paymentDate: _paymentDateController.text,
                              reason: _reasonController.text,
                            );

                            await loanProvider.createLoan(params);

                            if (loanProvider.state == AppRequesState.loaded) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      loanProvider.loanMessage?.message ??
                                          'Loan requested successfully!'),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                              // Navigator.of(context).pop();
                            } else if (loanProvider.state ==
                                AppRequesState.error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loanProvider.errorMessage ??
                                      'An error occurred.'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 4,
                  ),
                  child: loanProvider.state == AppRequesState.loading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Submit Loan Request',
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
