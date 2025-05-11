import 'package:flutter/material.dart';
import 'package:trendiq/constants/fonts.dart';
import 'package:trendiq/services/app_colors.dart';

class AboutUsTabBar extends StatefulWidget {
  const AboutUsTabBar({super.key});

  @override
  State<AboutUsTabBar> createState() => _AboutUsTabBarState();
}

class _AboutUsTabBarState extends State<AboutUsTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, Map<String, String>> goals = {
    'Our Mission': {
      'title': "Empowering Bold Expression",
      'subtitle':
          "At TrendIQ, our mission is to empower individuals to express themselves boldly through fashion. We believe that everyone deserves to stand out and feel confident, regardless of budget or body type. That's why we're committed to offering a diverse range of sizes, styles, and price points to ensure that there's something for every fashion rebel in our collection.",
    },
    'Sustainability': {
      'title': "Fashion with a Conscience",
      'subtitle':
          "We're passionate about fierce fashion, but we're also committed to reducing our environmental impact. That's why we're taking bold steps to incorporate more sustainable practices into our business. From using eco-friendly materials in our packaging to partnering with ethical manufacturers, we're constantly looking for ways to make fashion more sustainable without compromising on style.",
    },
    'Our Team': {
      'title': "Fashion Mavericks",
      'subtitle':
          "Our diverse team of fashion mavericks, tech innovators, and customer service professionals work tirelessly to bring you the most daring shopping experience possible. From our buyers who scour the globe for the latest trends to our developers who ensure a smooth online shopping experience, every member of the TrendIQ family is dedicated to helping you look bold and feel confident.",
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: appColors.tertiary
          ),
          height: 50,
          child: TabBar(
            controller: _tabController,
            labelColor: appColors.white,
            unselectedLabelColor: appColors.onTertiary,
            indicator: BoxDecoration(
              color: appColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            labelPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: commonTextStyle(
              fontSize: 14,
              color: appColors.white,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: commonTextStyle(
              fontSize: 12,
              color: appColors.black,
              fontWeight: FontWeight.w500,
            ),
            dividerColor: Colors.transparent,
            tabs: goals.keys.map((e) => Tab(text: e),).toList() as List<Widget>,
          ),
        ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Our Mission Tab
              _buildContentTab('Our Mission'),

              // Sustainability Tab
              _buildContentTab('Sustainability'),

              // Our Team Tab
              _buildContentTab('Our Team'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentTab(String tabTitle) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(12),
          color: appColors.tertiaryContainer
        ),
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goals[tabTitle]?["title"] ?? "-",
              style: commonTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: appColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              goals[tabTitle]?["subtitle"] ?? "-",
              style: commonTextStyle(
                fontSize: 14,
                height: 1.5,
                color: appColors.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
