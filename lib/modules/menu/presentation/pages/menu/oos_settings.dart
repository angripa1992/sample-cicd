import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/app_button.dart';
import '../../../domain/entities/items.dart';
import '../../../domain/entities/stock.dart';

enum OOS {
  day_1,
  day_3,
  day_7,
  hour,
  default_,
}

void showOosDialog(MenuItems items) {
  showDialog(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     top: Radius.circular(AppSize.s16.rSp),
    //   ),
    // ),
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSize.s16.rSp),
          ),
        ),
        contentPadding: EdgeInsets.zero,
        content: OutOfStockSettingScreen(item: items),
      );
    },
  );
}

class OutOfStockSettingScreen extends StatefulWidget {
  final MenuItems item;

  const OutOfStockSettingScreen({Key? key, required this.item})
      : super(key: key);

  @override
  State<OutOfStockSettingScreen> createState() =>
      _OutOfStockSettingScreenState();
}

class _OutOfStockSettingScreenState extends State<OutOfStockSettingScreen> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Out of Stock (OOS) Settings')),
            IconButton(onPressed: () {}, icon: Icon(Icons.cancel)),
          ],
        ),
        Row(
          children: [
            Text('Out of Stock'),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: _enabled,
                activeColor: AppColors.purpleBlue,
                trackColor: AppColors.blackCow,
                onChanged: (value) {
                  setState(() {
                    _enabled = true;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        Divider(),
        OutOfStockRadioGroup(stock: widget.item.stock),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppButton(
                enable: true,
                onTap: () {},
                text: 'Cancel',

              ),
            ),

            Expanded(
              child: AppButton(
                enable: true,
                onTap: () {},
                text: 'Update',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OutOfStockRadioGroup extends StatefulWidget {
  final Stock stock;

  const OutOfStockRadioGroup({Key? key, required this.stock}) : super(key: key);

  @override
  State<OutOfStockRadioGroup> createState() => _OutOfStockRadioGroupsState();
}

class _OutOfStockRadioGroupsState extends State<OutOfStockRadioGroup> {
  OOS? _groupValue;

  void _setInitGroupValue() {
    switch (widget.stock.snooze.duration) {
      case 24:
        _groupValue = OOS.day_1;
        return;
      case 72:
        _groupValue = OOS.day_3;
        return;
      case 168:
        _groupValue = OOS.day_7;
        return;
      case 0:
        _groupValue = OOS.default_;
        return;
      default:
        _groupValue = OOS.hour;
    }
  }

  @override
  void initState() {
    _setInitGroupValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<OOS>(
          title: const Text('1 Day'),
          groupValue: _groupValue,
          value: OOS.day_1,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
        RadioListTile<OOS>(
          title: const Text('3 Days'),
          groupValue: _groupValue,
          value: OOS.day_3,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
        RadioListTile<OOS>(
          title: const Text('7 Days'),
          groupValue: _groupValue,
          value: OOS.day_7,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
        RadioListTile<OOS>(
          title: const Text('Hours'),
          groupValue: _groupValue,
          value: OOS.hour,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
        RadioListTile<OOS>(
          title: const Text('Until turned back on'),
          groupValue: _groupValue,
          value: OOS.default_,
          onChanged: (OOS? value) {
            setState(() {
              _groupValue = value;
            });
          },
        ),
      ],
    );
  }
}
