import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flex_ops_hr/features/iqama/presentation/controller/iqama_provider.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/iqama_entities.dart';

class IqamaRenewalsScreen extends StatefulWidget {
  const IqamaRenewalsScreen({super.key});

  @override
  State<IqamaRenewalsScreen> createState() => _IqamaRenewalsScreenState();
}

class _IqamaRenewalsScreenState extends State<IqamaRenewalsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<IqamaProvider>().fetchIqamaRenewalGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Iqama Renewals',
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 20.sp),
        ),
        actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            context.push('/home/iqama-renewals/createIqamaRenewal');
          },
        ),
      ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Consumer<IqamaProvider>(
          builder: (context, provider, _) {
            if (provider.state == AppRequesState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state == AppRequesState.error) {
              return Center(
                child: Text(
                  provider.errorMessage ?? 'An error occurred',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              );
            } else if (provider.iqamaGroups.isEmpty) {
              return Center(
                child: Text(
                  'No Iqama renewals found.',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }

            return ListView.separated(
              itemCount: provider.iqamaGroups.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final group = provider.iqamaGroups[index];
                return _IqamaStatusCard(group: group);
              },
            );
          },
        ),
      ),
    );
  }
}

class _IqamaStatusCard extends StatelessWidget {
  final IqamaRenewalGroup group;

  const _IqamaStatusCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = group.renewIqamaCount;

    return InkWell(
      onTap: () {
        if (count > 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => IqamaGroupDetailsScreen(group: group),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No records in ${group.description}.'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              group.description,
              style: theme.textTheme.bodyLarge,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IqamaGroupDetailsScreen extends StatelessWidget {
  final IqamaRenewalGroup group;

  const IqamaGroupDetailsScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = group.renewIqamas;

    return Scaffold(
      appBar: AppBar(
        title: Text(group.description, style: theme.textTheme.titleLarge),
      ),
      body: items.isEmpty
          ? const Center(child: Text("No records."))
          : ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final iqama = items[index];
                return Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: theme.cardColor,
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(iqama.employeeName, style: theme.textTheme.titleMedium),
                      SizedBox(height: 4.h),
                      Text("New Iqama: ${iqama.newIqamaId ?? '-'}",
                          style: theme.textTheme.bodySmall),
                      if (iqama.note != null)
                        Text("Note: ${iqama.note}", style: theme.textTheme.bodySmall),
                      if (iqama.state != null)
                        Text("State: ${iqama.state}", style: theme.textTheme.bodySmall),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
