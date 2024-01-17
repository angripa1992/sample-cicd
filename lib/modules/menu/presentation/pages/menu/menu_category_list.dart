import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/menu/menu_categories.dart';

class MenuCategoryListView extends StatelessWidget {
  final List<MenuCategory> categories;
  final bool parentEnabled;
  final int brandID;
  final int branchID;
  final Function(List<MenuCategory>) onChanged;

  const MenuCategoryListView({
    Key? key,
    required this.categories,
    required this.parentEnabled,
    required this.onChanged,
    required this.brandID,
    required this.branchID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSize.s4,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: AppSize.s10.rh, left: AppSize.s10.rw),
            child: Text(
              AppStrings.categories_list.tr(),
              style: regularTextStyle(
                color: AppColors.greyDarker,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          ListView.separated(
            itemCount: categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () async {
                  final modifiedCategory = await Navigator.pushNamed(
                    context,
                    Routes.manageItems,
                    arguments: {
                      ArgumentKey.kMENU_CATEGORY: categories[index],
                      ArgumentKey.kENABLED: parentEnabled,
                      ArgumentKey.kBRAND_ID: brandID,
                      ArgumentKey.kBRANCH_ID: branchID,
                    },
                  ) as MenuCategory;
                  categories[index] = modifiedCategory;
                  onChanged(categories);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: AppSize.s20.rw, right: AppSize.s4.rw),
                              child: Text(
                                '${index + 1}.',
                                style: regularTextStyle(
                                  color: AppColors.black,
                                  fontSize: AppFontSize.s14.rSp,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                categories[index].title,
                                style: regularTextStyle(
                                  color: AppColors.black,
                                  fontSize: AppFontSize.s14.rSp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.s10.rw,
                        ),
                        child: MenuSwitchView(
                          menuVersion: categories[index].menuVersion,
                          enabled: categories[index].enabled,
                          parentEnabled: parentEnabled,
                          id: categories[index].id,
                          brandId: brandID,
                          branchId: branchID,
                          type: MenuType.CATEGORY,
                          onMenuEnableChanged: (enabled) {
                            categories[index].enabled = enabled;
                            onChanged(categories);
                            SegmentManager().track(
                              event: SegmentEvents.CATEGORY_TOGGLE,
                              properties: {
                                'id': categories[index].id,
                                'name': categories[index].title,
                                'enabled': enabled ? 'Yes' : 'No',
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) {
              return const Divider();
            },
          ),
        ],
      ),
    );
  }
}
