import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klikit/app/size_config.dart';

import '../../../resources/assets.dart';
import '../../../resources/values.dart';

class RegistrationHeaderView extends StatelessWidget {
  const RegistrationHeaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.2,
      margin: EdgeInsets.only(
        left: AppSize.s16.rw,
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.2,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppImages.loginPageBG),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              AppImages.loginPageLogo,
              height: AppSize.s32.rh,
              width: AppSize.s100.rw,
            ),
          ),
        ],
      ),
    );
  }
}
