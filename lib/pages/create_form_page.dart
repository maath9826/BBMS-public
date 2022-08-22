import 'dart:async';

import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/models/donor_form/examining_form/examining_form.dart';
import 'package:blood_bank_system/models/local/async_state.dart';
import 'package:blood_bank_system/pages/create_form_and_client_page.dart';
import 'package:blood_bank_system/pages/main_page/main_page.dart';
import 'package:blood_bank_system/services/clients_service.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:blood_bank_system/widgets/custom_auto_completet_field.dart';
import 'package:blood_bank_system/widgets/form_page.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/enums.dart';
import '../helpers/functions.dart';
import '../models/client/client.dart';
import '../widgets/submit_button.dart';

class CreateFormPage extends StatefulWidget {
  static const routeName = '/CreateForm';

  const CreateFormPage({Key? key}) : super(key: key);

  @override
  State<CreateFormPage> createState() => _CreateFormPageState();
}

class _CreateFormPageState extends State<CreateFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _clientsService = ClientsService();

  FullClient? _selectedFullClient;

  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late DonorFormsService _donorFormsServiceProvider;

  @override
  Widget build(BuildContext context) {
    _donorFormsServiceProvider = Provider.of<DonorFormsService>(context,);
    return FormPage(
        fields: Column(
          children: [
            CustomAutoCompleteField<FullClient>(
              canBeTapped: _canBeTapped,
              getColor: _getColor,
              optionsBuilder: _optionsBuilder,
              onSelected: _onSelected,
              optionLabel: (FullClient fullClient) =>
              fullClient.client.name,
            ),
            const SizedBox(height: 25,),
            _isLoading ? const CircularProgressIndicator() : SubmitButton(onPressed: _onSubmit,),
            const SizedBox(height: 35,),
            TextButton(onPressed: ()=>Navigator.of(context).pushReplacementNamed(CreateFormAndClientPage.routeName), child: const Text('Or create new donor'),),
          ],
        ),
        formKey: _formKey,
        title: 'Select Donor',
    );
  }

  _onSubmit() async {
    if(!isAssigned(_selectedFullClient)) return;

    setState(() {
      _isLoading = true;
    });

    var _donorForm = DonorForm(
      code: faker.randomGenerator.integer(1000000000,min: 100000000).toString(),
      creationDate: DateTime.now(),
      clientId: _selectedFullClient!.id,
      examiningForm: ExaminingForm(),
    );

    var doc = await _donorFormsServiceProvider.add(_donorForm);

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }

  FutureOr<Iterable<FullClient>> _optionsBuilder(
      TextEditingValue textEditingValue) async {
    return await _clientsService
        .getList(
          limit: 5,
          searchText: textEditingValue.text,
        )
        .then((snapshot) => snapshot.docs
            .map(
              (doc) {
                var client = Client.fromJson(doc.data());
                return FullClient(
                  client: client,
                  id: doc.id,
                  name: client.name,
                );
              },
            )
            .toList());
  }

  void _onSelected(FullClient fullClient) async {
    _selectedFullClient = fullClient;
  }

  Color? _getColor(FullClient fullClient) {
    if(_isBanned(fullClient)) return Colors.redAccent;
    return null;
  }

  bool _canBeTapped(FullClient fullClient) {
    if(_isBanned(fullClient)) return false;
    return true;
  }

  _isBanned(FullClient fullClient) => fullClient.client.status == ClientStatus.banned;
}
