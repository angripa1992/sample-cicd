import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class DeliveryPlatformFilter extends StatefulWidget {
  const DeliveryPlatformFilter({Key? key}) : super(key: key);

  @override
  State<DeliveryPlatformFilter> createState() => _DeliveryPlatformFilterState();
}

class _DeliveryPlatformFilterState extends State<DeliveryPlatformFilter> {
  final _controller = ExpandedTileController(isExpanded: false);

  @override
  Widget build(BuildContext context) {
    return ExpandedTile(
      theme: ExpandedTileThemeData(
        headerColor: AppColors.purpleBlue,
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
        color: AppColors.white,
      ),
      trailingRotation: 180,
      title: Text(
        'Delivery Platforms',
        style: getRegularTextStyle(
          color: AppColors.white,
          fontSize: AppFontSize.s14.rSp,
        ),
      ),
      content: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemCount: 10,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Text('Title $index');
          },
        ),
      ),
      controller: _controller,
    );
  }
}
