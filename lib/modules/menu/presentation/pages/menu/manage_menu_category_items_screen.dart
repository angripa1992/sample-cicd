import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_category_item_list.dart';
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
    final branchId = args[ArgumentKey.kBRANCH_ID];
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, menuCategory);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, menuCategory);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: Text(AppStrings.manage_items.tr()),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s8.rh,
            horizontal: AppSize.s16.rw,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //MenuCategoryTitle(menuCategory: menuCategory),
              MenuCategoryItemListView(
                menuCategory: menuCategory,
                onChanged: (modifiedItems) {
                  menuCategory.items = modifiedItems;
                },
                parentEnabled: parentEnabled,
                brandID: brandId,
                branchID: branchId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
