import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_dropdown.dart';
import 'package:klikit/modules/orders/presentation/components/dialogs/action_dialogs.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/decorations.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../common/entities/provider.dart';

class FilterByAggregatorView extends StatefulWidget {
  final List<Provider> providers;
  final Function(Provider?) onChanged;

  const FilterByAggregatorView({Key? key, required this.providers, required this.onChanged}) : super(key: key);

  @override
  State<FilterByAggregatorView> createState() => _FilterByAggregatorViewState();
}

class _FilterByAggregatorViewState extends State<FilterByAggregatorView> {
  final dropDownTextStyle = regularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  late GlobalKey _dropdownKey;
  final _providers = <Provider>[];
  Provider dropDownValue = Provider(ZERO, 'All', EMPTY, EMPTY);

  @override
  void initState() {
    _providers.clear();
    _providers.add(dropDownValue);
    _providers.addAll(widget.providers);
    _dropdownKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s12.rh),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: prepareActionDecoration(
              ImageResourceResolver.filterSVG.getImageWidget(width: AppSize.s16.rw, height: AppSize.s16.rh, color: AppColors.neutralB600),
              AppColors.neutralB20,
            ),
          ),
          AppSize.s8.horizontalSpacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aggregators',
                style: mediumTextStyle(color: AppColors.neutralB600, fontSize: AppFontSize.s14.rSp),
              ),
              AppSize.s2.verticalSpacer(),
              Text(
                'Filter by aggregators',
                style: regularTextStyle(color: AppColors.neutralB300, fontSize: AppFontSize.s12.rSp),
              ),
            ],
          ),
          AppSize.s6.horizontalSpacer(),
          Expanded(
            child: KTDropdown(
              items: _providers,
              titleBuilder: (Provider item) {
                return item.id == dropDownValue.id ? '● ${item.title}' : '    ${item.title}';
              },
              hintText: AppStrings.select_brand.tr(),
              textStyle: mediumTextStyle(fontSize: AppSize.s14.rSp),
              hintTextStyle: regularTextStyle(fontSize: AppSize.s14.rSp),
              selectedItemBuilder: (Provider item, bool isSelected) {
                return item.title;
              },
              selectedItem: dropDownValue,
              onSelected: (Provider selectedItem) async {
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
          ),
        ],
      ),
    );
  }
}
