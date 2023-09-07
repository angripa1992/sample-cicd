import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/busy/presentation/pause_store_timer_view.dart';
import 'package:klikit/modules/busy/presentation/pause_store_toogle_button.dart';
import 'package:klikit/resources/strings.dart';

import '../../../core/utils/response_state.dart';
import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/snackbars.dart';
import '../domain/entity/pause_store_data.dart';
import 'bloc/fetch_pause_store_data_cubit.dart';

class PauseStoreBreakdownView extends StatefulWidget {
  const PauseStoreBreakdownView({Key? key}) : super(key: key);

  @override
  State<PauseStoreBreakdownView> createState() => _PauseStoreBreakdownViewState();
}

class _PauseStoreBreakdownViewState extends State<PauseStoreBreakdownView> {
  @override
  void initState() {
    context.read<FetchPauseStoreDataCubit>().fetchPauseStoreData();
    super.initState();
  }

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
                style: semiBoldTextStyle(
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
          Expanded(
            child: BlocBuilder<FetchPauseStoreDataCubit, ResponseState>(
              builder: (ct, state) {
                if (state is Failed) {
                  showApiErrorSnackBar(context, state.failure);
                  return const SizedBox();
                } else if (state is Success<PauseStoresData>) {
                  return _body(state.data);
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(PauseStoresData data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Store',
              style: semiBoldTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s18.rSp,
              ),
            ),
            PauseStoreToggleButton(
              isBusy: data.isBusy,
              isBranch: true,
            ),
          ],
        ),
        Divider(color: AppColors.black),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.breakdowns.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSize.s8.rh),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            data.breakdowns[index].brandName,
                            style: mediumTextStyle(
                              color: AppColors.black,
                              fontSize: AppFontSize.s14.rSp,
                            ),
                          ),
                          SizedBox(width: AppSize.s16.rw),
                          data.breakdowns[index].isBusy ? PauseStoreTimerView(duration: data.duration, timeLeft: data.timeLeft) : const SizedBox(),
                        ],
                      ),
                    ),
                    PauseStoreToggleButton(
                      isBusy: data.breakdowns[index].isBusy,
                      isBranch: false,
                      brandID: data.breakdowns[index].brandId,
                      scale: 0.65,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
