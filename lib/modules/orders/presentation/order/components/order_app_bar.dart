import 'package:flutter/material.dart';

import '../../../../../app/size_config.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';

class OrderAppBar extends StatelessWidget {
  const OrderAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s50.rh,
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
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s18.rw),
          child: Text(
            'Order Dashboard',
            style: getAppBarTextStyle(),
          ),
        ),
      ),
    );
  }
}
