import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'rectangular_card.dart';

class RectangularCardData {
  final String title;
  final IconData icon;
  final int? badgeCount;
  final VoidCallback onTap;

  const RectangularCardData({
    required this.title,
    required this.icon,
    this.badgeCount,
    required this.onTap, required String route,
  });
}

class RectangularCardsGrid extends StatelessWidget {
  final List<RectangularCardData> cards;

  const RectangularCardsGrid({super.key, required this.cards, required int crossAxisCount, required double childAspectRatio, required double mainAxisSpacing, required double crossAxisSpacing});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: cards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 16.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final item = cards[index];
        return RectangularCard(
          title: item.title,
          icon: item.icon,
          badgeCount: item.badgeCount,
          onTap: item.onTap,
        );
      },
    );
  }
}
