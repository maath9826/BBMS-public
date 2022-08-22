import 'dart:async';
import 'dart:html' as html;

import 'package:blood_bank_system/helpers/constant_variables.dart';
import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/helpers/mixins/stage_mixin.dart';
import 'package:blood_bank_system/models/bag/bag.dart';
import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/services/clients_service.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:blood_bank_system/widgets/custom_dropdown.dart';
import 'package:blood_bank_system/widgets/custom_field.dart';
import 'package:blood_bank_system/widgets/search_field.dart';
import 'package:blood_bank_system/widgets/secondary_tab.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../helpers/functions.dart';
import '../../../../../helpers/service.dart';
import '../../../../../helpers/statics.dart';
import '../../../../../models/client/client.dart';
import '../../../../../widgets/custom_auto_completet_field.dart';
import '../../../../../widgets/info_card.dart';
import '../../../../../widgets/submit_button.dart';

class BloodDrawingTab extends StatefulWidget {
  const BloodDrawingTab({Key? key}) : super(key: key);

  @override
  State<BloodDrawingTab> createState() => _BloodDrawingTabState();
}

class _BloodDrawingTabState extends State<BloodDrawingTab>
    with StageMixin<BloodDrawingTab> {
  final _numberOfBagsController = TextEditingController();

  final List<Bag> _bags = [];

  var _isLoadingBags = false;

  @override
  Widget build(BuildContext context) {
    return isAssigned(donorForm)
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            child: Column(
              children: [
                InfoCard(client: client!, donorForm: donorForm!),
                const SizedBox(height: 8),
                canUse(DonorFormStage.bloodDrawing)
                    ? _buildBagsCard()
                    : Column(
                        children: [
                          buildChip(DonorFormStage.bloodDrawing),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.only(
                                  right: 26,
                                  left: 10,
                                  top: 10,
                                  bottom: 10,
                                ),
                              ),
                            ),
                            onPressed: makeNullData,
                            icon: const Icon(Icons.keyboard_arrow_left),
                            label: const Text('Back'),
                          ),
                        ],
                      ),
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: SizedBox(
                  width: 500,
                  child: buildCodeFieldCard(),
                ),
              ),
            ],
          );
  }

  void _onSubmitBags() async {
    // if(!isAssigned(_selectedBloodGroup)) return;
    _fillBags();

    ///on empty or not number
    if (_bags.isEmpty) {
      return;
    }

    ///show loading
    setState(() {
      _isLoadingBags = true;
    });

    ///update donorForm
    await Service.bags.addAll(
      dataList: _bags.map((bag) => bag.toJson()).toList(),
    );
    await goNext(numberOfBags: double.parse(_numberOfBagsController.text));

    ///hide loading
    setState(() {
      _isLoadingBags = false;
    });
  }

  _buildBagsCard() {
    return SizedBox(
      width: 500,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(width: 500),
              CustomField(
                controller: _numberOfBagsController,
                label: 'bags number',
              ),
              // const SizedBox(height: 16),
              // CustomDropdown(
              //   list: bloodGroups,
              //   selectedItem: _selectedBloodGroup,
              //   onChange: (bloodGroup) {
              //     _selectedBloodGroup = (bloodGroup as String);
              //   },
              //   hint: 'select a blood group',
              // ),
              const SizedBox(height: 30),
              _isLoadingBags
                  ? const CircularProgressIndicator()
                  : SubmitButton(
                      onPressed: _onSubmitBags,
                    )
            ],
          ),
        ),
      ),
    );
  }

  void _fillBags() {
    _bags.clear();
    _bags.addAll(
      List.filled(
        int.parse(_numberOfBagsController.text),
        Bag(
          bloodGroup: client!.bloodGroup!,
          donorFormId: donorFormId!,
          creationDate: DateTime.now(),
          clientBirthDate: client!.birthDate,
          clientName: client!.name,
        ),
      ),
    );
  }
}
