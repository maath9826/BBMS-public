import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../helpers/constant_variables.dart';
import '../helpers/enums.dart';
import '../helpers/functions.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
    required TextEditingController searchController,
    required final void Function(String) onSubmitted,
    MaskTextInputFormatter? maskFormatter,
    MaskType? maskType,
    double width = 300,
  })  : _searchController = searchController,
        _onSubmitted = onSubmitted,
        _width = width,
        _maskFormatter = maskFormatter,
        _maskType = maskType,
        super(key: key);

  final void Function(String) _onSubmitted;

  final double _width;

  final TextEditingController _searchController;

  final MaskTextInputFormatter? _maskFormatter;

  final MaskType? _maskType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: searchButtonHeight,
      child: TextField(
        inputFormatters: isAssigned(_maskFormatter) ? [_maskFormatter!] : null,
        onSubmitted: _onSubmitted,
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
          hintText: isAssigned(_maskType) ? getMaskHint(_maskType!) : null,
        ),
      ),
    );
  }
}
