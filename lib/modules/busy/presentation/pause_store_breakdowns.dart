import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/core/widgets/popups.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/busy/presentation/pause_store_timer_view.dart';
import 'package:klikit/modules/busy/presentation/pause_store_toggle_button.dart';

import '../../../core/utils/response_state.dart';
import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
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
    _fetchData();
    super.initState();
  }

  void _fetchData() {
    context.read<FetchPauseStoreDataCubit>().fetchPauseStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchPauseStoreDataCubit, ResponseState>(
      listener: (context, state) {
        if (state is Failed) {
          showNotifierDialog(context, state.failure.message, false, title: "Failed!");
        }
      },
      child: BlocBuilder<FetchPauseStoreDataCubit, ResponseState>(
        builder: (ct, state) {
          if (state is Failed) {
            return AppSize.s200.verticalSpacer();
          } else if (state is Success<PauseStoresData>) {
            return _body(state.data);
          }
          return SizedBox(
            height: AppSize.s200.rh,
            child: Center(
              child: CircularProgress(
                primaryColor: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(PauseStoresData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.branchName,
              style: semiBoldTextStyle(
                color: AppColors.neutralB500,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            PauseStoreToggleButton(
              isBusy: data.isBusy,
              isBranch: true,
              onSuccess: _fetchData,
            ),
          ],
        ),
        Divider(color: AppColors.neutralB40).setVisibilityWithSpace(startSpace: 10, direction: Axis.vertical, endSpace: 10),
        if (data.breakdowns.isEmpty) AppSize.s200.verticalSpacer(),
        if (data.breakdowns.isNotEmpty)
          Flexible(
            fit: FlexFit.loose,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: data.breakdowns.length,
              itemBuilder: (_, index) {
                return PauseStoreBreakDownTile(
                  key: UniqueKey(),
                  data: data.breakdowns[index],
                  onFinished: _fetchData,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return 12.verticalSpacer();
              },
            ),
          ),
      ],
    );
  }
}

class PauseStoreBreakDownTile extends StatefulWidget {
  final PausedStore data;
  final VoidCallback onFinished;

  const PauseStoreBreakDownTile({super.key, required this.data, required this.onFinished});

  @override
  State<PauseStoreBreakDownTile> createState() => _PauseStoreBreakDownTileState();
}

class _PauseStoreBreakDownTileState extends State<PauseStoreBreakDownTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              KTNetworkImage(
                imageUrl: widget.data.brandLogo,
                width: AppSize.s28.rSp,
                height: AppSize.s28.rSp,
                boxShape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(AppSize.s4.rSp),
              ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s12),
              Text(
                widget.data.brandName,
                style: mediumTextStyle(
                  color: AppColors.neutralB500,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
              const Spacer(),
              if (widget.data.isBusy)
                PauseStoreTimerView(
                  duration: widget.data.duration,
                  timeLeft: widget.data.timeLeft,
                  onFinished: widget.onFinished,
                ).setVisibilityWithSpace(direction: Axis.horizontal, endSpace: AppSize.s20),
            ],
          ),
        ),
        PauseStoreToggleButton(
          isBusy: widget.data.isBusy,
          isBranch: false,
          brandID: widget.data.brandId,
          onSuccess: widget.onFinished,
        ),
      ],
    );
  }
}
