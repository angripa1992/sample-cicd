import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/base/kt_app_bar.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_categories.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_category_item_list.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_category_title.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

class MenuCategoryItemsScreen extends StatefulWidget {
  const MenuCategoryItemsScreen({Key? key}) : super(key: key);

  @override
  State<MenuCategoryItemsScreen> createState() => _MenuCategoryItemsScreenState();
}

class _MenuCategoryItemsScreenState extends State<MenuCategoryItemsScreen> {
  late final Map<String, dynamic> args;
  ValueNotifier<MenuCategory?> menuCategory = ValueNotifier<MenuCategory?>(null);
  late final bool parentEnabled;
  late final int brandId;
  late final int providerId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      args = ModalRoute
          .of(context)
          ?.settings
          .arguments as Map<String, dynamic>;

      parentEnabled = args[ArgumentKey.kENABLED];
      brandId = args[ArgumentKey.kBRAND_ID];
      providerId = args[ArgumentKey.kPROVIDER_ID];
      menuCategory.value = args[ArgumentKey.kMENU_CATEGORY];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, menuCategory.value);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: KTAppBar(
          title: AppStrings.manage_items.tr(),
          onNavBack: () {
            Navigator.pop(context, menuCategory.value);
          },
        ),
        body: ValueListenableBuilder(
          valueListenable: menuCategory,
          builder: (BuildContext context, MenuCategory? value, Widget? child) {
            if (value == null) {
              return const Center(child: CircularProgress());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSize.s2.verticalSpacer(),
                MenuCategoryTitle(
                  menuCategory: value,
                  parentEnabled: parentEnabled,
                  brandID: brandId,
                  providerID: providerId,
                  onChanged: (category) {
                    menuCategory.value = category.copyWith();
                  },
                ),
                AppSize.s4.verticalSpacer(),
                MenuCategoryItemListView(
                  menuCategory: value,
                  onChanged: (modifiedItems) {
                    menuCategory.value?.items = modifiedItems;
                  },
                  parentEnabled: parentEnabled,
                  brandID: brandId,
                  providerID: providerId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
