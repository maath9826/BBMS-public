import 'package:blood_bank_system/helpers/statics.dart';
import 'package:blood_bank_system/models/local/tab_data.dart';
import 'package:blood_bank_system/pages/main_page/tabs/diseases_detection_tab.dart';
import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/donation_hall_tab.dart';
import 'package:blood_bank_system/pages/main_page/tabs/storage_tab.dart';
import 'package:blood_bank_system/pages/main_page/tabs/temporary_storage_tab/temporary_storage_tab.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helpers/roles.dart';
import '../../models/local/content_view.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_tab.dart';
import '../../widgets/custom_main_tab_bar.dart';
import 'tabs/donation_hall/tabs/consultation_tab.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/MainPage';

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final _mainTabsData = [
    if (isDonationHallEmployee)
      TabData(
        tab: const Tab(text: 'Donation Hall'),
        view: DonationHallTab(),
      ),
    if (isDiseasesDetectionEmployee || isAdmin)
      TabData(
        tab: const Tab(text: 'Disease Detection'),
        view: const DiseasesDetectionTab(),
      ),
    if (isTemporaryStorageEmployee || isAdmin)
      TabData(
        tab: const Tab(text: 'Temporary Storage'),
        view: const TemporaryStorageTab(),
      ),
    if (isStorageEmployee || isAdmin)
      TabData(
        tab: const Tab(text: 'Storage'),
        view: const StorageTab(),
      ),
  ];

  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _mainTabsData.length, vsync: this);
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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomMainTabBar(
            controller: _tabController,
            tabs: _mainTabsData.map((tabData) => tabData.tab).toList(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _mainTabsData.map((tabData) => tabData.view).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
