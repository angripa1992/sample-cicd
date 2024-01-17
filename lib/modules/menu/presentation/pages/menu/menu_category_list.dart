import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/resource_resolver.dart';
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
  final int providerID;
  final Function(List<MenuCategory>) onChanged;

  const MenuCategoryListView({
    Key? key,
    required this.categories,
    required this.parentEnabled,
    required this.onChanged,
    required this.brandID,
    required this.providerID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.s12.rSp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.categories_list.tr(),
            style: mediumTextStyle(
              color: AppColors.neutralB600,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          AppSize.s12.verticalSpacer(),
          Divider(thickness: AppSize.s1.rh, color: AppColors.greyLight),
          AppSize.s16.verticalSpacer(),
          ListView.separated(
            itemCount: categories.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: InkWell(
                  onTap: () async {
                    final modifiedCategory = await Navigator.pushNamed(
                      context,
                      Routes.manageItems,
                      arguments: {
                        ArgumentKey.kMENU_CATEGORY: categories[index],
                        ArgumentKey.kENABLED: parentEnabled,
                        ArgumentKey.kBRAND_ID: brandID,
                        ArgumentKey.kPROVIDER_ID: providerID,
                      },
                    ) as MenuCategory;
                    categories[index] = modifiedCategory;
                    onChanged(categories);
                  },
                  child: Row(
                    children: [
                      MenuSwitchView(
                        menuVersion: categories[index].menuVersion,
                        enabled: categories[index].enabled,
                        parentEnabled: parentEnabled,
                        id: categories[index].id,
                        brandId: brandID,
                        providerId: providerID,
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
                      AppSize.s12.horizontalSpacer(),
                      Expanded(
                        child: Text(
                          categories[index].title.trim(),
                          style: regularTextStyle(
                            color: AppColors.neutralB500,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      ),
                      AppSize.s12.horizontalSpacer(),
                      ImageResourceResolver.rightArrowSVG.getImageWidget(
                        width: AppSize.s16.rw,
                        height: AppSize.s16.rh,
                        color: AppColors.neutralB600,
                      )
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
