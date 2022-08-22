import 'package:flutter/material.dart';

import '../helpers/converters.dart';
import '../models/client/client.dart';
import '../models/donor_form/donor_form.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    Key? key,
    required Client client,
    required DonorForm donorForm,
  }) : _client = client, _donorForm = donorForm, super(key: key);

  final Client _client;
  final DonorForm _donorForm;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NAME',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        _client.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            const SizedBox(height: 40, child: VerticalDivider()),
            Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CODE',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        _donorForm.code,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            const SizedBox(height: 40, child: VerticalDivider()),
            Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STAGE',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        enumToString(_donorForm.stage),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            const SizedBox(height: 40, child: VerticalDivider()),
            Expanded(
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUS',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      Text(
                        enumToString(_donorForm.status),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}