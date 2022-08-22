import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/examining_tab/widgets/examining_tab_section.dart';
import 'package:flutter/material.dart';

class ExaminingTabSectionsWrapper extends StatelessWidget {
  final List<ExaminingTabSection> sections;
  const ExaminingTabSectionsWrapper({Key? key, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sections.map((section) => Column(mainAxisSize: MainAxisSize.min,children: [
        section,
        if(sections.indexOf(section) < sections.length - 1)
          Divider(height: 50,),
      ],)).toList(),
    );
  }
}
