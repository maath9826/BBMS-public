import 'package:flutter/material.dart';

class SecondaryTab extends StatelessWidget {
  final Widget content;
  const SecondaryTab({Key? key, required this.content,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
