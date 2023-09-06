import 'package:flutter/cupertino.dart';

import '../../../resources/colors.dart';

class PauseStoreToggleButton extends StatelessWidget {
  final bool isBusy;
  const PauseStoreToggleButton({Key? key, required this.isBusy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.75,
      child: CupertinoSwitch(
        onChanged: (willGoOffline) {
          // showBusyModeConfirmDialog(
          //   isBusy: willGoOffline,
          //   updateBLoc: context.read<UpdateBusyModeCubit>(),
          //   busyBLoc: context.read<BusyModeCubit>(),
          // );
        },
        value: isBusy,
        activeColor: AppColors.black,
        trackColor: AppColors.primary,
      ),
    );
  }
}
