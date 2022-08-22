import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/local/async_state.dart';
import 'submit_button.dart';

class FormPage extends StatelessWidget {
  final String title;
  final double cardWidth;
  final double cardHeight;
  final GlobalKey<FormState> formKey;
  final Widget fields;

  const FormPage({
    Key? key,
    required this.fields,
    required this.formKey,
    required this.title,
    this.cardWidth = 400,
    this.cardHeight = 400,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Theme.of(context).primaryColor, Colors.purple],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Card(
            child: SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 22),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 25),
                            fields,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
