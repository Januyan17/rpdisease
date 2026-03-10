// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:rpskindisease/constants/colors.dart';
import 'package:rpskindisease/mixin/responsive-layout-mixin.dart';
import 'package:rpskindisease/screen/HomeScreen/CarousalSlider.dart';
import 'package:rpskindisease/widgets/ScreenWidgets/dogswipewidget.dart';
import 'package:rpskindisease/utils/spacers/screen_size_calculator.dart';

/// Optional callback to navigate to the Disease tab (e.g. from category tap).
typedef OnNavigateToDisease = void Function();

class HomeScreenPage extends StatelessWidget with ResponsiveLayoutMixin {
  HomeScreenPage({super.key, this.onNavigateToDisease});

  final OnNavigateToDisease? onNavigateToDisease;

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final double width = getScreenWidth(context);
    final double height = getScreenHeight(context);
    final bool isCompact = width < 360 || height < 640;
    final double horizontalPadding = isCompact ? 16 : 20;
    final double sectionSpacing = isCompact ? 20 : 24;
    final double titleSize = isCompact ? 20 : 22;
    final double bodySize = isCompact ? 13 : 14;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: sectionSpacing * 0.8),

                // —— Header: greeting + search ——
                _buildHeader(context, isCompact, bodySize),

                SizedBox(height: sectionSpacing),

                // —— Hero title ——
                _buildHeroTitle(context, titleSize, bodySize),

                SizedBox(height: sectionSpacing),

                // —— Carousel ——
                _buildCarouselSection(context, height, width),

                SizedBox(height: sectionSpacing),

                // —— Quick actions / categories ——
                _buildSectionTitle(
                  context,
                  "Quick actions",
                  isCompact ? 16 : 17,
                ),
                SizedBox(height: 10),
                _buildCategoriesGrid(
                  context,
                  isCompact,
                  bodySize,
                  onNavigateToDisease,
                ),

                SizedBox(height: sectionSpacing),

                // —— My Pets ——
                _buildPetsSection(context, isCompact, bodySize),

                SizedBox(height: sectionSpacing * 1.5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isCompact,
    double bodySize,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back",
                style: TextStyle(
                  fontSize: isCompact ? 12 : 13,
                  fontWeight: FontWeight.w500,
                  color: primaryGreyColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Pet Care Assistant",
                style: TextStyle(
                  fontSize: isCompact ? 18 : 20,
                  fontWeight: FontWeight.w700,
                  color: primaryBlackColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        _buildSearchChip(context, bodySize),
      ],
    );
  }

  Widget _buildSearchChip(BuildContext context, double bodySize) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryBackGroundColor.withOpacity(0.8)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_rounded, size: 20, color: primaryGreyColor),
              SizedBox(width: 6),
              Text(
                "Search",
                style: TextStyle(
                  fontSize: bodySize,
                  color: primaryGreyColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTitle(
    BuildContext context,
    double titleSize,
    double bodySize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dog skin disease diagnosis",
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: primaryBlackColor,
            height: 1.25,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "A new era in veterinary dermatology — powered by ML.",
          style: TextStyle(
            fontSize: bodySize,
            fontWeight: FontWeight.w400,
            color: primaryGreyColor,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselSection(
    BuildContext context,
    double height,
    double width,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: height * 0.20,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomCarouselSlider(height: height * 0.20),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: primaryBlackColor,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    bool isCompact,
    double bodySize,
    OnNavigateToDisease? onNavigateToDisease,
  ) {
    final List<_CategoryItem> items = [
      _CategoryItem(
        title: "Skin diagnosis",
        subtitle: "Check skin condition",
        icon: Icons.medical_information_outlined,
        color: paleColor3,
        onTap: onNavigateToDisease,
      ),
      _CategoryItem(
        title: "Food analysis",
        subtitle: "Suitable food for your dog",
        icon: Icons.restaurant_outlined,
        color: paleColor1,
        onTap: onNavigateToDisease,
      ),
      _CategoryItem(
        title: "Medicine",
        subtitle: "Treatment suggestions",
        icon: Icons.medication_outlined,
        color: paleColor4,
        onTap: onNavigateToDisease,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = (constraints.maxWidth - 16) / 3;
        final double cardHeight = isCompact ? 100 : 108;
        return SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return _CategoryCard(
                item: item,
                width: cardWidth,
                height: cardHeight,
                bodySize: bodySize,
                isCompact: isCompact,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPetsSection(
    BuildContext context,
    bool isCompact,
    double bodySize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSectionTitle(
              context,
              "My pets",
              isCompact ? 16 : 17,
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.black45,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "View all",
                style: TextStyle(
                  fontSize: bodySize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        DogSwipeScreen(),
      ],
    );
  }
}

class _CategoryItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final OnNavigateToDisease? onTap;

  _CategoryItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  final double width;
  final double height;
  final double bodySize;
  final bool isCompact;

  const _CategoryCard({
    required this.item,
    required this.width,
    required this.height,
    required this.bodySize,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color.withOpacity(0.85),
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: item.onTap != null
            ? () {
                item.onTap!();
              }
            : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(isCompact ? 10 : 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  item.icon,
                  size: isCompact ? 20 : 22,
                  color: primaryBlackColor,
                ),
              ),
              Spacer(),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: isCompact ? 11 : 12,
                  fontWeight: FontWeight.w700,
                  color: primaryBlackColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: isCompact ? 10 : 11,
                  fontWeight: FontWeight.w400,
                  color: primaryGreyColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
