import 'dart:io';

//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/local/async_state.dart';
import '../services/auth_service.dart';
import '../widgets/custom_field.dart';
import '../widgets/form_page.dart';
import '../widgets/submit_button.dart';

//

class LogInPage extends StatefulWidget {
  static const routeName = '/LogInPage';

  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();

  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  final asyncState = AsyncState();

  late final Widget _fields;

  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: 'Login',
      fields: Column(
        children: [
          CustomField(
            label: 'Username',
            controller: _userController,
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (value) {
              _onSubmit();
            },
          ),
          const SizedBox(height: 15),
          CustomField(
            label: 'Password',
            controller: _passwordController,
            isPassword: true,
            onSubmitted: (value) {
              _onSubmit();
            },
          ),
          const SizedBox(height: 25),
          _isLoading ? const CircularProgressIndicator() : SubmitButton(onPressed: _onSubmit,),
        ],
      ),
      formKey: _formKey,
      cardHeight: 300,
    );
  }

  _onSubmit() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _logIn();
    }
  }

  _logIn() async {

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService().login(
        username: _userController.text,
        password: _passwordController.text,
      );
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('login failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'))
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }

  }
}
