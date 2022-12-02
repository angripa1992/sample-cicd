import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/provider/order_information_provider.dart';
import 'package:klikit/modules/orders/presentation/order/observer/filter_subject.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../domain/entities/provider.dart';
import 'delivery_platform_item.dart';

class DeliveryPlatformFilter extends StatefulWidget {
  final FilterSubject filterSubject;

  const DeliveryPlatformFilter({Key? key, required this.filterSubject})
      : super(key: key);

  @override
  State<DeliveryPlatformFilter> createState() => _DeliveryPlatformFilterState();
}

class _DeliveryPlatformFilterState extends State<DeliveryPlatformFilter> {
  final _controller = ExpandedTileController(isExpanded: false);
  final _orderInfoProvider = getIt.get<OrderInformationProvider>();
  final List<Provider> _providers = [];

  void _changeSelectedStatus(bool isSelected, Provider value) async {
    final provider = value.copyWith(isSelected: isSelected);
    _providers[_providers.indexWhere((element) => element.id == provider.id)] = provider;
    widget.filterSubject.applyProviderFilter(
      await _orderInfoProvider.extractProvidersIds(
        _providers.where((element) => element.isSelected).toList(),
      ),
    );
  }

  void _copyDataToLocalVariable(List<Provider> providers) async{
    if (_providers.isEmpty) {
      for (var provider in providers) {
        _providers.add(provider.copy());
      }
      widget.filterSubject.setProviders(await _orderInfoProvider.extractProvidersIds(_providers));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.purpleBlue,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s8.rh,
        ),
        headerSplashColor: AppColors.lightViolet,
        contentBackgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.white,
      ),
      trailingRotation: 180,
      title: Text(
        'Aggregators',
        style: getRegularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: FutureBuilder<List<Provider>>(
          future: _orderInfoProvider.getProviders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
             _copyDataToLocalVariable(snapshot.data!);
              return ListView.builder(
                itemCount: _providers.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return DeliveryPlatformItem(
                    provider: _providers[index],
                    onChange: (isSelected, provider) {
                      _changeSelectedStatus(isSelected, provider);
                    },
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
