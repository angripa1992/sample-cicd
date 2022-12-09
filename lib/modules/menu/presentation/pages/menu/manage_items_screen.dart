import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/sub_menu_items_list_view.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/sub_menu_items_title.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/styles.dart';

class ManageItemsScreen extends StatelessWidget {
  const ManageItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final subSections = args['sections'];
    final parentEnabled = args['enabled'];
    final brandId = args['brand_id'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, subSections);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text('Manage Items'),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s16.rh,
          horizontal: AppSize.s16.rw,
        ),
        child: Column(
          children: [
            SubMenuItemsTitle(subSections: subSections),
            SizedBox(height: AppSize.s8.rh),
            SubMenuItemsListView(
              subSections: subSections,
              onChanged: (modifiedItems) {
                subSections.items = modifiedItems;
              },
              parentEnabled: parentEnabled,
              brandID: brandId,
            ),
          ],
        ),
      ),
    );
  }
}
