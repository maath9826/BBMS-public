import 'package:badges/badges.dart';
import 'package:blood_bank_system/helpers/constant_variables.dart';
import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/helpers/mixins/stage_mixin.dart';
import 'package:blood_bank_system/models/bag/bag.dart';
import 'package:blood_bank_system/models/bloodStorage/blood_storage.dart';
import 'package:blood_bank_system/widgets/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../helpers/functions.dart';
import '../../../helpers/statics.dart';
import '../../../widgets/info_card.dart';
import '../../../widgets/submit_button.dart';

class StorageTab extends StatefulWidget {
  const StorageTab({Key? key}) : super(key: key);

  @override
  State<StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<StorageTab> with StageMixin<StorageTab> {
  FullBag? _currentFullBag;

  var _isDonating = false;

  @override
  Widget build(BuildContext context) {
    return isAssigned(donorForm) && isAssigned(_currentFullBag)
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: SizedBox(
                  width: 400,
                  child: _buildBagCard(),
                ),
              ),
            ],
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      buildCodeFieldCard(),
                      _buildStatisticsCard(),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  @override
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
    await _getBag();

    ///hide loading
    setState(() {
      isLoadingData = false;
    });
  }

  void _donate() async {
    ///show loading
    setState(() {
      _isDonating = true;
    });

    ///update bag stage
    var batch = FirebaseFirestore.instance.batch();

    var bagRef = Service.bags.getReference(_currentFullBag!.id);
    var storageRef = Service.storage.getReference('blood');

    batch.update(bagRef, {'stage': enumToString(BagStage.disposed)});

    batch.update(storageRef, {
      stringToBloodGroupVarMap[_currentFullBag!.bag.bloodGroup]!: FieldValue.increment(-1),
    });

    await batch.commit();

    makeNullData();

    ///hide loading
    setState(() {
      _isDonating = false;
    });
  }

  Card _buildBagCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                  columns: [
                    DataColumn(label: Text('Key'.toUpperCase())),
                    DataColumn(label: Text('Value'.toUpperCase())),
                  ],
                  rows: _currentFullBag!.bag.details
                      .map(
                        (detail) => DataRow(cells: [
                          DataCell(
                            Chip(label: Text(detail.key)),
                          ),
                          DataCell(Text(detail.value)),
                        ]),
                      )
                      .toList()),
            ),
            const SizedBox(
              height: 16,
            ),
            _isDonating
                ? const CircularProgressIndicator()
                : SubmitButton(
                    onPressed: _donate,
                    title: 'DONATE',
                  )
          ],
        ),
      ),
    );
  }

  _buildStatisticsCard() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: Service.storage.getListStream(),
      builder: (ctx, snapshot) {
        var errorWidget = handleStreamErrors(snapshot);
        if (errorWidget != null) return errorWidget;

        late final BloodStorage bloodStorage;
        for (var doc in snapshot.data!.docs) {
          if (doc.id == 'blood') {
            bloodStorage = BloodStorage.fromJson(doc.data());
            break;
          }
        }

        var bloodStorageEntries = bloodStorage.toJson().entries.toList();

        return SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: DataTable(
                  columns: [
                    DataColumn(label: Text('blood group'.toUpperCase())),
                    DataColumn(label: Text('count'.toUpperCase())),
                  ],
                  rows: bloodStorageEntries
                      .map(
                        (entry) => DataRow(
                            color: entry.value == 0
                                ? MaterialStateProperty.all(Colors.redAccent)
                                : null,
                            cells: [
                              DataCell(
                                Chip(label: Text(bloodGroupVarToStringMap[entry.key]!)),
                              ),
                              DataCell(Text(entry.value.toString())),
                            ]),
                      )
                      .toList()),
            ),
          ),
        );
      },
    );
  }

  _getBag() async {
    await Service.bags.getList(donorFormId: donorFormId!).then((snap) {
      if (snap.size == 0) return;
      var formFullBags =
          snap.docs.map((doc) => FullBag(id: doc.id, bag: Bag.fromJson(doc.data()))).toList();
      for (var fullBag in formFullBags) {
        if (fullBag.bag.stage == BagStage.storage) {
          _currentFullBag = fullBag;
          return;
        }
      }
      _currentFullBag = null;
    });
  }

  @override
  makeNullData() {
    // TODO: implement makeNullData
    setState(() {
      client = null;
      donorFormId = null;
      donorForm = null;
      _currentFullBag = null;
    });
  }
}
