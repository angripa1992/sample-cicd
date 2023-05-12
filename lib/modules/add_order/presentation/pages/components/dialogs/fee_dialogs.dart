import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../widgets/snackbars.dart';

enum FeeType { discount, delivery, additional }

class FeeDialogView extends StatefulWidget {
  final int initType;
  final num initValue;
  final FeeType feeType;
  final num subTotal;
  final Function(int, num, FeeType) onSave;

  const FeeDialogView({
    Key? key,
    required this.initType,
    required this.initValue,
    required this.feeType,
    required this.onSave,
    required this.subTotal,
  }) : super(key: key);

  @override
  State<FeeDialogView> createState() => _FeeDialogViewState();
}

class _FeeDialogViewState extends State<FeeDialogView> {
  final _controller = TextEditingController();
  late int _type;
  bool _editable = false;
  late FeeType _feeType;
  String? _validateMsg;

  @override
  void initState() {
    if (widget.initValue > 0) {
      _editable = true;
      _controller.text = widget.initValue.toString();
    }
    _type = widget.initType;
    _feeType = widget.feeType;
    super.initState();
  }

  String _title() {
    if (_editable) {
      return 'Change Amount';
    } else if (_feeType == FeeType.discount) {
      return AppStrings.discount.tr();
    } else if (_feeType == FeeType.delivery) {
      return AppStrings.delivery_fee.tr();
    } else {
      return AppStrings.additional_fee.tr();
    }
  }

  String? _validate(){
    final text = _controller.text;
    final amountString = text.isEmpty ? '0' : text;
    final amount = num.parse(amountString);
    if(_feeType == FeeType.discount){
      if(_type == DiscountType.flat){
        if(amount > widget.subTotal){
          return 'Can\'t be greater than the subtotal' ;
        }
      }else{
        if(amount > 100){
          return 'Can\'t be greater than 100' ;
        }
      }
    }
    return null;
  }

  void _save(){
    final validate = _validate();
    setState(() {
      _validateMsg = validate;
    });
    if(validate == null){
      Navigator.pop(context);
      final value = _controller.text.isEmpty ? '0' : _controller.text;
      widget.onSave(_type, num.parse(value), _feeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _title(),
              style: getMediumTextStyle(
                color: AppColors.balticSea,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
        if (_type != DiscountType.none)
          DiscountTypeSelector(
            initValue: _type,
            onChange: (type) {
              _type = type;
              _controller.text = '0';
            },
          ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: AppSize.s16.rh,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            color: AppColors.seaShell,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s8.rw,
            ),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: _validateMsg,
                hintText: 'Add ${_title()}',
                hintStyle: getRegularTextStyle(
                  color: AppColors.dustyGreay,
                  fontSize: AppFontSize.s14.rSp,
                ),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleBlue, // Background color
            ),
            child: Text(
              'Save',
              style: getMediumTextStyle(
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscountTypeSelector extends StatefulWidget {
  final int initValue;
  final Function(int) onChange;

  const DiscountTypeSelector({
    Key? key,
    required this.initValue,
    required this.onChange,
  }) : super(key: key);

  @override
  State<DiscountTypeSelector> createState() => _DiscountTypeSelector();
}

class _DiscountTypeSelector extends State<DiscountTypeSelector> {
  late int _type;

  @override
  void initState() {
    _type = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discount Type',
            style: getMediumTextStyle(
              color: AppColors.balticSea,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          Column(
            children: [
              RadioListTile<int>(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.purpleBlue,
                title: Text(
                  'Flat',
                  style: getRegularTextStyle(
                    color: AppColors.dustyGreay,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
                value: DiscountType.flat,
                groupValue: _type,
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                    widget.onChange(_type);
                  });
                },
              ),
              RadioListTile<int>(
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.purpleBlue,
                title: Text(
                  'Percentage',
                  style: getRegularTextStyle(
                    color: AppColors.dustyGreay,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
                value: DiscountType.percentage,
                groupValue: _type,
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                    widget.onChange(_type);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}