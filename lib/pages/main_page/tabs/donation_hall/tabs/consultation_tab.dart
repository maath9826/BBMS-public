import 'package:blood_bank_system/pages/create_form_page.dart';
import 'package:blood_bank_system/services/donor_forms_service.dart';
import 'package:blood_bank_system/widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../helpers/constant_variables.dart';
import '../../../../../helpers/service.dart';
import '../../../../../models/local/data_table/data_table_data.dart';
import '../../../../../services/clients_service.dart';
import '../../../../../widgets/custom_data_table/custom_data_table.dart';
import '../../../../../widgets/pagination/src/web_pagination_widget.dart';

class ConsultationTab extends StatefulWidget {
  static const routeName = 'ConsultationTab';

  ConsultationTab({Key? key}) : super(key: key);

  @override
  State<ConsultationTab> createState() => _ConsultationTabState();
}

class _ConsultationTabState extends State<ConsultationTab> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider.of<DonorFormsService>(context,);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
      child: SizedBox(
        width: double.maxFinite,
        child: Consumer<DonorFormsService>(
          builder: (BuildContext, DonorFormsService, Widget){
            return FutureBuilder<DataTableData>(
                future: getDataTableData(limit: 10),
                builder: (ctx, dataTableDataFuture) {

                  if (dataTableDataFuture.hasError) {
                    print(dataTableDataFuture.error);
                    print(dataTableDataFuture.stackTrace);
                  }
                  if (!dataTableDataFuture.hasData || dataTableDataFuture.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomDataTable(dataTableData: dataTableDataFuture.data!,);
                });
          }
        ),
      ),
    );
  }
}
