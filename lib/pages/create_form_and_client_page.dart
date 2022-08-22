import 'dart:io';

//
import 'package:blood_bank_system/helpers/constant_variables.dart';
import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/models/donor_form/examining_form/examining_form.dart';
import 'package:blood_bank_system/services/clients_service.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:blood_bank_system/widgets/custom_dropdown.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/converters.dart';
import '../helpers/enums.dart';
import '../models/client/client.dart';
import '../models/local/async_state.dart';
import '../services/auth_service.dart';
import '../widgets/custom_field.dart';
import '../widgets/form_page.dart';
import '../widgets/submit_button.dart';
import '../widgets/three_fields_date.dart';

//

class CreateFormAndClientPage extends StatefulWidget {
  static const routeName = '/CreateFormAndClientPage';

  const CreateFormAndClientPage({Key? key}) : super(key: key);

  @override
  _CreateFormAndClientPageState createState() =>
      _CreateFormAndClientPageState();
}

class _CreateFormAndClientPageState extends State<CreateFormAndClientPage> {
  String? _selectedProvince;
  Gender? _selectedGender;

  var _isPublic = false;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  DateTime? _birthDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _validateAllFields() {
    if (_formKey.currentState!.validate() &&
        _selectedGender != null &&
        _selectedProvince != null &&
        _birthDate != null) {
      return true;
    } else {
      return false;
    }
  }

  var _isLoading = false;

  late DonorFormsService _donorFormsServiceProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _donorFormsServiceProvider = Provider.of<DonorFormsService>(context);
    return FormPage(
      title: 'Login',
      formKey: _formKey,
      cardHeight: 600,
      fields: SingleChildScrollView(
        child: Column(
          children: [
            CustomField(
              controller: _nameController,
              label: 'name',
            ),
            const SizedBox(height: 16),
            CustomDropdown<Gender>(
              hint: 'select a gender',
              list: Gender.values,
              onChange: (value) {
                _selectedGender = value as Gender;
              },
            ),
            const SizedBox(height: 16),
            ThreeFieldsDate(
              title: 'Birth date',
              dayController: _dayController,
              monthController: _monthController,
              yearController: _yearController,
              onChange: (date) {
                _birthDate = date;
              },
            ),
            const SizedBox(height: 16),
            CustomDropdown(
                hint: 'select a province',
                list: provinces,
                onChange: (value) {
                  _selectedProvince = value as String;
                }),
            const SizedBox(height: 16),
            CustomField(
              controller: _cityController,
              label: 'city',
            ),
            const SizedBox(
              height: 16,
            ),
            CustomField(
              controller: _phoneNumberController,
              label: 'phone number',
              keyboardType: TextInputType.phone,
              isOptional: true,
            ),
            const SizedBox(
              height: 16,
            ),
            CheckboxListTile(value: _isPublic, onChanged: (value)=>setState(() {
              _isPublic = value!;
            }),title: Text('Make Public Donor')),
            const SizedBox(
              height: 30,
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : SubmitButton(
              onPressed: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  _onSubmit() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState != null && _validateAllFields()) {
      try {
        final _clientSnapshot = await ClientsService().add(
          Client(
            name: _nameController.text.trim(),
            phoneNumber: _phoneNumberController.text.trim(),
            province: _selectedProvince!,
            gender: _selectedGender!,
            city: _cityController.text.trim(),
            birthDate: _birthDate!,
            creationDate: DateTime.now(),
            isPublic: _isPublic,
          ),
        );

        final _donorFormSnapshot = await _donorFormsServiceProvider.add(
          DonorForm(
            clientId: _clientSnapshot.id,
            creationDate: DateTime.now(),
            code: faker.randomGenerator
                .integer(1000000000, min: 100000000)
                .toString(),
            examiningForm: ExaminingForm(),
          ),
        );
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      } catch (e, s) {
        print(e);
        print(s);
        setState(() {
          _isLoading = false;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
}
