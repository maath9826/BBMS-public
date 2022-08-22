import 'package:flutter/material.dart';

import '../helpers/constant_variables.dart';
import '../services/auth_service.dart';

class CustomMainTabBar extends StatelessWidget with PreferredSizeWidget {
  final TabController controller;
  final List<Widget> tabs;

  const CustomMainTabBar({
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: pagePadding),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: tabs.length * 200,
            height: 60,
            child: TabBar(
              indicator: BoxDecoration(color: Theme.of(context).primaryColor),
              labelColor: Colors.white,
              labelStyle: const TextStyle(fontSize: 16),
              controller: controller,
              tabs: tabs,
            ),
          ),
          ElevatedButton(
            onPressed: () => AuthService().logout(),
            child: const Text('logout'),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
