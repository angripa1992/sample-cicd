import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/modifier_provider.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_group_info.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_list_view.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class ManageModifiersScreen extends StatelessWidget {
  const ManageModifiersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final modifierGroup = args['group'];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text('Manage Modifiers'),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: AppSize.s10.rh,
          horizontal: AppSize.s16.rw,
        ),
        child: Column(
          children: [
            ModifierGroupInfoView(modifiersGroup: modifierGroup),
            SizedBox(height: AppSize.s32.rh),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(AppSize.s4.rSp)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s8.rh,
                  horizontal: AppSize.s12.rw,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Title',
                      style: getRegularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s16.rSp,
                      ),
                    ),
                    Text(
                      'Action',
                      style: getRegularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s16.rSp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ModifierListView(modifiersGroup: modifierGroup),
          ],
        ),
      ),
    );
  }
}
