import 'dart:async';


import 'package:blood_bank_system/helpers/functions.dart';
import 'package:flutter/material.dart';

import '../models/client/client.dart';

class CustomAutoCompleteField<T extends Object> extends StatelessWidget {
  final FutureOr<Iterable<T>> Function(TextEditingValue)
      optionsBuilder;
  final bool Function(T)? canBeTapped;
  final void Function(T) onSelected;
  final String Function(T) optionLabel;
  final Color? Function(T) getColor;
  const CustomAutoCompleteField(
      {Key? key,
      required this.optionsBuilder,
      required this.onSelected,
      required this.getColor,
      required this.optionLabel,
      this.canBeTapped,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) => Autocomplete<T>(

        fieldViewBuilder: (ctx, textEditingController, focusNode, show) =>
            AutoCompleteField(
          controller: textEditingController,
          focusNode: focusNode,
        ),
        optionsBuilder: optionsBuilder,
        displayStringForOption: optionLabel,
        onSelected: onSelected,
        optionsViewBuilder: (context, onSelected, options) {
          final _options = options.toList();
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              child: SizedBox(
                height: _options.length * 50,
                width: constraints.biggest.width,
                child: ListView(
                  children: _options
                      .map((option) => ListTile(
                            onTap: isAssigned(canBeTapped) && !canBeTapped!(option) ? null : () => onSelected(option),
                            title: Text(optionLabel(option)),
                    tileColor: getColor(option),
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AutoCompleteField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const AutoCompleteField(
      {Key? key, required this.controller, required this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
    );
  }
}
