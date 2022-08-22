import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/helpers/firebase.dart';
import 'package:blood_bank_system/helpers/statics.dart';
import 'package:blood_bank_system/models/bloodStorage/blood_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../helpers/converters.dart';
import '../../../../../models/bag/bag.dart';
import '../../../../../models/donor_form/donor_form.dart';
import '../../../../../widgets/custom_field.dart';
import '../../../../../widgets/submit_button.dart';

class View extends StatelessWidget {
  View({
    Key? key,
    required this.fullBags,
    required this.type,
  }) : super(key: key);

  final List<FullBag> fullBags;
  final TemporaryStorageViewType type;

  final _codeController = TextEditingController();

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (fullBags.isEmpty) {
      return Center(child:  Column(mainAxisSize: MainAxisSize.min,children: const [
        FaIcon(FontAwesomeIcons.file,size: 100,color: Colors.black45,),
        SizedBox(height: 16,),
        Text('no data',style: TextStyle(color: Colors.black45),)
      ],));
    }
    return ListView.separated(
      separatorBuilder: (ctx, index) => const Divider(height: 0),
      itemBuilder: (ctx, index) =>
          ListTile(
            leading: _getIcon(),
            title: Text(fullBags[index].bag.clientName),
            subtitle: Text(
              dateTimeToString(fullBags[index].bag.clientBirthDate),
            ),
            onTap: type == TemporaryStorageViewType.pending
                ? null
                : () {
              showDialog(context: context,
                  builder: (ctx) => _buildDialog(fullBags[index]));
            },
          ),
      itemCount: fullBags.length,
    );
  }

  Widget _getIcon() {
    late Widget widget;
    switch (type) {
      case TemporaryStorageViewType.accepted:
        widget = const FaIcon(
          FontAwesomeIcons.checkCircle,
        );
        break;
      case TemporaryStorageViewType.rejected:
        widget = const FaIcon(
          FontAwesomeIcons.ban,
        );
        break;
      default:
        widget = const FaIcon(
          FontAwesomeIcons.clock,
        );
    }
    return widget;
  }

  _buildDialog(FullBag fullBag) {
    return StatefulBuilder(
      builder: (ctx, dialogSetState) =>
          SimpleDialog(contentPadding: const EdgeInsets.all(24), children: [
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  CustomField(
                    label: 'code',
                    controller: _codeController,
                  ),
                  const SizedBox(height: 30),
                  _isLoading ? const CircularProgressIndicator() : SubmitButton(
                    onPressed: () => _onSubmitCode(
                        dialogSetState: dialogSetState, fullBag: fullBag, context: ctx),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  _onSubmitCode(
      {required void Function(void Function()) dialogSetState, required FullBag fullBag, required BuildContext context}) async {
    var code = _codeController.text.trim();

    ///on empty
    if (code.isEmpty) {
      return;
    }

    ///show loading
    dialogSetState(() {
      _isLoading = true;
    });



    ///update data
    var donorForm = await Service.donorForms.get(fullBag.bag.donorFormId).then((snapshot) => DonorForm.fromJson(snapshot.data()!));
    if(code == donorForm.code){
      await _update(fullBag,donorForm);
      Navigator.pop(context);
    }

    ///hide loading
    dialogSetState(() {
      _isLoading = false;
    });
  }

  _update(FullBag fullBag, DonorForm donorForm) async {
    var bagReference = Service.bags.getReference(fullBag.id);
    var clientReference = Service.clients.getReference(donorForm.clientId);
    var donorFormReference = Service.donorForms.getReference(
        fullBag.bag.donorFormId);

    var bloodStorageReference =       Service.storage.getReference(
        'blood');

    final batch = FirebaseFirestore.instance.batch();

    try {
      if (type == TemporaryStorageViewType.accepted) {
        var donorForm = await Service.donorForms.get(fullBag.bag.donorFormId)
            .then((snapshot) => DonorForm.fromJson(snapshot.data()!));

        batch.update(bagReference, {
          "stage": enumToString(BagStage.storage)
        });

        batch.update(bloodStorageReference, {
          '${stringToBloodGroupVarMap[fullBag.bag.bloodGroup]}' : FieldValue.increment(1)
        });

        donorForm.numberOfStoredBags += 1;
        batch.update(donorFormReference, {
          if(donorForm.numberOfBags == donorForm.numberOfStoredBags) "stage": enumToString(DonorFormStage.finnish),
          if(donorForm.numberOfBags == donorForm.numberOfStoredBags) "status": enumToString(DonorFormStatus.accepted),
          "numberOfStoredBags": donorForm.numberOfStoredBags,
        });

        batch.update(clientReference, {
          "balance": FieldValue.increment(1)
        });
      }
      else {
        batch.update(bagReference, {
          "stage": enumToString(BagStage.disposed)
        });
      }



      await batch.commit();
    } catch (e, s) {
      print(e);
      print(s);
    }
  }
}

enum TemporaryStorageViewType {
  accepted,
  rejected,
  pending,
}
