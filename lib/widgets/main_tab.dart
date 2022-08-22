import 'package:blood_bank_system/models/local/tab_data.dart';
import 'package:blood_bank_system/widgets/custom_secondary_tab_bar.dart';
import 'package:flutter/material.dart';

import '../helpers/constant_variables.dart';

class MainTab extends StatefulWidget {
  final List<TabData> secondaryTabsData;
  const MainTab({Key? key, required this.secondaryTabsData,}) : super(key: key);

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin{
  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: widget.secondaryTabsData.length, vsync: this);
    _tabController.index = 0;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSecondaryTabBar(
          controller: _tabController,
          tabs: widget.secondaryTabsData
              .map(
                  (tabData) => tabData.tab
          )
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.secondaryTabsData.map((tabData) => tabData.view).toList(),
          ),
        ),
      ],
    );
  }
}
