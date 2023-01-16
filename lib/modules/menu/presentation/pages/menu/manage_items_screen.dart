import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/sub_menu_items_list_view.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/sub_menu_items_title.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/styles.dart';

class ManageItemsScreen extends StatelessWidget {
  const ManageItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final subSections = args[ArgumentKey.kSECTIONS];
    final parentEnabled = args[ArgumentKey.kENABLED];
    final brandId = args[ArgumentKey.kBRAND_ID];
    final providerId = args[ArgumentKey.kPROVIDER_ID];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, subSections);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: Text(AppStrings.manage_items.tr()),
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
              providerID: providerId,
            ),
          ],
        ),
      ),
    );
  }
}
