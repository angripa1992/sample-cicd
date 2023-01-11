import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class FilterByAggregatorView extends StatefulWidget {
  final List<Provider> providers;
  final Function(Provider?) onChanged;

  const FilterByAggregatorView(
      {Key? key, required this.providers, required this.onChanged})
      : super(key: key);

  @override
  State<FilterByAggregatorView> createState() => _FilterByAggregatorViewState();
}

class _FilterByAggregatorViewState extends State<FilterByAggregatorView> {
  final dropDownTextStyle = getRegularTextStyle(
    color: AppColors.black,
    fontSize: AppFontSize.s16.rSp,
  );

  late GlobalKey _dropdownKey;
  final _providers = <Provider>[];

  @override
  void initState() {
    _providers.clear();
    _providers.add(Provider(ZERO, 'All', EMPTY, EMPTY));
    _providers.addAll(widget.providers);
    _dropdownKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider? dropDownValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: AppSize.s4.rw, bottom: AppSize.s10.rh),
          child: Text(
            AppStrings.delivery_aggregator.tr(),
            style: getRegularTextStyle(
              color: AppColors.purpleBlue,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            color: AppColors.lightVioletTwo,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
            child: StatefulBuilder(
              builder: (_, setState) {
                return DropdownButton<Provider>(
                  key: _dropdownKey,
                  value: dropDownValue,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.purpleBlue,
                  ),
                  hint: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.select_aggregator.tr(),
                      style: dropDownTextStyle,
                    ),
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return _providers.map<Widget>((Provider item) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.title,
                          style: dropDownTextStyle,
                        ),
                      );
                    }).toList();
                  },
                  items: _providers.map<DropdownMenuItem<Provider>>(
                    (provider) {
                      return DropdownMenuItem<Provider>(
                        value: provider,
                        child: RadioListTile<Provider>(
                          title: Text(provider.title, style: dropDownTextStyle),
                          value: provider,
                          groupValue: dropDownValue,
                          activeColor: AppColors.purpleBlue,
                          onChanged: (value) {
                            Navigator.pop(_dropdownKey.currentContext!);
                            setState(() {
                              dropDownValue = value;
                              widget.onChanged(value);
                              // if (value!.id == ZERO) {
                              //   widget.onChanged(null);
                              // } else {
                              //   widget.onChanged(value);
                              // }
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
