import 'package:flutter/material.dart';

class ClosedQuestion extends StatefulWidget {
   ClosedQuestion({
    Key? key,
    required bool value,
    required void Function(bool?) onChange,
    required String question,
  })  :
        _value = value,
        _onChange = onChange,
        _question = question,
        super(key: key);

  bool _value;
  final void Function(bool?) _onChange;
  final String _question;

  @override
  State<ClosedQuestion> createState() => _ClosedQuestionState();
}

class _ClosedQuestionState extends State<ClosedQuestion> {
  var _groupValue = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget._question),
        const SizedBox(width: 25),
        Text('Yes'),
        Radio<bool>(
          value: true,
          activeColor: Theme.of(context).primaryColor, groupValue: _groupValue, onChanged: _localOnChange
        ),
        SizedBox(width: 16,),
        Text('No'),
        Radio<bool>(
          value: false,
          activeColor: Theme.of(context).primaryColor, groupValue: _groupValue, onChanged: _localOnChange
        ),
      ],
    );
  }

  _localOnChange(bool? value){
    widget._onChange(value);
    setState(() {
      _groupValue = value!;
    });
  }
}
