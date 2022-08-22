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

import '../../../helpers/functions.dart';
import '../../../helpers/service.dart';
import '../../../helpers/statics.dart';
import '../../../models/client/client.dart';
import '../../../widgets/custom_auto_completet_field.dart';
import '../../../widgets/info_card.dart';
import '../../../widgets/submit_button.dart';

class DiseasesDetectionTab extends StatefulWidget {
  const DiseasesDetectionTab({Key? key}) : super(key: key);

  @override
  State<DiseasesDetectionTab> createState() => _DiseasesDetectionTabState();
}

class _DiseasesDetectionTabState extends State<DiseasesDetectionTab>
    with StageMixin<DiseasesDetectionTab> {

  Disease? _selectedDisease;

  var _isLoadingDisease = false;

  @override
  Widget build(BuildContext context) {
    return isAssigned(donorForm)
        ? SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
            child: Column(
              children: [
                InfoCard(client: client!, donorForm: donorForm!),
                const SizedBox(height: 8),
                canUse(DonorFormStage.diseasesDetection)
                    ? _buildBagsCard()
                    : Column(
                        children: [
                          buildChip(DonorFormStage.diseasesDetection),
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

  void _onSubmitDisease() async {

    if(!isAssigned(_selectedDisease)) return;

    ///show loading
    setState(() {
      _isLoadingDisease = true;
    });

    var bagsSnapshot = await Service.bags.getList(donorFormId: donorFormId!);
    List<FullBag> fullBags = bagsSnapshot.docs.map((doc) => FullBag(id: doc.id, bag: Bag.fromJson(doc.data()))).toList();

    ///update donorForm
    if(_selectedDisease == Disease.noDisease) {
      await goNext(fullBags: fullBags);
    }
    else{
      await reject(cause: diseaseToRejectionCause(_selectedDisease!), unbanDate: _getUnbanDate(),fullBags: fullBags);
    }

    ///hide loading
    setState(() {
      _isLoadingDisease = false;
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
              CustomDropdown(
                list: Disease.values,
                selectedItem: _selectedDisease,
                onChange: (disease) {
                  _selectedDisease = (disease as Disease);
                },
                hint: 'select something',
              ),
              const SizedBox(height: 30),
              _isLoadingDisease
                  ? const CircularProgressIndicator()
                  : SubmitButton(
                      onPressed: _onSubmitDisease,
                    )
            ],
          ),
        ),
      ),
    );
  }

  DateTime? _getUnbanDate() {
    DateTime? unbanDate = DateTime(2000);
    switch(_selectedDisease){
      case Disease.hIV:
        unbanDate = null;
        break;
      case Disease.hBV:
        unbanDate = DateTime.now().add(const Duration(days: UnbanDuration.hBV));
        break;
      case Disease.hCV:
        unbanDate = DateTime.now().add(const Duration(days: UnbanDuration.hCV));
        break;
      case Disease.syphilis:
        unbanDate = DateTime.now().add(const Duration(days: UnbanDuration.syphilis));
        break;
    }
    return unbanDate;
  }

}
