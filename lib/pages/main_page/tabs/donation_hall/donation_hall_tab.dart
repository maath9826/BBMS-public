import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/blood_classification_tab.dart';
import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/blood_drawing_tab.dart';
import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/consultation_tab.dart';
import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/hemoglobin_lab_tab.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/roles.dart';
import '../../../../models/local/tab_data.dart';
import '../../../../widgets/main_tab.dart';
import 'tabs/examining_tab/examining_tab.dart';

class DonationHallTab extends StatelessWidget {
  DonationHallTab({Key? key}) : super(key: key);

  final _secondaryTabsData = [
    if (isConsultant || isAdmin)
      TabData(
        tab: const Tab(
          text: 'Consultation',
        ),
        view: ConsultationTab(),
      ),
    if (isHbLabEmployee || isAdmin)
    TabData(
        tab: const Tab(
          text: 'Hb Lab',
        ),
        view: const HemoglobinLabTab(),
      ),
    if (isBloodClassificationEmployee || isAdmin)
    TabData(
        tab: const Tab(
          text: 'Blood Classification',
        ),
        view: const BloodClassificationTab(),
      ),
    if (isExaminer || isAdmin)
    TabData(
        tab: const Tab(
          text: 'Examining',
        ),
        view: const Examining(),
      ),
    if (isPhlebotomist || isAdmin)
    TabData(
        tab: const Tab(
          text: 'Blood Drawing',
        ),
        view: const BloodDrawingTab(),
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainTab(secondaryTabsData: _secondaryTabsData,);
  }
}
