import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/modal_sheet_manager.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/brand_selection_view.dart';
import 'package:klikit/modules/base/order_counter.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

class AddOrderAppBar extends StatefulWidget {
  final Brand? initialBrand;
  final Function(Brand) onChanged;
  final VoidCallback onBack;
  final VoidCallback onCartTap;

  const AddOrderAppBar({
    Key? key,
    required this.onChanged,
    required this.onBack,
    required this.onCartTap,
    required this.initialBrand,
  }) : super(key: key);

  @override
  State<AddOrderAppBar> createState() => _AddOrderAppBarState();
}

class _AddOrderAppBarState extends State<AddOrderAppBar> {
  String? _brandName;

  @override
  void initState() {
    _brandName = widget.initialBrand?.title ?? AppStrings.select_brand.tr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onBack,
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.neutralB700,
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              ModalSheetManager.openBottomSheet(
                context,
                BrandSelectionView(
                  onBrandSelected: (brand){
                    widget.onChanged(brand);
                    setState(() {
                      _brandName = brand.title;
                    });
                  },
                ),
                title: AppStrings.select_brand.tr(),
                subTitle: 'Choose your preferred brand',
                isScrollControlled: false,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _brandName!,
                  style: semiBoldTextStyle(
                    color: AppColors.neutralB700,
                    fontSize: 18.rSp,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.neutralB700,
                  size: 28.rSp,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.rw,vertical: 6.rh),
          child: OrderCounter(onCartTap: widget.onCartTap),
        ),
      ],
    );
  }
}
