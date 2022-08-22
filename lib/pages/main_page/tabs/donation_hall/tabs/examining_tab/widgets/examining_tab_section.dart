import 'package:flutter/material.dart';

class ExaminingTabSection extends StatelessWidget {
  final List<List<Widget>> data;

  const ExaminingTabSection({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: data
          .map(
            (widgetList) => Row(crossAxisAlignment: CrossAxisAlignment.center,
              children: widgetList,
            ),
          )
          .toList(),
    );
  }
}
