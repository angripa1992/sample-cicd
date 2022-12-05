import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_cubit.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/busy_mode_state.dart';
import 'package:klikit/modules/orders/presentation/bloc/busy/update_busy_mode_cubit.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/utils/response_state.dart';
import '../../../../resources/values.dart';
import '../../../widgets/loading_button.dart';
import '../../../widgets/snackbars.dart';
import '../../domain/entities/busy_mode.dart';

class BusyModeView extends StatefulWidget {
  const BusyModeView({Key? key}) : super(key: key);

  @override
  State<BusyModeView> createState() => _BusyModeViewState();
}

class _BusyModeViewState extends State<BusyModeView> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BusyModeCubit, BusyModeState>(
          listener: (context, state) {
            if (state is Offline) {
              if (state.minute == 0) {
                context.read<UpdateBusyModeCubit>().updateStatus(false);
              }
            }
          },
        ),
        BlocListener<UpdateBusyModeCubit, ResponseState>(
          listener: (context, state) {
            if (state is Success<BusyModePostResponse>) {
              if (state.data.isBusy) {
                context.read<BusyModeCubit>().changeToOffline(
                      duration: state.data.duration,
                      timeLeft: state.data.timeLeft,
                    );
              } else {
                context.read<BusyModeCubit>().changeToAvailable();
              }
              if (mounted) {
                showSuccessSnackBar(context, state.data.message);
              }
            } else if (state is Failed) {
              if (mounted) {
                showErrorSnackBar(context, state.failure.message);
              }
            }
          },
        ),
      ],
      child: BlocBuilder<BusyModeCubit, BusyModeState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (state is Available)
                  ? _getAvailableIcon()
                  : _getOfflineIcon((state as Offline).minute),
              SizedBox(width: AppSize.s12.rw),
              Text(
                AppStrings.busy_mode.tr(),
                style: getRegularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              Switch(
                onChanged: (willGoOffline) {
                  showBusyModeConfirmDialog(
                    isBusy: willGoOffline,
                    updateBLoc: context.read<UpdateBusyModeCubit>(),
                    busyBLoc: context.read<BusyModeCubit>(),
                  );
                },
                value: state is Offline,
                activeColor: AppColors.black,
                activeTrackColor: AppColors.smokeyGrey,
                inactiveThumbColor: AppColors.purpleBlue,
                inactiveTrackColor: AppColors.smokeyGrey,
              ),
            ],
          );
        },
      ),
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

  Widget _getOfflineIcon(int minute) {
    return CircularPercentIndicator(
      radius: 20.0,
      lineWidth: 4.0,
      percent: (60 - minute) / 60,
      center: Text("$minute"),
      progressColor: AppColors.green,
    );
  }

  void showBusyModeConfirmDialog({
    required bool isBusy,
    required UpdateBusyModeCubit updateBLoc,
    required BusyModeCubit busyBLoc,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider<UpdateBusyModeCubit>.value(
          value: updateBLoc,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSize.s16.rSp),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isBusy
                      ? AppStrings.offline_title.tr()
                      : AppStrings.online_title.tr(),
                  textAlign: TextAlign.center,
                  style: getMediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s17.rSp,
                  ),
                ),
                SizedBox(
                  height: AppSize.s16.rh,
                ),
                Text(
                  isBusy
                      ? AppStrings.offline_message.tr()
                      : AppStrings.online_message.tr(),
                  textAlign: TextAlign.center,
                  style: getRegularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
                SizedBox(
                  height: AppSize.s24.rh,
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BlocConsumer<UpdateBusyModeCubit, ResponseState>(
                          listener: (_, state) {
                            if (state is Success<BusyModePostResponse>) {
                              Navigator.of(context).pop();
                            } else if (state is Failed) {
                              Navigator.of(context).pop();
                            }
                          },
                          builder: (context, state) {
                            return LoadingButton(
                              onTap: () {
                                updateBLoc.updateStatus(isBusy);
                              },
                              isLoading: (state is Loading),
                              text: isBusy
                                  ? AppStrings.go_offline.tr()
                                  : AppStrings.go_online.tr(),
                              bgColor:
                                  isBusy ? AppColors.warmRed : AppColors.green,
                              borderColor:
                                  isBusy ? AppColors.warmRed : AppColors.green,
                              textSize: AppFontSize.s14.rSp,
                              verticalPadding: AppSize.s8.rh,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Center(
                            child: Text(
                              AppStrings.not_now.tr(),
                              style: getMediumTextStyle(
                                color: AppColors.purpleBlue,
                                fontSize: AppFontSize.s16.rSp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
