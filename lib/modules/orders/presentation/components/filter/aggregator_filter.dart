import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/presentation/components/filter/select_all_view.dart';
import 'package:klikit/modules/orders/provider/order_information_provider.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../../resources/strings.dart';
import '../../../../widgets/app_button.dart';
import '../../../domain/entities/provider.dart';
import '../../filter_subject.dart';
import 'aggregrator_item.dart';

class AggregatorsFilter extends StatefulWidget {
  final FilterSubject filterSubject;

  const AggregatorsFilter({Key? key, required this.filterSubject})
      : super(key: key);

  @override
  State<AggregatorsFilter> createState() => _AggregatorsFilterState();
}

class _AggregatorsFilterState extends State<AggregatorsFilter> {
  final _controller = ExpandedTileController(isExpanded: false);
  final _orderInfoProvider = getIt.get<OrderInformationProvider>();
  final List<Provider> _providers = [];
  final List<Provider> _applyingProvider = [];
  String _title = AppStrings.delivery_aggregator.tr();

  @override
  void initState() {
    _controller.addListener(_onToggle);
    super.initState();
  }

  void _onToggle() {
    String title = AppStrings.delivery_aggregator.tr();
    if (!_controller.isExpanded) {
      final selectedAggregator = _applyingProvider
          .where((element) => element.isSelected)
          .toList()
          .length;
      if (selectedAggregator > 0) {
        title = '$selectedAggregator  ${AppStrings.aggregators_selected.tr()}';
      }
    }
    setState(() {
      _title = title;
    });
  }

  void _changeSelectedStatus(bool isSelected, Provider provider) async {
    provider.isSelected = isSelected;
    _applyingProvider.removeWhere((element) => element.id == provider.id);
    _applyingProvider.add(provider);
  }

  void _apply() async {
    for (var provider in _applyingProvider) {
      _providers[_providers
          .indexWhere((element) => element.id == provider.id)] = provider;
    }
    widget.filterSubject.applyProviderFilter(
      await _orderInfoProvider.extractProvidersIds(
        _providers.where((element) => element.isSelected).toList(),
      ),
    );
    _controller.toggle();
  }

  void _copyDataToLocalVariable(List<Provider> providers) async {
    _applyingProvider.clear();
    if (_providers.isEmpty) {
      for (var provider in providers) {
        _providers.add(provider.copy());
      }
      widget.filterSubject.setProviders(
        await _orderInfoProvider.extractProvidersIds(_providers),
      );
    }
    _applyingProvider.addAll(_providers);
  }

  bool _isAllSelected() {
    bool allSelected = true;
    for (var provider in _providers) {
      if (!provider.isSelected) {
        allSelected = false;
        break;
      }
    }
    return allSelected;
  }

  void _changeAllSelection(bool isSelected) {
    _applyingProvider.clear();
    for (var provider in _providers) {
      provider.isSelected = isSelected;
    }
    _applyingProvider.addAll(_providers);
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.white,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s8.rw,
          vertical: AppSize.s8.rh,
        ),
        headerSplashColor: AppColors.white,
        contentBackgroundColor: AppColors.white,
        contentPadding: EdgeInsets.zero,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.black,
      ),
      trailingRotation: 180,
      title: Text(
        _title,
        style: regularTextStyle(
          color: AppColors.black,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: FutureBuilder<List<Provider>>(
          future: _orderInfoProvider.fetchProviders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _copyDataToLocalVariable(snapshot.data!);
              return StatefulBuilder(
                builder: (_, setState) {
                  return Column(
                    children: [
                      SelectAllView(
                        isAllSelected: _isAllSelected(),
                        onSelectChange: (isAllSelected) {
                          _changeAllSelection(isAllSelected);
                          setState(() {});
                        },
                      ),
                      const Divider(),
                      ListView.separated(
                        itemCount: _providers.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AggregatorItem(
                            provider: _providers[index],
                            onChange: (isSelected, provider) {
                              _changeSelectedStatus(isSelected, provider);
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: AppSize.s12.rh),
                        child: AppButton(
                          onTap: () {
                            _apply();
                          },
                          text: AppStrings.apply.tr(),
                          icon: Icons.search,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      controller: _controller,
    );
  }
}
