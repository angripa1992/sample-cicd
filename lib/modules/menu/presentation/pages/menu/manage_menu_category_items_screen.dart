import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/base/kt_app_bar.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_category_item_list.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_category_title.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

class ManageItemsScreen extends StatelessWidget {
  const ManageItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final menuCategory = args[ArgumentKey.kMENU_CATEGORY];
    final parentEnabled = args[ArgumentKey.kENABLED];
    final brandId = args[ArgumentKey.kBRAND_ID];
    final providerId = args[ArgumentKey.kPROVIDER_ID];
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, menuCategory);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: KTAppBar(
          title: AppStrings.manage_items.tr(),
          onNavBack: () {
            Navigator.pop(context, menuCategory);
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSize.s2.verticalSpacer(),
            MenuCategoryTitle(menuCategory: menuCategory),
            AppSize.s4.verticalSpacer(),
            MenuCategoryItemListView(
              menuCategory: menuCategory,
              onChanged: (modifiedItems) {
                menuCategory.items = modifiedItems;
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
