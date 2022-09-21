import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_state.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/values.dart';

class BusyModeView extends StatefulWidget {
  const BusyModeView({Key? key}) : super(key: key);

  @override
  State<BusyModeView> createState() => _BusyModeViewState();
}

class _BusyModeViewState extends State<BusyModeView> {

  @override
  void initState() {
    context.read<BusyModeCubit>().test();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusyModeCubit, BusyModeState>(
      builder: (context, state) {
        print('=========builder $state');
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (state is Available)
                ? _getAvailableIcon()
                : _getOfflineIcon((state as Offline).minute.toString()),
            SizedBox(width: AppSize.s12.rw),
            Text(
              AppStrings.busy_mode.tr(),
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            Switch(
              onChanged: (isAvailable) {
                print('====on change $isAvailable');
                if (isAvailable) {
                  context.read<BusyModeCubit>().changeOfflineToAvailable();
                } else {
                  context.read<BusyModeCubit>().changeToOffline();
                }
              },
              value: state is Available,
              activeColor: AppColors.purpleBlue,
              activeTrackColor: AppColors.smokeyGrey,
              inactiveThumbColor: AppColors.black,
              inactiveTrackColor: AppColors.smokeyGrey,
            ),
          ],
        );
      },
      listener: (context, state) {
        print('=========listener $state');
      },
    );
  }

  Widget _getAvailableIcon() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          padding: EdgeInsets.all(AppSize.s16.rSp),
          decoration: BoxDecoration(
              color: AppColors.purpleBlue.withOpacity(0.5),
              shape: BoxShape.circle),
        ),
        Container(
          padding: EdgeInsets.all(AppSize.s8.rSp),
          decoration: BoxDecoration(
              color: AppColors.purpleBlue, shape: BoxShape.circle),
        ),
      ],
    );
  }

  Widget _getOfflineIcon(String minute) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.lightSalmon.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.warmRed)),
      child: Padding(
        padding: EdgeInsets.all(AppSize.s10.rSp),
        child: Text(
          minute,
          style: getRegularTextStyle(
            color: AppColors.warmRed,
            fontSize: AppFontSize.s15.rSp,
          ),
        ),
      ),
    );
  }
}
