import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_dropdown.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class FilterByBrandsView extends StatefulWidget {
  final List<Brand> brands;
  final Function(Brand) onChanged;

  const FilterByBrandsView({Key? key, required this.brands, required this.onChanged}) : super(key: key);

  @override
  State<FilterByBrandsView> createState() => _FilterByBrandsViewState();
}

class _FilterByBrandsViewState extends State<FilterByBrandsView> {
  Brand? dropDownValue;
  late GlobalKey _dropdownKey;

  @override
  void initState() {
    _dropdownKey = GlobalKey();
    super.initState();
  }

  final dropDownTextStyle = regularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppStrings.select_brand.tr(),
          style: mediumTextStyle(color: AppColors.neutralB700, fontSize: AppFontSize.s14.rSp),
        ),
        AppSize.s8.verticalSpacer(),
        KTDropdown(
          items: widget.brands,
          titleBuilder: (Brand item) {
            return item.id == dropDownValue?.id ? '● ${item.title}' : '    ${item.title}';
          },
          hintText: AppStrings.select_brand.tr(),
          textStyle: mediumTextStyle(fontSize: AppSize.s14.rSp),
          hintTextStyle: regularTextStyle(fontSize: AppSize.s14.rSp),
          selectedItemBuilder: (Brand item, bool isSelected) {
            return item.title;
          },
          selectedItem: dropDownValue,
          onSelected: (Brand selectedItem) async {
            setState(() {
              dropDownValue = selectedItem;
              widget.onChanged(selectedItem);
            });
          },
          padding: EdgeInsets.symmetric(horizontal: AppSize.s14.rw),
          borderRadius: BorderRadius.circular(AppSize.s8.rSp),
          backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.white, strokeColor: AppColors.neutralB40),
          trailingWidget: ImageResourceResolver.downArrowSVG.getImageWidget(width: 14.rw, height: 14.rh, color: AppColors.neutralB700),
        ),
      ],
    );
  }
}
