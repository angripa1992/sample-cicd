import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifer_switch_view.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/modifier/modifier_group.dart';

class ModifierGroupsListView extends StatefulWidget {
  final int brandId;
  final int branchId;
  final List<ModifierGroup> modifierGroups;

  const ModifierGroupsListView({
    Key? key,
    required this.modifierGroups,
    required this.brandId,
    required this.branchId,
  }) : super(key: key);

  @override
  State<ModifierGroupsListView> createState() => _ModifierGroupsListViewState();
}

class _ModifierGroupsListViewState extends State<ModifierGroupsListView> {
  var _modifiableModifierGroups = <ModifierGroup>[];

  @override
  void initState() {
    _modifiableModifierGroups = widget.modifierGroups;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: UniqueKey(),
      itemCount: _modifiableModifierGroups.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final group = _modifiableModifierGroups[index];
        return InkWell(
          onTap: () async {
            SegmentManager().track(
              event: SegmentEvents.MODIFIER_CLICK,
              properties: {
                'id': group.id,
                'group_name': group.title,
              },
            );
            final modifiedModifierGroup = await Navigator.pushNamed(
              context,
              Routes.manageModifiers,
              arguments: {
                ArgumentKey.kGROUP: group,
                ArgumentKey.kBRAND_ID: widget.brandId,
                ArgumentKey.kBRANCH_ID: widget.branchId,
              },
            ) as ModifierGroup;
            setState(() {
              _modifiableModifierGroups.removeAt(index);
              _modifiableModifierGroups.insert(index, modifiedModifierGroup);
            });
          },
          child: Container(
            padding: EdgeInsets.all(AppSize.s12.rSp),
            decoration: BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ModifierSwitchView(
                  menuVersion: group.menuVersion,
                  brandId: widget.brandId,
                  branchID: widget.branchId,
                  groupId: group.id,
                  enabled: group.isEnabled,
                  type: ModifierType.GROUP,
                  onSuccess: (enabled) {
                    setState(() {
                      _modifiableModifierGroups[index].isEnabled = enabled;
                    });
                  },
                ),
                AppSize.s12.horizontalSpacer(),
                Expanded(
                  child: Text(
                    group.title.trim(),
                    style: mediumTextStyle(
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
      separatorBuilder: (BuildContext context, int index) {
        return AppSize.s8.verticalSpacer();
      },
    );
  }
}
