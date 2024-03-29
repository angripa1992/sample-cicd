import 'dart:async';

import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';

class PauseStoreTimerView extends StatefulWidget {
  final int duration;
  final int timeLeft;
  final VoidCallback onFinished;

  const PauseStoreTimerView({
    Key? key,
    required this.duration,
    required this.timeLeft,
    required this.onFinished,
  }) : super(key: key);

  @override
  State<PauseStoreTimerView> createState() => _PauseStoreTimerViewState();
}

class _PauseStoreTimerViewState extends State<PauseStoreTimerView> {
  ValueNotifier<int>? _timerListener;
  Timer? _timer;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PauseStoreTimerView oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    _timerListener = ValueNotifier(widget.timeLeft);
    _startTimer(
      duration: widget.duration,
      timeLeft: widget.timeLeft,
    );
  }

  void _startTimer({required int timeLeft, required int duration}) {
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) async {
        _timerListener?.value = timeLeft - timer.tick;
        if (timer.tick == timeLeft) {
          _cancelTimer();
          await Future.delayed(const Duration(seconds: 5));
          widget.onFinished();
        }
      },
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s6.rw,
        vertical: AppSize.s4.rh,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutralB40),
        borderRadius: BorderRadius.circular(AppSize.s18.rSp),
        color: AppColors.white,
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.redDark,
            size: AppSize.s12.rSp,
          ),
          SizedBox(width: AppSize.s4.rw),
          ValueListenableBuilder<int>(
            valueListenable: _timerListener!,
            builder: (_, time, __) {
              return Text(
                '$time m',
                style: mediumTextStyle(
                  fontSize: AppFontSize.s10.rSp,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
