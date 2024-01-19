import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_item_details.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../resources/colors.dart';
import '../../../domain/entities/modifier/grouped_modifier_item.dart';
import '../../../domain/entities/modifier/modifier_group.dart';
import '../../cubit/check_affected_cubit.dart';
import 'modifer_switch_view.dart';

class ModifierListView extends StatefulWidget {
  final int brandId;
  final int branchID;
  final ModifierGroup modifierGroup;
  final Function(List<GroupedModifierItem>) onChanged;

  const ModifierListView({
    Key? key,
    required this.modifierGroup,
    required this.brandId,
    required this.onChanged,
    required this.branchID,
  }) : super(key: key);

  @override
  State<ModifierListView> createState() => _ModifierListViewState();
}

class _ModifierListViewState extends State<ModifierListView> {
  void _showItemDetails(int index) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(14.rSp),
        ),
      ),
      builder: (BuildContext context) {
        return BlocProvider(
          create: (_) => getIt.get<CheckAffectedCubit>(),
          child: SizedBox(
            height: ScreenSizes.screenHeight / 1.5,
            child: ModifierItemDetails(
              item: widget.modifierGroup.modifiers[index],
              groupID: widget.modifierGroup.id,
              menuVersion: widget.modifierGroup.menuVersion,
              brandID: widget.brandId,
              branchID: widget.branchID,
              onEnabledChanged: (enabled) {
                setState(() {
                  widget.modifierGroup.modifiers[index].isEnabled = enabled;
                  widget.onChanged(widget.modifierGroup.modifiers);
                });
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
      child: Expanded(
        child: ListView.separated(
          key: UniqueKey(),
          itemCount: widget.modifierGroup.modifiers.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (widget.modifierGroup.menuVersion == MenuVersion.v2) {
                          _showItemDetails(index);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.modifierGroup.modifiers[index].title.trim(),
                            style: regularTextStyle(
                              color: AppColors.black,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                          Text(
                            widget.modifierGroup.modifiers[index].klikitPrice(),
                            style: regularTextStyle(
                              color: AppColors.black,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ModifierSwitchView(
                    menuVersion: widget.modifierGroup.menuVersion,
                    branchID: widget.branchID,
                    brandId: widget.brandId,
                    groupId: widget.modifierGroup.id,
                    modifierId: widget.modifierGroup.modifiers[index].id,
                    enabled: widget.modifierGroup.modifiers[index].isEnabled,
                    type: ModifierType.MODIFIER,
                    onSuccess: (enabled) {
                      setState(() {
                        widget.modifierGroup.modifiers[index].isEnabled = enabled;
                        widget.onChanged(widget.modifierGroup.modifiers);
                      });
                    },
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(thickness: AppSize.s1.rh);
          },
        ),
      ),
    );
  }
}
