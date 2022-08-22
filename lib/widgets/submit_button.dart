import 'package:blood_bank_system/helpers/functions.dart';
import 'package:flutter/material.dart';

import '../models/local/async_state.dart';

class SubmitButton extends StatefulWidget {
  final void Function()? onPressed;
  final Color? color;
  final String? title;
  const SubmitButton({Key? key, required this.onPressed,this.title, this.color,}) : super(key: key);

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(20)),backgroundColor: isAssigned(widget.color) ? MaterialStateProperty.all(widget.color!) : null),
        onPressed: widget.onPressed,
        child: Text(widget.title == null ?'Submit' : widget.title!),
      ),
    );
  }
}
