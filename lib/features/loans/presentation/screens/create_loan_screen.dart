// lib/features/loans/presentation/screens/create_loan_screen.dart

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/loans/domain/usecases/create_loan_usecase.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Loan"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 16.h),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Loan Amount'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter amount' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _installmentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Installments'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter installments' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _paymentDateController,
                decoration: const InputDecoration(labelText: 'Payment Date (YYYY-MM-DD)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter payment date' : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Reason'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter reason' : null,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: loanProvider.state == AppRequesState.loading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final params = CreateLoanParams(
                            loanAmount: double.parse(_amountController.text),
                            installment: int.parse(_installmentController.text),
                            paymentDate: _paymentDateController.text,
                            reason: _reasonController.text,
                          );

                          await loanProvider.createLoan(params);

                          if (loanProvider.state == AppRequesState.loaded &&
                              loanProvider.loanMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text(loanProvider.loanMessage!.message),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (loanProvider.state == AppRequesState.error &&
                              loanProvider.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loanProvider.errorMessage!),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                child: loanProvider.state == AppRequesState.loading
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
