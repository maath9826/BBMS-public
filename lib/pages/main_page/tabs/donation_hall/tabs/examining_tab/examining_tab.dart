import 'dart:async';
import 'dart:html' as html;

import 'package:badges/badges.dart';
import 'package:blood_bank_system/helpers/constant_variables.dart';
import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/models/donor_form/donor_form.dart';
import 'package:blood_bank_system/models/donor_form/examining_form/examining_form.dart';
import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/examining_tab/widgets/examining_tab_section.dart';
import 'package:blood_bank_system/pages/main_page/tabs/donation_hall/tabs/examining_tab/widgets/examining_tab_sections_wrapper.dart';
import 'package:blood_bank_system/widgets/custom_field.dart';
import 'package:blood_bank_system/widgets/search_field.dart';
import 'package:blood_bank_system/widgets/secondary_tab.dart';
import 'package:blood_bank_system/widgets/three_fields_date.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../helpers/functions.dart';
import '../../../../../../helpers/mixins/stage_mixin.dart';
import '../../../../../../helpers/service.dart';
import '../../../../../../helpers/statics.dart';
import '../../../../../../models/client/client.dart';
import '../../../../../../widgets/closed_question.dart';
import '../../../../../../widgets/info_card.dart';
import '../../../../../../widgets/submit_button.dart';

class Examining extends StatefulWidget {
  const Examining({Key? key}) : super(key: key);

  @override
  State<Examining> createState() => _ExaminingState();
}

class _ExaminingState extends State<Examining> with StageMixin<Examining> {
  final _bloodPressureController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();
  final _doctorNameController = TextEditingController();

  final _donationYearController = TextEditingController();
  final _donationMonthController = TextEditingController();
  final _donationDayController = TextEditingController();

  final _unbanYearController = TextEditingController();
  final _unbanMonthController = TextEditingController();
  final _unbanDayController = TextEditingController();

  final _vaccineNameController = TextEditingController();

  final _noteController = TextEditingController();

  var _isDonatedBefore = false;
  var _isRejectedBefore = false;
  var _isTookAspirin = false;

  var _isInfectedWithViralHepatitis = false;
  var _isPersonWithEpilepsy = false;
  var _isSufferedOtherDiseases = false;

  var _isTookDrugs = false;
  var _isHadCuppingOrOthers = false;

  var _isVaccinated = false;

  DateTime? _donationDate;

  DateTime? _unbanDate;

  var _isAcceptLoading = false;
  var _isRejectLoading = false;

  final _formKey = GlobalKey<FormState>();

  get _getExaminingForm => ExaminingForm(
        bloodPressure: isNumeric(_bloodPressureController.text)
            ? double.parse(_bloodPressureController.text)
            : null,
        doctorName: _doctorNameController.text,
        donationDate: _donationDate,
        heartRate: isNumeric(_heartRateController.text)
            ? double.parse(_heartRateController.text)
            : null,
        isDonatedBefore: _isDonatedBefore,
        isHadCuppingOrOthers: _isHadCuppingOrOthers,
        isInfectedWithViralHepatitis: _isInfectedWithViralHepatitis,
        isPersonWithEpilepsy: _isPersonWithEpilepsy,
        isRejectedBefore: _isRejectedBefore,
        isSufferedOtherDiseases: _isSufferedOtherDiseases,
        isTookAspirin: _isTookAspirin,
        isTookDrugs: _isTookDrugs,
        isVaccinated: _isVaccinated,
        temperature: isNumeric(_temperatureController.text)
            ? double.parse(_temperatureController.text)
            : null,
        vaccineName: _vaccineNameController.text,
        weight: isNumeric(_weightController.text)
            ? double.parse(_weightController.text)
            : null,
      );

  @override
  Widget build(BuildContext context) {
    return isAssigned(donorForm)
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            child: Column(
              children: [
                InfoCard(client: client!, donorForm: donorForm!),
                const SizedBox(
                  height: 8,
                ),
                canUse(DonorFormStage.examining)
                    ? _buildQuestionsCard()
                    : Column(
                        children: [
                          buildChip(DonorFormStage.examining),
                          SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                              width: 200,
                              child: SubmitButton(
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (ctx) => _buildDetailsDialog(),
                                ),
                                title: 'Show Details',
                              )),
                          SizedBox(
                            height: 16,
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.only(
                                right: 26,
                                left: 10,
                                top: 10,
                                bottom: 10,
                              )),
                            ),
                            onPressed: makeNullData,
                            icon: Icon(
                              Icons.keyboard_arrow_left,
                            ),
                            label: Text(
                              'Back',
                            ),
                            // child: Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: const [
                            //     Icon(CupertinoIcons.back),
                            //     SizedBox(
                            //       width: 8,
                            //     ),
                            //     Text('Back'),
                            //   ],
                            // ),
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

  bool _validateAllFields() {
    if (_formKey.currentState!.validate() && _unbanDate != null) {
      return true;
    } else {
      return false;
    }
  }

  void _onAccept() async {
    ///show loading
    setState(() {
      _isAcceptLoading = true;
    });

    ///Go next
    await goNext(examiningForm: _getExaminingForm);

    ///hide loading
    setState(() {
      _isAcceptLoading = false;
    });
  }

  void _onReject() async {
    if (!_validateAllFields()) return;

    ///show loading
    setState(() {
      _isRejectLoading = true;
    });

    ///Go next
    await reject(
        cause: RejectionCause.other,
        note: _noteController.text,
        unbanDate: _unbanDate!);

    ///hide loading
    setState(() {
      _isRejectLoading = false;
    });

    Navigator.of(context).pop();
  }

  _buildFields() {
    var fields = [
      Field(controller: _bloodPressureController, label: 'blood pressure'),
      Field(controller: _heartRateController, label: 'heart rate'),
      Field(controller: _temperatureController, label: 'temperature'),
      Field(controller: _weightController, label: 'weight'),
      Field(controller: _doctorNameController, label: 'doctor name'),
    ];
    return fields
        .map(
          (field) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomField(
                controller: field.controller,
                label: field.label,
                isOptional: true,
              ),
            ),
          ),
        )
        .toList();
  }

  _buildSections() {
    return [
      ExaminingTabSection(data: [_buildFields()]),
      ExaminingTabSection(data: [
        [
          ClosedQuestion(
            value: _isDonatedBefore,
            question: 'Did you donate before?',
            onChange: (value) {
              _isDonatedBefore = value!;
            },
          ),
          const SizedBox(width: 75),
          const Text('Last donation date'),
          const SizedBox(width: 25),
          Expanded(
            child: ThreeFieldsDate(
                dayController: _donationDayController,
                monthController: _donationMonthController,
                yearController: _donationYearController,
                onChange: (date) => _donationDate = date),
          )
        ],
        const [
          SizedBox(height: 25),
        ],
        [
          ClosedQuestion(
            value: _isRejectedBefore,
            question: 'Have your donation been reject before?',
            onChange: (value) {
              _isRejectedBefore = value!;
            },
          ),
          const SizedBox(width: 75),
          ClosedQuestion(
            value: _isTookAspirin,
            question: 'Did you take Aspirin in the past three days?',
            onChange: (value) {
              _isTookAspirin = value!;
            },
          ),
        ]
      ]),
      ExaminingTabSection(data: [
        [
          ClosedQuestion(
            value: _isInfectedWithViralHepatitis,
            question: 'Did you been infected by Viral Hepatitis?',
            onChange: (value) {
              _isInfectedWithViralHepatitis = value!;
            },
          ),
          const SizedBox(width: 75),
          ClosedQuestion(
            value: _isPersonWithEpilepsy,
            question: 'Are you a Person With Epilepsy?',
            onChange: (value) {
              _isPersonWithEpilepsy = value!;
            },
          ),
        ],
        const [
          SizedBox(height: 25),
        ],
        [
          ClosedQuestion(
            value: _isSufferedOtherDiseases,
            question:
                'Did you suffer from chronic diseases, blood, Urinary system diseases, chest diseases, heart diseases, blood pressure, diabetes ?',
            onChange: (value) {
              _isSufferedOtherDiseases = value!;
            },
          ),
        ]
      ]),
      ExaminingTabSection(data: [
        [
          ClosedQuestion(
            value: _isTookDrugs,
            question: "Have you took antibiotics or chronic diseases' drugs?",
            onChange: (value) {
              _isTookDrugs = value!;
            },
          ),
        ],
        const [
          SizedBox(height: 25),
        ],
        [
          ClosedQuestion(
            value: _isHadCuppingOrOthers,
            question:
                'Have you had a surgery, tattoo, cupping, teeth extractions',
            onChange: (value) {
              _isHadCuppingOrOthers = value!;
            },
          ),
        ]
      ]),
      ExaminingTabSection(data: [
        [
          ClosedQuestion(
            value: _isVaccinated,
            question: "Have you been vaccinated in the past two weeks?",
            onChange: (value) {
              _isVaccinated = value!;
            },
          ),
          const SizedBox(width: 75),
          SizedBox(
              width: 200,
              child: CustomField(
                label: 'vaccine',
                controller: _vaccineNameController,
                isOptional: true,
              ))
        ],
      ])
    ];
  }

  _buildQuestionsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ExaminingTabSectionsWrapper(
              sections: _buildSections(),
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                _isAcceptLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: 200,
                        child: SubmitButton(
                          onPressed: () => _onAccept(),
                          title: 'Accept',
                          color: Colors.greenAccent,
                        ),
                      ),
                SizedBox(width: 24),
                SizedBox(
                  width: 200,
                  child: SubmitButton(
                    onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => _buildRejectionDialog()),
                    title: 'Reject',
                    color: Colors.redAccent,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildRejectionDialog() {
    return SimpleDialog(contentPadding: const EdgeInsets.all(24), children: [
      SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomField(
                label: 'note',
                controller: _noteController,
                isTextArea: true,
              ),
              const SizedBox(height: 16),
              ThreeFieldsDate(
                title: 'Unban date',
                dayController: _unbanDayController,
                monthController: _unbanMonthController,
                yearController: _unbanYearController,
                onChange: (date) => _unbanDate = date,
              ),
              const SizedBox(height: 30),
              _isRejectLoading
                  ? const CircularProgressIndicator()
                  : SubmitButton(
                      onPressed: _onReject,
                    ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget _buildDetailsDialog() {
    var details = donorForm!.examiningForm.details;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 300,
          maxHeight: 600,
          minWidth: 600,
          maxWidth: 600,
        ),
        child: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: Column(
              children: details
                  .map(
                    (detail) => Column(
                      children: [
                        ListTile(
                          title: Text(detail.key),
                          trailing: Text(detail.value),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 40),
                          horizontalTitleGap: 100,
                        ),
                        if (details[details.length - 1] != detail)
                          const Divider(
                            thickness: 0,
                            height: 0,
                          ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class Field {
  final TextEditingController controller;
  final String label;

  Field({
    required this.controller,
    required this.label,
  });
}

// if (isAssigned(_donorForm) && !_canUse()) {
// String message = "";
// if (_donorForm!.stage != DonorFormStage.examining) {
// message = 'Current Stage is "${enumToString(_donorForm!.stage)}"';
// } else {
// if (_donorForm!.status == DonorFormStatus.rejected) {
// message =
// 'This form has been rejected because of ${generateRejectionCauseMessage(
// cause: _donorForm!.rejectionCause!,
// note: _donorForm!.rejectionNote,
// )}';
// } else if (_donorForm!.status == DonorFormStatus.accepted) {
// message = 'This form has been closed';
// }
// }
// showToast(
// text: message,
// context: context,
// color: Colors.yellowAccent,
// durationInSeconds: 5,
// );
// }
