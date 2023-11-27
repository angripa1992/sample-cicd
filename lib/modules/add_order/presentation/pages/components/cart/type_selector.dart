import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/tag_title.dart';
import 'package:klikit/modules/widgets/app_button.dart';
import 'package:klikit/resources/assets.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../utils/cart_manager.dart';

class TypeSelector extends StatefulWidget {
  final int initialType;
  final Function(int) onTypeChange;

  const TypeSelector({
    Key? key,
    required this.initialType,
    required this.onTypeChange,
  }) : super(key: key);

  @override
  State<TypeSelector> createState() => _TypeSelectorState();
}

class _TypeSelectorState extends State<TypeSelector> {
  final _types = [OrderType.DINE_IN, OrderType.PICKUP, OrderType.DELIVERY];
  int? _currentType;

  @override
  void initState() {
    _currentType = widget.initialType;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TypeSelector oldWidget) {
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
    return Container(
      margin: EdgeInsets.only(
        bottom: AppSize.s8.rh,
        left: AppSize.s16.rw,
        right: AppSize.s16.rw,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s8.rw,
        vertical: AppSize.s8.rh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.s8.rSp),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TagTitleView(title: AppStrings.order_type.tr(), required: true),
          SizedBox(height: AppSize.s4.rh),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSize.s8.rw,
            children: _types.map((type) {
              return ChoiceChip(
                label: Text(_typeName(type)),
                avatar: Icon(
                  _typeIcon(type),
                  size: AppSize.s16.rSp,
                  color: _currentType == type ? AppColors.white : AppColors.greyDarker,
                ),
                selected: _currentType == type,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.grey,
                labelStyle: mediumTextStyle(
                  color: _currentType == type ? AppColors.white : AppColors.greyDarker,
                  fontSize: AppFontSize.s12.rSp,
                ),
                onSelected: (bool selected) {
                  if (CartManager().items.isNotEmpty) {
                    _showConfirmDialog(selected, type);
                  } else {
                    _changeOrderType(selected, type);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
