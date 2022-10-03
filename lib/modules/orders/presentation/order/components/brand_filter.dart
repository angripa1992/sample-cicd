import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/di.dart';
import '../../../../../core/provider/order_information_provider.dart';
import '../observer/filter_subject.dart';

class BrandFilter extends StatefulWidget {
  final FilterSubject filterSubject;
  const BrandFilter({Key? key, required this.filterSubject}) : super(key: key);

  @override
  State<BrandFilter> createState() => _BrandFilterState();
}

class _BrandFilterState extends State<BrandFilter> {
  final _controller = ExpandedTileController(isExpanded: false);
  final _orderInfoProvider = getIt.get<OrderInformationProvider>();
  final List<Brand> _providers = [];

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.lightVioletTwo,
        headerRadius: AppSize.s4.rSp,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.s20.rw,
          vertical: AppSize.s10.rh,
        ),
        headerSplashColor: AppColors.lightViolet,
        contentBackgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
      ),
      trailing: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.purpleBlue,
      ),
      trailingRotation: 180,
      title: Text(
        'Filter by brand',
        style: getRegularTextStyle(
          color: AppColors.purpleBlue,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: FutureBuilder<Brands>(
          future: _orderInfoProvider.getBrands(),
          builder: (context,snapshot){
           if(snapshot.hasData){
             return ListView.builder(
               itemCount: snapshot.data!.brands.length,
               physics: const NeverScrollableScrollPhysics(),
               shrinkWrap: true,
               itemBuilder: (context, index) {
                 return Text(snapshot.data!.brands[index].title);
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
