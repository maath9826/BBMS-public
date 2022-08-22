import 'package:blood_bank_system/helpers/firebase.dart';
import 'package:blood_bank_system/models/donor_form/examining_form/examining_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/bag/bag.dart';
import '../../models/client/client.dart';
import '../../models/donor_form/donor_form.dart';
import '../../widgets/search_field.dart';
import '../../widgets/submit_button.dart';
import '../converters.dart';
import '../enums.dart';
import '../functions.dart';
import '../statics.dart';

mixin StageMixin<T extends StatefulWidget> on State<T> {
  String? donorFormId;
  DonorForm? donorForm;
  Client? client;

  var isLoadingData = false;

  final _searchController = TextEditingController();

  getFormAndClient(String text) async {
    ///on empty
    if (text.trim().isEmpty) {
      return;
    }

    ///show loading
    setState(() {
      isLoadingData = true;
    });

    ///get data
    await getData(text);

    ///hide loading
    setState(() {
      isLoadingData = false;
    });
  }

  getData(text) async {
    try {
      await Service.donorForms.getList(limit: 1, searchText: text.trim()).then((snap) async {
        if (snap.size == 0) return null;
        donorFormId = snap.docs[0].id;
        donorForm = DonorForm.fromJson(snap.docs[0].data());
        var fullDonorForm = FullDonorForm(donorForm: donorForm!, id: snap.docs[0].id);

        client = await Service.clients
            .get(fullDonorForm.donorForm.clientId)
            .then((docSnapshot) => Client.fromJson(docSnapshot.data()!));

        return fullDonorForm;
      });
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  goNext({
    ExaminingForm? examiningForm,
    double? numberOfBags,
    List<FullBag>? fullBags,
  }) async {
    if (!isAssigned(donorFormId)) return print(' data has not been assigned');

    final batch = FirebaseFirestore.instance.batch();

    var donorFormRef = Service.donorForms.getReference(donorFormId!);


    try {
      batch.update(donorFormRef, {
        'stage': enumToString(donorForm!.nextStage),
        if (isAssigned(examiningForm)) 'examiningForm': examiningForm!.toJson(),
        if (isAssigned(numberOfBags)) 'numberOfBags': numberOfBags,
      });

      if (isAssigned(fullBags)) {
        for (var fullBag in fullBags!) {
          var bagReference = Service.bags.getReference(fullBag.id);
          batch.update(bagReference, {
            'status': enumToString(BagStatus.accepted),
          });
        }
      }

      await batch.commit();
      await getFormAndClient(donorForm!.code);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  reject({
    required RejectionCause cause,
    DateTime? unbanDate,
    String? note,
    List<FullBag>? fullBags,
  }) async {
    if (!isAssigned(donorFormId)) return print(' data has not been assigned');
    var donorFormRef = Service.donorForms.getReference(donorFormId!);
    var clientRef = Service.clients.getReference(donorForm!.clientId);
    final batch = FirebaseFirestore.instance.batch();
    try {
      batch.update(donorFormRef, {
        'status': enumToString(DonorFormStatus.rejected),
        'rejectionCause': enumToString(cause),
        'rejectionNote': note,
      });

      batch.update(clientRef, {
        'status': enumToString(ClientStatus.banned),
        'unbanDate': isAssigned(unbanDate) ? Timestamp.fromDate(unbanDate!) : null,
      });

      if (isAssigned(fullBags)) {
        for (var fullBag in fullBags!) {
          var bagReference = Service.bags.getReference(fullBag.id);
          batch.update(bagReference, {
            'status': enumToString(BagStatus.rejected),
          });
        }
      }

      await batch.commit();
      await getFormAndClient(donorForm!.code);
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  bool canUse(DonorFormStage stage) {
    return donorForm!.status == DonorFormStatus.pending && donorForm!.stage == stage;
  }

  buildCodeFieldCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: SearchField(
                    searchController: _searchController,
                    onSubmitted: getFormAndClient,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(width: 16),
                isLoadingData
                    ? const CircularProgressIndicator()
                    : Flexible(
                        flex: 1,
                        child: SubmitButton(
                            onPressed: () => getFormAndClient(_searchController.text),
                            title: 'GET'),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }

  makeNullData() {
    setState(() {
      client = null;
      donorFormId = null;
      donorForm = null;
    });
  }

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
    } else if (donorForm!.stage != stage) {
      message = 'This Donor Form does not belong to this stage';
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

  bool get isRejected {
    return donorForm!.status == DonorFormStatus.rejected;
  }
}
