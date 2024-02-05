import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/core/widgets/modal_sheet_manager.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/busy/presentation/pause_store_breakdowns.dart';
import 'package:klikit/modules/busy/presentation/pause_store_timer_view.dart';
import 'package:klikit/modules/busy/presentation/pause_store_toggle_button.dart';
import 'package:klikit/resources/resource_resolver.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/strings.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../widgets/snackbars.dart';
import '../domain/entity/pause_store_data.dart';
import 'bloc/fetch_pause_store_data_cubit.dart';

class PauseStoreHeaderView extends StatefulWidget {
  const PauseStoreHeaderView({Key? key}) : super(key: key);

  @override
  State<PauseStoreHeaderView> createState() => _PauseStoreHeaderViewState();
}

class _PauseStoreHeaderViewState extends State<PauseStoreHeaderView> {
  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    context.read<FetchPauseStoreDataCubit>().fetchPauseStoreData();
  }

  void _showBreakDowns() {
    ModalSheetManager.openBottomSheet(
      context,
      BlocProvider(
        create: (_) => getIt.get<FetchPauseStoreDataCubit>(),
        child: Padding(
          padding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: 10.rh, bottom: 20.rh),
          child: const PauseStoreBreakdownView(),
        ),
      ),
      title: AppStrings.pause_store.tr(),
      dismissible: false,
    ).then((value) {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchPauseStoreDataCubit, ResponseState>(
      listener: (ct, state) {
        if (state is Failed) {
          showApiErrorSnackBar(context, state.failure);
        }
      },
      builder: (ct, state) {
        if (state is Failed) {
          return const SizedBox();
        } else if (state is Success<PauseStoresData>) {
          return _body(state.data);
        }
        return const Center(child: CircularProgress());
      },
    );
  }

  int _numberOfPausedStore(PauseStoresData data) {
    int sum = 0;
    for (var element in data.breakdowns) {
      if (element.isBusy) {
        sum += 1;
      }
    }
    return sum;
  }

  Widget _body(PauseStoresData data) {
    final noOfPausedStore = _numberOfPausedStore(data);
    return Row(
      children: [
        PauseStoreToggleButton(
          isBusy: data.isBusy,
          isBranch: true,
          onSuccess: _fetchData,
        ),
        Text(
          AppStrings.pause_store.tr(),
          style: mediumTextStyle(
            color: AppColors.neutralB700,
            fontSize: AppFontSize.s12.rSp,
          ),
        ).setVisibilityWithSpace(startSpace: AppSize.s8, direction: Axis.horizontal, endSpace: AppSize.s4),
        Tooltip(
          message: 'Toggle pause store',
          child: ImageResourceResolver.infoSVG.getImageWidget(
            width: AppSize.s16.rw,
            height: AppSize.s16.rh,
          ),
        ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s8),
        data.isBusy
            ? PauseStoreTimerView(
                duration: data.duration,
                timeLeft: data.timeLeft,
                onFinished: _fetchData,
              )
            : KTChip(
                text: noOfPausedStore > 0 ? '$noOfPausedStore ${AppStrings.paused.tr()}' : AppStrings.enabled.tr(),
                textStyle: mediumTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.neutralB700),
                strokeColor: noOfPausedStore > 0 ? AppColors.errorR300 : AppColors.neutralB40,
                backgroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
              ),
        const Spacer(),
        InkWell(
          onTap: () {
            _showBreakDowns();
          },
          child: ImageResourceResolver.rightArrowSVG.getImageWidget(width: 16.rw, height: 16.rh, color: AppColors.neutralB50),
        ),
      ],
    );
  }
}
