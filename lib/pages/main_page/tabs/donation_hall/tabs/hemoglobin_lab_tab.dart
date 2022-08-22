import 'dart:async';
import 'dart:html' as html;

import 'package:blood_bank_system/helpers/constant_variables.dart';
import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/helpers/mixins/stage_mixin.dart';
import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/services/clients_service.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:blood_bank_system/widgets/custom_field.dart';
import 'package:blood_bank_system/widgets/search_field.dart';
import 'package:blood_bank_system/widgets/secondary_tab.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../helpers/functions.dart';
import '../../../../../helpers/service.dart';
import '../../../../../helpers/statics.dart';
import '../../../../../models/bag/bag.dart';
import '../../../../../models/client/client.dart';
import '../../../../../models/donor_form/examining_form/examining_form.dart';
import '../../../../../widgets/custom_auto_completet_field.dart';
import '../../../../../widgets/info_card.dart';
import '../../../../../widgets/submit_button.dart';

class HemoglobinLabTab extends StatefulWidget {
  const HemoglobinLabTab({Key? key}) : super(key: key);

  @override
  State<HemoglobinLabTab> createState() => _HemoglobinLabTabState();
}

class _HemoglobinLabTabState extends State<HemoglobinLabTab>
    with StageMixin<HemoglobinLabTab> {
  final _hemoglobinController = TextEditingController();

  var _isLoadingHemoglobin = false;

  @override
  Widget build(BuildContext context) {
    return isAssigned(donorForm)
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            child: Column(
              children: [
                InfoCard(client: client!, donorForm: donorForm!),
                const SizedBox(height: 8),
                canUse(DonorFormStage.bloodClassificationAndHbLab)
                    ? _buildHbCard()
                    : Column(
                        children: [
                          buildChip(DonorFormStage.bloodClassificationAndHbLab),
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

  @override
  canUse(DonorFormStage stage){
    return donorForm!.stage == stage && !isAssigned(donorForm!.hb) && donorForm!.status == DonorFormStatus.pending;
  }

  @override
  buildChip(DonorFormStage stage) {
    String message = "";
    if (donorForm!.status != DonorFormStatus.pending) {
      message = isRejected
          ? 'This form has been rejected because of ${generateRejectionCauseMessage(
        cause: donorForm!.rejectionCause!,
        note: donorForm!.rejectionNote,
      )}'
          : 'This Donor Form has been accepted';

      return Chip(
        backgroundColor: isRejected ? Colors.redAccent : Colors.greenAccent,
        label: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    else if (donorForm!.stage != stage) {
      message = 'This Donor Form does not belong to this stage';
      return Chip(
        backgroundColor: Colors.grey,
        label: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    else if(isAssigned(donorForm!.hb)){
      message = 'Hb is already Assigned';
      return Chip(
        backgroundColor: Colors.grey,
        label: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    return const SizedBox();
  }

  void _onSubmitHemoglobin(String text) async {
    ///on empty or not number
    if (text.trim().isEmpty || !isNumeric(text.trim())) {
      return;
    }

    ///show loading
    setState(() {
      _isLoadingHemoglobin = true;
    });

    ///update donorForm
    if (_isWithinRange()) {
      await goNext(hb: double.parse(_hemoglobinController.text),canGoNext: isAssigned(client!.bloodGroup));
    } else {
      await reject(
          cause: RejectionCause.hbDeficiency,
          unbanDate: DateTime.now().add(const Duration(days: UnbanDuration.hbDeficiency)));
    }

    ///hide loading
    setState(() {
      _isLoadingHemoglobin = false;
    });
  }

  @override
  goNext({
    ExaminingForm? examiningForm,
    double? hb,
    double? numberOfBags,
    List<FullBag>? fullBags,
    bool canGoNext = false
  }) async {
    if (!isAssigned(donorFormId)) return print(' data has not been assigned');

    try {
      await Service.donorForms.update(donorFormId!, {
        if (canGoNext) 'stage': enumToString(donorForm!.nextStage),
        if (isAssigned(hb)) 'hb': hb,
      });

      await getFormAndClient(donorForm!.code);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  _isWithinRange() {
    var text = _hemoglobinController.text;
    if (client!.gender == Gender.female) {
      if (double.parse(text) < minHbFemale) {
        return false;
      }
      return true;
    }
    if (double.parse(text) < minHbMale) {
      return false;
    }
    return true;
  }

  _buildHbCard() {
    return SizedBox(
      width: 500,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomField(
                controller: _hemoglobinController,
                onSubmitted: _onSubmitHemoglobin,
                label: 'hemoglobin',
              ),
              const SizedBox(height: 25),
              _isLoadingHemoglobin
                  ? const CircularProgressIndicator()
                  : SubmitButton(
                      onPressed: () => _onSubmitHemoglobin(
                        _hemoglobinController.text,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
