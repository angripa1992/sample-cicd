import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifer_switch_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../domain/entities/modifiers_group.dart';

class ModifierGroupsListView extends StatefulWidget {
  final int brandId;
  final List<ModifiersGroup> modifierGroups;

  const ModifierGroupsListView(
      {Key? key, required this.modifierGroups, required this.brandId})
      : super(key: key);

  @override
  State<ModifierGroupsListView> createState() => _ModifierGroupsListViewState();
}

class _ModifierGroupsListViewState extends State<ModifierGroupsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.modifierGroups.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final group = widget.modifierGroups[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.manageModifiers,
                    arguments: {
                      'group': group,
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                  child: Text(
                    group.title,
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              ),
            ),
            ModifierSwitchView(
              brandId: widget.brandId,
              groupId: group.groupId,
              enabled: group.statuses.isEmpty ? false : group.statuses[0].enabled,
              type: ModifierType.GROUP,
              onSuccess: (enabled) {
                print('called ====================$enabled');
                setState(() {
                  widget.modifierGroups[index].statuses[0].enabled = enabled;
                });
              },
            ),
          ],
        );
      },
      separatorBuilder: (_, __) {
        return const Divider();
      },
    );
  }
}
