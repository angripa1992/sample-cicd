import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifer_switch_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/modifiers_group.dart';

class ModifierGroupsListView extends StatefulWidget {
  final int brandId;
  final int providerId;
  final List<ModifiersGroup> modifierGroups;

  const ModifierGroupsListView({
    Key? key,
    required this.modifierGroups,
    required this.brandId,
    required this.providerId,
  }) : super(key: key);

  @override
  State<ModifierGroupsListView> createState() => _ModifierGroupsListViewState();
}

class _ModifierGroupsListViewState extends State<ModifierGroupsListView> {
  var _modifiableModifierGroups = <ModifiersGroup>[];

  @override
  void initState() {
    _modifiableModifierGroups = widget.modifierGroups;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.s8.rh),
      child: ListView.separated(
        key: UniqueKey(),
        itemCount: _modifiableModifierGroups.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final group = _modifiableModifierGroups[index];
          return InkWell(
            onTap: () async {
              SegmentManager().track(
                event: SegmentEvents.MODIFIER_CLICK,
                properties: {
                  'id': group.groupId,
                  'group_name': group.title,
                },
              );
              final modifiedModifierGroup = await Navigator.pushNamed(
                context,
                Routes.manageModifiers,
                arguments: {
                  ArgumentKey.kGROUP: group,
                  ArgumentKey.kBRAND_ID: widget.brandId,
                  ArgumentKey.kPROVIDER_ID: widget.providerId,
                },
              ) as ModifiersGroup;
              setState(() {
                _modifiableModifierGroups.removeAt(index);
                _modifiableModifierGroups.insert(index, modifiedModifierGroup);
              });
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                        child: Text(
                          group.title,
                          style: regularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s14.rSp,
                          ),
                        ),
                      ),
                    ),
                    ModifierSwitchView(
                      brandId: widget.brandId,
                      providerId: widget.providerId,
                      groupId: group.groupId,
                      enabled: group.statuses.isEmpty
                          ? false
                          : group.statuses[0].enabled,
                      type: ModifierType.GROUP,
                      onSuccess: (enabled) {
                        setState(() {
                          _modifiableModifierGroups[index].statuses[0].enabled =
                              enabled;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: AppSize.s12.rh,
          );
        },
      ),
    );
  }
}
