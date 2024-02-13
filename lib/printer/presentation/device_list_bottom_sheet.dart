import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_tabbar_view.dart';
import 'package:klikit/modules/menu/presentation/pages/tab_item.dart';
import 'package:klikit/printer/presentation/pos_printer_devices.dart';
import 'package:klikit/printer/presentation/sticker_printer_devices.dart';
import 'package:klikit/printer/presentation/wifi_printer_device_view.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class DeviceListBottomSheetManager {
  static final _instance = DeviceListBottomSheetManager._internal();

  factory DeviceListBottomSheetManager() => _instance;

  DeviceListBottomSheetManager._internal();

  bool _isAlreadyShowing = false;

  void showDeviceListBottomSheet({
    required int initialIndex,
    required PrinterHandler handler,
    required Function(BluetoothDevice) onStickerPrinterConnected,
  }) {
    if (!_isAlreadyShowing) {
      _isAlreadyShowing = true;
      showModalBottomSheet<void>(
        context: RoutesGenerator.navigatorKey.currentState!.context,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.rSp),
            topRight: Radius.circular(16.rSp),
          ),
        ),
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBody: false,
          body: DeviceListScreen(handler: handler, onStickerPrinterConnected: onStickerPrinterConnected, initialIndex: initialIndex),
        ),
      ).then((value) => _isAlreadyShowing = false);
    }
  }
}

class DeviceListScreen extends StatefulWidget {
  final int initialIndex;
  final PrinterHandler handler;
  final Function(BluetoothDevice) onStickerPrinterConnected;

  const DeviceListScreen({
    Key? key,
    required this.initialIndex,
    required this.handler,
    required this.onStickerPrinterConnected,
  }) : super(key: key);

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> with SingleTickerProviderStateMixin {
  late List<TabItem> tabItems;
  late ValueNotifier<int> _tabChangeListener;
  TabController? _tabController;

  @override
  void initState() {
    _tabChangeListener = ValueNotifier(widget.initialIndex);
    tabItems = [
      TabItem(AppStrings.docket.tr(), PrinterTab.DOCKET),
      TabItem(AppStrings.sticker.tr(), PrinterTab.STICKER),
    ];
    _tabController = TabController(length: tabItems.length, vsync: this, initialIndex: widget.initialIndex);
    _tabController?.addListener(() {
      _tabChangeListener.value = _tabController?.index ?? PrinterTab.DOCKET;
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabChangeListener.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 24.rh, bottom: 20.rh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.rSp),
          topRight: Radius.circular(16.rSp),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rw),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Connect to ${widget.handler.title()} printer',
                    style: semiBoldTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ),
                InkWell(
                  child: ImageResourceResolver.closeSVG.getImageWidget(width: 20.rw, height: 20.rh),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          const Divider().setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s6.rh),
          ValueListenableBuilder<int>(
            valueListenable: _tabChangeListener,
            builder: (_, index, __) => MenuTabBarView(
              selectedIndex: index,
              tabItems: tabItems,
              onChanged: (index) {
                _tabController?.index = index;
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                widget.handler.type() != CType.WIFI ? PosPrinterDevicesView(handler: widget.handler) : WifiPrinterDeviceView(handler: widget.handler),
                StickerPrinterDevices(onStickerPrinterConnected: widget.onStickerPrinterConnected),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
