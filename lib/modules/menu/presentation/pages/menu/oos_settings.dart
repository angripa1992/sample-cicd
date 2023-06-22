import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/widgets/snackbars.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/di.dart';
import '../../../../../core/provider/date_time_provider.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/loading_button.dart';
import '../../../domain/entities/items.dart';
import '../../../domain/entities/stock.dart';
import '../../cubit/update_item_cubit.dart';
import 'menu_switch_view.dart';

enum OOS {
  day_1,
  day_3,
  day_7,
  hour,
  default_,
}

void showOosDialog({
  required MenuItems items,
  required Function(Stock) onChanged,
  required int brandId,
  required int providerId,
  required bool parentEnabled,
}) {
  showDialog(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    builder: (BuildContext context) {
      return BlocProvider<UpdateItemCubit>(
        create: (_) => getIt.get<UpdateItemCubit>(),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          content: OutOfStockSettingScreen(
            item: items,
            brandId: brandId,
            providerId: providerId,
            parentEnabled: parentEnabled,
            onChanged: onChanged,
          ),
        ),
      );
    },
  );
}

class OutOfStockSettingScreen extends StatefulWidget {
  final MenuItems item;
  final int brandId;
  final int providerId;
  final bool parentEnabled;
  final Function(Stock) onChanged;

  const OutOfStockSettingScreen({
    Key? key,
    required this.item,
    required this.brandId,
    required this.providerId,
    required this.parentEnabled,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OutOfStockSettingScreen> createState() =>
      _OutOfStockSettingScreenState();
}

class _OutOfStockSettingScreenState extends State<OutOfStockSettingScreen> {
  late int _currentDuration;

  @override
  void initState() {
    _currentDuration = widget.item.stock.snooze.duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s12.rw,
        vertical: AppSize.s8.rh,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.out_of_stock_settings.tr(),
                  style: getMediumTextStyle(
                    color: AppColors.dustyGrey,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: AppColors.dustyGrey,
                    size: AppSize.s16.rSp,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    AppStrings.out_of_stock.tr(),
                    style: getMediumTextStyle(
                      color: AppColors.balticSea,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                  child: MenuSwitchView(
                    id: widget.item.id,
                    brandId: widget.brandId,
                    providerId: widget.providerId,
                    type: MenuType.ITEM,
                    enabled: widget.item.stock.available,
                    parentEnabled: widget.parentEnabled,
                    willShowBg: false,
                    onItemChanged: (stock) {
                      widget.onChanged(stock);
                      Navigator.pop(context);
                    },
                    onMenuChanged: (enabled) {},
                  ),
                ),
                if (widget.item.stock.snooze.endTime.isNotEmpty)
                  Flexible(
                    child: Text(
                      '(${AppStrings.out_of_stock_till.tr()} ${DateTimeProvider.parseSnoozeEndTime(widget.item.stock.snooze.endTime)})',
                      style: getMediumTextStyle(
                        color: AppColors.warmRed,
                        fontSize: AppFontSize.s12.rSp,
                      ),
                    ),
                  ),
              ],
            ),
            Divider(color: AppColors.blueViolet),
            OutOfStockRadioGroup(
              stock: widget.item.stock,
              onDurationChanged: (duration) {
                _currentDuration = duration;
              },
            ),
            Divider(color: AppColors.blueViolet),
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: LoadingButton(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: AppStrings.cancel.tr(),
                      isLoading: false,
                      bgColor: Colors.transparent,
                      textColor: AppColors.purpleBlue,
                      verticalPadding: AppSize.s8.rh,
                    ),
                  ),
                  SizedBox(width: AppSize.s8.rw),
                  Expanded(
                    child: BlocConsumer<UpdateItemCubit, ResponseState>(
                      listener: (BuildContext context, state) {
                        if (state is Failed) {
                          showApiErrorSnackBar(context, state.failure);
                        } else if (state is Success<Stock>) {
                          showSuccessSnackBar(
                            context,
                            AppStrings.stock_disabled_successful.tr(),
                          );
                          widget.onChanged(state.data);
                          Navigator.pop(context);
                        }
                      },
                      builder: (BuildContext context, state) {
                        return LoadingButton(
                          onTap: () {
                            context.read<UpdateItemCubit>().updateItem(
                                  brandId: widget.brandId,
                                  itemId: widget.item.id,
                                  enabled: false,
                                  duration: _currentDuration,
                                );
                          },
                          text: AppStrings.update.tr(),
                          isLoading: state is Loading,
                          verticalPadding: AppSize.s8.rh,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutOfStockRadioGroup extends StatefulWidget {
  final Stock stock;
  final Function(int) onDurationChanged;

  const OutOfStockRadioGroup({
    Key? key,
    required this.stock,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  State<OutOfStockRadioGroup> createState() => _OutOfStockRadioGroupsState();
}

class _OutOfStockRadioGroupsState extends State<OutOfStockRadioGroup> {
  final MAX_DURATION = 8760;
  OOS? _groupValue;
  late TextEditingController _textEditingController;
  final _textStyle = getRegularTextStyle(
    color: AppColors.balticSea,
    fontSize: AppFontSize.s14.rSp,
  );

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _setInitGroupValue();
    _textEditingController.addListener(() {
      _setHours();
    });
    super.initState();
  }

  void _setHours() {
    final text = _textEditingController.text.trim();
    if (text.isNotEmpty) {
      final duration = text.toInt();
      if (duration > MAX_DURATION) {
        _textEditingController.text = MAX_DURATION.toString();
        _textEditingController.selection =
            TextSelection.collapsed(offset: _textEditingController.text.length);
        widget.onDurationChanged(MAX_DURATION);
      } else {
        widget.onDurationChanged(text.toInt());
      }
    }
  }

  void _setInitHours(String hour) {
    _textEditingController.text = hour;
  }

  void _setInitGroupValue() {
    final duration = widget.stock.snooze.duration;
    switch (duration) {
      case DurationType.day_1:
        _groupValue = OOS.day_1;
        _setInitHours("1");
        return;
      case DurationType.day_3:
        _groupValue = OOS.day_3;
        _setInitHours("1");
        return;
      case DurationType.day_7:
        _groupValue = OOS.day_7;
        _setInitHours("1");
        return;
      case DurationType.defaultTime:
        _groupValue = OOS.default_;
        _setInitHours("1");
        return;
      default:
        _groupValue = OOS.hour;
        _setInitHours(duration.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<OOS>(
          title: Text('1 ${AppStrings.day.tr()}', style: _textStyle),
          groupValue: _groupValue,
          value: OOS.day_1,
          activeColor: AppColors.purpleBlue,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
              widget.onDurationChanged(DurationType.day_1);
            });
          },
        ),
        RadioListTile<OOS>(
          title: Text('3 ${AppStrings.day.tr()}', style: _textStyle),
          groupValue: _groupValue,
          value: OOS.day_3,
          activeColor: AppColors.purpleBlue,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
              widget.onDurationChanged(DurationType.day_3);
            });
          },
        ),
        RadioListTile<OOS>(
          title: Text('7 ${AppStrings.day.tr()}', style: _textStyle),
          groupValue: _groupValue,
          value: OOS.day_7,
          activeColor: AppColors.purpleBlue,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
              widget.onDurationChanged(DurationType.day_7);
            });
          },
        ),
        RadioListTile<OOS>(
          title: Row(
            children: [
              Container(
                width: AppSize.s65.rw,
                // height: AppSize.s32.rh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                  color: AppColors.whiteSmoke,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.s8.rw,
                    vertical: AppSize.s8.rh,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    controller: _textEditingController,
                    cursorColor: AppColors.purpleBlue,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.s12.rw),
              Text(AppStrings.hours.tr(), style: _textStyle),
            ],
          ),
          groupValue: _groupValue,
          value: OOS.hour,
          activeColor: AppColors.purpleBlue,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
              _setHours();
            });
          },
        ),
        RadioListTile<OOS>(
          title: Text(AppStrings.untill_trun_back_on.tr(), style: _textStyle),
          groupValue: _groupValue,
          value: OOS.default_,
          activeColor: AppColors.purpleBlue,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
              widget.onDurationChanged(DurationType.defaultTime);
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
