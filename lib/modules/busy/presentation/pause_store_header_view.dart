import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/busy/presentation/pause_store_breakdowns.dart';
import 'package:klikit/modules/busy/presentation/pause_store_timer_view.dart';
import 'package:klikit/modules/busy/presentation/pause_store_toogle_button.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s4.rSp),
        color: AppColors.white,
      ),
      child: BlocConsumer<FetchPauseStoreDataCubit, ResponseState>(
        listener: (ct,state){
          if(state is Failed){
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
      ),
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
            color: AppColors.black,
            fontSize: AppFontSize.s16.rSp,
          ),
        ),
        SizedBox(width: AppSize.s16.rw),
        data.isBusy
            ? PauseStoreTimerView(
                duration: data.duration,
                timeLeft: data.timeLeft,
                onFinished: _fetchData,
              )
            : (noOfPausedStore > 0 ? Text('$noOfPausedStore ${AppStrings.paused.tr()}') : const SizedBox()),
        const Spacer(),
        IconButton(
          onPressed: () {
            _showBreakDowns();
          },
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.black,
          ),
        )
      ],
    );
  }
}
