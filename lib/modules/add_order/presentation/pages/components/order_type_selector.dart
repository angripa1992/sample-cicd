import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/widgets/app_button.dart';
import 'package:klikit/resources/assets.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class OrderTypeSelector extends StatefulWidget {
  final int initialType;
  final Function(int) onTypeChange;

  const OrderTypeSelector({
    Key? key,
    required this.initialType,
    required this.onTypeChange,
  }) : super(key: key);

  @override
  State<OrderTypeSelector> createState() => _OrderTypeSelectorState();
}

class _OrderTypeSelectorState extends State<OrderTypeSelector> {
  final _types = [OrderType.DINE_IN, OrderType.PICKUP, OrderType.DELIVERY];
  int? _currentType;

  @override
  void initState() {
    _currentType = widget.initialType;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OrderTypeSelector oldWidget) {
    setState(() {
      _currentType = widget.initialType;
    });
    super.didUpdateWidget(oldWidget);
  }

  String _typeName(int type) {
    switch (type) {
      case OrderType.DINE_IN:
        return AppStrings.dine_in.tr();
      case OrderType.DELIVERY:
        return AppStrings.deliver.tr();
      default:
        return AppStrings.pickup.tr();
    }
  }

  IconData _typeIcon(int type) {
    switch (type) {
      case OrderType.DINE_IN:
        return Icons.dinner_dining_rounded;
      case OrderType.DELIVERY:
        return Icons.delivery_dining_rounded;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _showConfirmDialog(bool selected, int orderType) {
    showDialog(
      context: context,
      builder: (dContext) => AlertDialog(
        icon: SvgPicture.asset(AppIcons.alert),
        title: const Text('Price Update Alert!'),
        content: const Text('The price of the item may vary based on the selected order type. Confirm to apply changes.'),
        actions: [
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onTap: () {
                    Navigator.pop(dContext);
                  },
                  text: AppStrings.cancel.tr(),
                  color: AppColors.white,
                  borderColor: AppColors.black,
                  textColor: AppColors.black,
                ),
              ),
              SizedBox(width: AppSize.s16.rw),
              Expanded(
                child: AppButton(
                  onTap: () {
                    Navigator.pop(dContext);
                    _changeOrderType(selected, orderType);
                  },
                  text: 'Confirm',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changeOrderType(bool selected, int orderType) {
    setState(() {
      _currentType = (selected ? orderType : OrderType.DINE_IN);
    });
    widget.onTypeChange(_currentType!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.order_type.tr(),
          style: semiBoldTextStyle(
            color: AppColors.neutralB700,
            fontSize: 16.rSp,
          ),
        ),
        SizedBox(height: 16.rh),
        Container(
          padding: EdgeInsets.all(AppSize.s4.rSp),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(AppSize.s12.rSp),
          ),
          child: Row(
            children: _types.map((type) {
              return _typeItem(
                name: _typeName(type),
                type: type,
                isSelected: _currentType == type,
                onChanged: (type) {
                  setState(() {
                    _currentType = type;
                  });
                  if (CartManager().items.isNotEmpty) {
                    _showConfirmDialog(_currentType == type, type);
                  } else {
                    _changeOrderType(_currentType == type, type);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _typeItem({
    required String name,
    required int type,
    required bool isSelected,
    required Function(int) onChanged,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onChanged(type);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: isSelected ? BoxDecoration(borderRadius: BorderRadius.circular(AppSize.s8.rSp), color: AppColors.white) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _typeIcon(type),
                  size: AppSize.s16.rSp,
                  color: isSelected ? AppColors.primary : AppColors.neutralB300,
                ),
                SizedBox(width: 4.rw),
                Text(
                  name,
                  style: mediumTextStyle(
                    color: isSelected ? AppColors.neutralB700 : AppColors.neutralB300,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
