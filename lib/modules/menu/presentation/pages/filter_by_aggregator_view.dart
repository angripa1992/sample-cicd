import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
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

  final _providers = <Provider>[];

  @override
  void initState() {
    _providers.clear();
    _providers.add(Provider(ZERO, 'All', EMPTY, EMPTY));
    _providers.addAll(widget.providers);
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
            'Aggregator',
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
                      'Select Aggregator',
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
                        child: Row(
                          children: [
                            Radio(
                              value: provider,
                              groupValue: dropDownValue,
                              onChanged: (value) {},
                              activeColor: AppColors.purpleBlue,
                            ),
                            Text(
                              provider.title,
                              style: dropDownTextStyle,
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropDownValue = value;
                      if(value!.id == ZERO){
                        widget.onChanged(null);
                      }else{
                        widget.onChanged(value);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
