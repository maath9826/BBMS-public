import 'package:badges/badges.dart';
import 'package:blood_bank_system/helpers/constant_variables.dart';
import 'package:blood_bank_system/helpers/converters.dart';
import 'package:blood_bank_system/helpers/enums.dart';
import 'package:blood_bank_system/helpers/mixins/stage_mixin.dart';
import 'package:blood_bank_system/helpers/statics.dart';

import 'package:blood_bank_system/widgets/custom_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../helpers/functions.dart';

import '../../../../models/bag/bag.dart';
import '../../../../widgets/submit_button.dart';
import 'widgets/view.dart';

class TemporaryStorageTab extends StatefulWidget {
  const TemporaryStorageTab({Key? key}) : super(key: key);

  @override
  State<TemporaryStorageTab> createState() => _TemporaryStorageTabState();
}

class _TemporaryStorageTabState extends State<TemporaryStorageTab>
    with StageMixin<TemporaryStorageTab>, SingleTickerProviderStateMixin {
  Disease? _selectedDisease;

  var _isLoadingDisease = false;

  late final TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            width: 600,
            child: Card(
              elevation: 3,
              margin: EdgeInsets.all(16),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: Service.bags.getListStream(
                    stage: BagStage.temporaryStorage,
                    startingDate: DateTime.now().subtract(const Duration(days: 1)),
                  ),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      print(snapshot.stackTrace);
                      return const Text('Error!!!');
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var fullBags = snapshot.data!.docs
                        .map((doc) => FullBag(id: doc.id, bag: Bag.fromJson(doc.data())))
                        .toList();
                    var fullPendingBags = fullBags
                        .where((fullBag) => fullBag.bag.status == BagStatus.pending)
                        .toList();
                    var fullAcceptedBags = fullBags
                        .where((fullBag) => fullBag.bag.status == BagStatus.accepted)
                        .toList();
                    var fullRejectedBags = fullBags
                        .where((fullBag) => fullBag.bag.status == BagStatus.rejected)
                        .toList();
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildTabBar(fullPendingBags, fullAcceptedBags, fullRejectedBags),
                        _buildViews(fullPendingBags, fullAcceptedBags, fullRejectedBags),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  Container _buildTabBar(List<FullBag> fullPendingBags, List<FullBag> fullAcceptedBags,
      List<FullBag> fullRejectedBags) {
    return Container(
      color: Colors.black87,
      child: TabBar(
        indicator: BoxDecoration(color: Theme.of(context).primaryColor),
        labelColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 16),
        controller: _tabController,
        tabs: [
          Tab(
            child: Badge(
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('PENDING'),
                ),
                badgeContent: Text(fullPendingBags.length.toString()),
                showBadge: fullPendingBags.isNotEmpty),
          ),
          Tab(
            child: Badge(
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Text('ACCEPTED'),
              ),
              badgeContent: Text(fullAcceptedBags.length.toString()),
              showBadge: fullAcceptedBags.isNotEmpty,
            ),
          ),
          Tab(
            child: Badge(
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Text('REJECTED'),
              ),
              badgeContent: Text(
                fullRejectedBags.length.toString(),
              ),
              showBadge: fullRejectedBags.isNotEmpty,
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildViews(List<FullBag> fullPendingBags, List<FullBag> fullAcceptedBags,
      List<FullBag> fullRejectedBags) {
    return Expanded(
      child: TabBarView(
        children: [
          View(fullBags: fullPendingBags, type: TemporaryStorageViewType.pending),
          View(fullBags: fullAcceptedBags, type: TemporaryStorageViewType.accepted),
          View(fullBags: fullRejectedBags, type: TemporaryStorageViewType.rejected),
        ],
        controller: _tabController,
      ),
    );
  }
}
