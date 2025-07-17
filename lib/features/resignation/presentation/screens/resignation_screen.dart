// lib/features/resignation/presentation/screens/resignation_screen.dart

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ResignationScreen extends StatefulWidget {
  const ResignationScreen({super.key});

  @override
  State<ResignationScreen> createState() => _ResignationScreenState();
}

class _ResignationScreenState extends State<ResignationScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<ResignationProvider>(context, listen: false).fetchResignationGroups();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resignation',
          style: TextStyle(fontSize: 20.sp),
        ),
          actions: [
    IconButton(
      icon: Icon(Icons.add, size: 24.sp),
      tooltip: 'Create Resignation',
      onPressed: () {
        // Navigate to Create Resignation screen
           context.push('/home/resignations/createResignations');
      },
    ),
    SizedBox(width: 8.w),
  ],
      ),
      body: Consumer<ResignationProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case AppRequesState.loading:
              return const Center(child: CircularProgressIndicator());
            case AppRequesState.error:
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0.w),
                  child: Text(
                    provider.errorMessage ?? 'Something went wrong',
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            case AppRequesState.loaded:
              return ListView.builder(
  itemCount: provider.resignationGroups.length,
  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
  itemBuilder: (context, index) {
    final group = provider.resignationGroups[index];

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        title: Text(
          group.description,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            group.resignationCount.toString(),
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () {
          // يمكنك وضع التنقل هنا لاحقًا
        },
      ),
    );
  },
)
;
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
