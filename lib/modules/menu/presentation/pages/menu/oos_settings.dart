import 'package:easy_localization/easy_localization.dart';
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
import '../../../../widgets/app_button.dart';
import '../../../../widgets/loading_button.dart';
import '../../../domain/entities/menu/menu_item.dart';
import '../../../domain/entities/menu/menu_out_of_stock.dart';
import '../../cubit/update_item_snooze_cubit.dart';
import 'menu_switch_view.dart';

enum OOS {
  day_1,
  day_3,
  day_7,
  hour,
  default_,
}

void showOosDialog({
  required MenuCategoryItem menuCategoryItem,
  required Function(bool) onMenuEnableChanged,
  required Function(MenuOutOfStock) onItemSnoozeChanged,
  required int brandId,
  required int providerId,
  required bool parentEnabled,
}) {
  showDialog(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    builder: (BuildContext context) {
      return BlocProvider<UpdateItemSnoozeCubit>(
        create: (_) => getIt.get<UpdateItemSnoozeCubit>(),
        child: AlertDialog(
          title: Text(AppStrings.out_of_stock_settings.tr()),
          content: OutOfStockSettingScreen(
            menuCategoryItem: menuCategoryItem,
            brandId: brandId,
            providerId: providerId,
            parentEnabled: parentEnabled,
            onMenuEnableChanged: onMenuEnableChanged,
            onItemSnoozeChanged: onItemSnoozeChanged,
          ),
        ),
      );
    },
  );
}

class OutOfStockSettingScreen extends StatefulWidget {
  final MenuCategoryItem menuCategoryItem;
  final int brandId;
  final int providerId;
  final bool parentEnabled;
  final Function(bool) onMenuEnableChanged;
  final Function(MenuOutOfStock) onItemSnoozeChanged;

  const OutOfStockSettingScreen({
    Key? key,
    required this.menuCategoryItem,
    required this.brandId,
    required this.providerId,
    required this.parentEnabled,
    required this.onMenuEnableChanged,
    required this.onItemSnoozeChanged,
  }) : super(key: key);

  @override
  State<OutOfStockSettingScreen> createState() => _OutOfStockSettingScreenState();
}

class _OutOfStockSettingScreenState extends State<OutOfStockSettingScreen> {
  late int _currentDuration;

  @override
  void initState() {
    _currentDuration = widget.menuCategoryItem.outOfStock.menuSnooze.duration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  AppStrings.out_of_stock.tr(),
                  style: mediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                child: MenuSwitchView(
                  menuVersion: widget.menuCategoryItem.menuVersion,
                  id: widget.menuCategoryItem.id,
                  brandId: widget.brandId,
                  providerId: widget.providerId,
                  type: MenuType.ITEM,
                  enabled: widget.menuCategoryItem.enabled,
                  parentEnabled: widget.parentEnabled,
                  willShowBg: false,
                  onMenuEnableChanged: (enabled) {
                    widget.onMenuEnableChanged(enabled);
                    Navigator.pop(context);
                  },
                ),
              ),
              if (widget.menuCategoryItem.outOfStock.menuSnooze.endTime.isNotEmpty)
                Flexible(
                  child: Text(
                    '(${AppStrings.out_of_stock_till.tr()} ${DateTimeFormatter.parseSnoozeEndTime(widget.menuCategoryItem.outOfStock.menuSnooze.endTime)})',
                    style: mediumTextStyle(
                      color: AppColors.redDark,
                      fontSize: AppFontSize.s12.rSp,
                    ),
                  ),
                ),
            ],
          ),
          Divider(color: AppColors.primaryLight),
          OutOfStockRadioGroup(
            oos: widget.menuCategoryItem.outOfStock,
            onDurationChanged: (duration) {
              _currentDuration = duration;
            },
          ),
          SizedBox(height: AppSize.s8.rh),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: AppStrings.cancel.tr(),
                  textColor: AppColors.black,
                  color: AppColors.white,
                  borderColor: AppColors.black,
                ),
              ),
              SizedBox(width: AppSize.s8.rw),
              Expanded(
                child: BlocConsumer<UpdateItemSnoozeCubit, ResponseState>(
                  listener: (BuildContext context, state) {
                    if (state is Failed) {
                      showApiErrorSnackBar(context, state.failure);
                    } else if (state is Success<MenuOutOfStock>) {
                      showSuccessSnackBar(
                        context,
                        AppStrings.stock_disabled_successful.tr(),
                      );
                      widget.onItemSnoozeChanged(state.data);
                      Navigator.pop(context);
                    }
                  },
                  builder: (BuildContext context, state) {
                    return LoadingButton(
                      onTap: () {
                        context.read<UpdateItemSnoozeCubit>().updateItem(
                              menuVersion: widget.menuCategoryItem.menuVersion,
                              brandId: widget.brandId,
                              itemId: widget.menuCategoryItem.id,
                              enabled: widget.menuCategoryItem.enabled,
                              duration: _currentDuration,
                            );
                      },
                      text: AppStrings.update.tr(),
                      isLoading: state is Loading,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OutOfStockRadioGroup extends StatefulWidget {
  final MenuOutOfStock oos;
  final Function(int) onDurationChanged;

  const OutOfStockRadioGroup({
    Key? key,
    required this.oos,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  State<OutOfStockRadioGroup> createState() => _OutOfStockRadioGroupsState();
}

class _OutOfStockRadioGroupsState extends State<OutOfStockRadioGroup> {
  static const maxDuration = 8760;
  OOS? _groupValue;
  late TextEditingController _textEditingController;
  final _textStyle = regularTextStyle(
    color: AppColors.black,
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
      if (duration > maxDuration) {
        _textEditingController.text = maxDuration.toString();
        _textEditingController.selection = TextSelection.collapsed(offset: _textEditingController.text.length);
        widget.onDurationChanged(maxDuration);
      } else {
        widget.onDurationChanged(text.toInt());
      }
    }
  }

  void _setInitHours(String hour) {
    _textEditingController.text = hour;
  }

  void _setInitGroupValue() {
    final duration = widget.oos.menuSnooze.duration;
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
          activeColor: AppColors.primary,
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
          activeColor: AppColors.primary,
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
          activeColor: AppColors.primary,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
              widget.onDurationChanged(DurationType.day_7);
            });
          },
        ),
        RadioListTile<OOS>(
          title: TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            controller: _textEditingController,
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide:  BorderSide(color: AppColors.greyDarker),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(color: AppColors.greyDarker),
              ),
              labelText: AppStrings.hours.tr(),
              labelStyle: _textStyle,
              floatingLabelStyle: _textStyle,
            ),
          ),
          groupValue: _groupValue,
          value: OOS.hour,
          activeColor: AppColors.primary,
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
          activeColor: AppColors.primary,
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
