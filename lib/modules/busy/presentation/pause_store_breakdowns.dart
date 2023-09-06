import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/busy/presentation/pause_store_toogle_button.dart';
import 'package:klikit/resources/strings.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../domain/entity/pause_store_data.dart';

class PauseStoreBreakdownView extends StatelessWidget {
  final PauseStoresData data;
  const PauseStoreBreakdownView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.pause_store.tr(),
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Store',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s18.rSp,
                ),
              ),
              PauseStoreToggleButton(isBusy: data.isBusy),
            ],
          ),
          Divider(color: AppColors.black),
          ListView.builder(
            itemBuilder: (_,index){
              return Row(
                children: [

                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
