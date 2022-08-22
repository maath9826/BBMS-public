import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String hint;
  final bool isOptional;
  final List<T> list;
  final T? selectedItem;
  final void Function(Object?)? onChange;
  const CustomDropdown({
    Key? key,
    required this.hint,
    this.isOptional = false,
    required this.list,
    this.selectedItem,
    required this.onChange,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late FocusNode focusNode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode = FocusNode();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if(widget.isOptional) return null;

        if (value == null) return 'This field is required';
      },
      menuMaxHeight: 200,
      alignment: Alignment.bottomCenter,
      isExpanded: true,
      focusNode: focusNode,
      onTap: ()=>focusNode.requestFocus(),
      hint: Text('${widget.hint} ${widget.isOptional ? '(optional)' : ''}'),
      items: widget.list
          .map(
            (el) => DropdownMenuItem(
              child: Text(el.runtimeType == String? el as String : el.toString().split('.')[1]),
              value: el,
            ),
          )
          .toList(),
      value: widget.selectedItem,
      onChanged: widget.onChange,
    );
  }
}
