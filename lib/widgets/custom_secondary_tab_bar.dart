import 'package:flutter/material.dart';

import '../helpers/constant_variables.dart';
import '../services/auth_service.dart';

class CustomSecondaryTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;

  const CustomSecondaryTabBar({
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: pagePadding),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: tabs.length * 200,
            height: 40,
            child: TabBar(
              labelColor: Colors.white,
              controller: controller,
              tabs: tabs,
            ),
          ),
        ],
      ),
    );
  }
}
