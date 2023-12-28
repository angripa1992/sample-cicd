import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/modules/busy/presentation/pause_store_breakdowns.dart';
import 'package:klikit/modules/busy/presentation/pause_store_timer_view.dart';
import 'package:klikit/modules/busy/presentation/pause_store_toogle_button.dart';
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
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.s16.rSp),
        ),
      ),
      builder: (ct) {
        return BlocProvider(
          create: (_) => getIt.get<FetchPauseStoreDataCubit>(),
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: PauseStoreBreakdownView(),
          ),
        );
      },
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
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        );
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
        ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s12),
        KTChip(
          text: data.isBusy == true ? 'Enable' : 'Disabled',
          textStyle: mediumTextStyle(fontSize: AppSize.s10.rSp, color: AppColors.neutralB700),
          strokeColor: AppColors.neutralB40,
          backgroundColor: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 8.rw, vertical: 2.rh),
        ),
        AppSize.s16.horizontalSpacer(),
        data.isBusy
            ? PauseStoreTimerView(
                duration: data.duration,
                timeLeft: data.timeLeft,
                onFinished: _fetchData,
              )
            : (noOfPausedStore > 0 ? Text('$noOfPausedStore ${AppStrings.paused.tr()}') : const SizedBox()),
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
