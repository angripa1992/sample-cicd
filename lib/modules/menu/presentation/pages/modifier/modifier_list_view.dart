import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import 'modifer_switch_view.dart';

class ModifierListView extends StatefulWidget {
  final ModifiersGroup modifiersGroup;

  const ModifierListView({Key? key, required this.modifiersGroup})
      : super(key: key);

  @override
  State<ModifierListView> createState() => _ModifierListViewState();
}

class _ModifierListViewState extends State<ModifierListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.modifiersGroup.modifiers.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                  child: Text(
                    widget.modifiersGroup.modifiers[index].title,
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              ),
              //ModifierSwitchView(),
            ],
          );
        },
        separatorBuilder: (_, __) {
          return const Divider();
        },
      ),
    );
  }
}
