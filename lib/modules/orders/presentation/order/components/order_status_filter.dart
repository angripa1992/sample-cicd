import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/provider.dart';

class OrderStatusFilter extends StatefulWidget {
  const OrderStatusFilter({Key? key}) : super(key: key);

  @override
  State<OrderStatusFilter> createState() => _OrderStatusFilterState();
}

class _OrderStatusFilterState extends State<OrderStatusFilter> {
  final _controller = ExpandedTileController(isExpanded: false);

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.purpleBlue,
        headerPadding: EdgeInsets.symmetric(
          horizontal: AppSize.ZERO,
          vertical: AppSize.ZERO,
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
        'Status',
        style: getRegularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s11.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            Text('Cenceled'),
            Text('Delivered'),
          ],
        ),
      ),
      controller: _controller,
    );
  }
}
