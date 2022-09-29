import 'package:flutter/material.dart';

import '../../../../../app/size_config.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class OrderAppBar extends StatelessWidget {
  const OrderAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s50.rh + ScreenSizes.statusBarHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF000000).withOpacity(1.0),
            const Color(0xFF6A13F4).withOpacity(1.0),
            const Color(0xFFFAF84F).withOpacity(1.0),
          ],
        ),
      ),
      //TODO
      child: AppBar(
        title: Text('Order Dashboard'),
        titleTextStyle: getAppBarTextStyle(),
        flexibleSpace: getAppBarBackground(),
      ),
    );
  }
}
