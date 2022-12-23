import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/sub_section.dart';

class SubMenuListView extends StatelessWidget {
  final List<SubSections> subSections;
  final bool parentEnabled;
  final int brandID;
  final Function(List<SubSections>) onChanged;

  const SubMenuListView(
      {Key? key,
      required this.subSections,
      required this.parentEnabled,
      required this.onChanged,
      required this.brandID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppSize.s4,
      color: AppColors.whiteSmoke,
      child: ListView.separated(
        itemCount: subSections.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () async {
              final modifiedSubsections = await Navigator.pushNamed(
                context,
                Routes.manageItems,
                arguments: {
                  ArgumentKey.kSECTIONS: subSections[index],
                  ArgumentKey.kENABLED: parentEnabled,
                  ArgumentKey.kBRAND_ID: brandID,
                },
              ) as SubSections;
              subSections[index] = modifiedSubsections;
              onChanged(subSections);
            },
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: AppSize.s20.rw, right: AppSize.s4.rw),
                        child: Text(
                          '${index + 1}.',
                          style: getRegularTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s15.rSp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          subSections[index].title,
                          style: getRegularTextStyle(
                            color: AppColors.purpleBlue,
                            fontSize: AppFontSize.s15.rSp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s10.rw),
                  child: MenuSwitchView(
                    enabled: subSections[index].enabled,
                    parentEnabled: parentEnabled,
                    id: subSections[index].id,
                    brandId: brandID,
                    type: MenuType.SUB_SECTION,
                    onChanged: (enabled) {
                      subSections[index].enabled = enabled;
                      onChanged(subSections);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) {
          return const Divider();
        },
      ),
    );
  }
}
