import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/printer/presentation/sticker_config_tab.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import 'docket_config_tab.dart';

class PrinterConnectionSettingPage extends StatelessWidget {
  const PrinterConnectionSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.printer_settings.tr()),
          bottom: TabBar(
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.black,
            labelColor: AppColors.primary,
            labelStyle: TextStyle(
              fontSize: AppFontSize.s16.rSp,
            ),
            tabs: const [Tab(text: 'Docket'), Tab(text: 'Sticker')],
          ),
        ),
        body: const TabBarView(
          children: [
            DocketConfigTab(),
            StickerConfigTab(),
          ],
        ),
      ),
    );
  }
}
