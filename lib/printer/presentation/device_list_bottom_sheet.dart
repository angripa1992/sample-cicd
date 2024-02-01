import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_tabbar_view.dart';
import 'package:klikit/modules/menu/presentation/pages/tab_item.dart';
import 'package:klikit/printer/presentation/pos_printer_devices.dart';
import 'package:klikit/printer/presentation/sticker_printer_devices.dart';
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

  void showBottomSheet({
    required int type,
    required int initialIndex,
    required Function(PrinterDevice) onPOSConnect,
    required Function(BluetoothDevice) onStickerConnect,
  }) {
    if (!_isAlreadyShowing) {
      _isAlreadyShowing = true;
      _showDeviceListBottomSheet(
        type: type,
        initialIndex: initialIndex,
        onPOSConnect: onPOSConnect,
        onStickerConnect: onStickerConnect,
      );
    }
  }

  void _showDeviceListBottomSheet({
    required int type,
    required int initialIndex,
    required Function(PrinterDevice) onPOSConnect,
    required Function(BluetoothDevice) onStickerConnect,
  }) {
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
        body: DeviceListScreen(
          type: type,
          onPOSConnect: onPOSConnect,
          onStickerConnect: onStickerConnect,
        ),
      ),
    ).then((value) => _isAlreadyShowing = false);
  }
}

class DeviceListScreen extends StatefulWidget {
  final int type;
  final Function(PrinterDevice) onPOSConnect;
  final Function(BluetoothDevice) onStickerConnect;

  const DeviceListScreen({
    Key? key,
    required this.type,
    required this.onPOSConnect,
    required this.onStickerConnect,
  }) : super(key: key);

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> with SingleTickerProviderStateMixin {
  late List<TabItem> tabItems;
  final _tabChangeListener = ValueNotifier(TabIndex.DOCKET);
  TabController? _tabController;

  @override
  void initState() {
    tabItems = [
      TabItem(AppStrings.docket.tr(), TabIndex.DOCKET),
      TabItem(AppStrings.sticker.tr(), TabIndex.STICKER),
    ];
    _tabController = TabController(length: tabItems.length, vsync: this);
    _tabController?.addListener(() {
      _tabChangeListener.value = _tabController?.index == 1 ? TabIndex.STICKER : TabIndex.DOCKET;
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
          Row(
            children: [
              16.horizontalSpacer(),
              Text(
                widget.type == CType.BLE ? AppStrings.bluetooth_devices.tr() : AppStrings.usb_devices.tr(),
                style: semiBoldTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              const Spacer(),
              InkWell(
                child: ImageResourceResolver.closeSVG.getImageWidget(width: 20.rw, height: 20.rh),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              16.horizontalSpacer(),
            ],
          ),
          const Divider().setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s6.rh),
          ValueListenableBuilder<int>(
            valueListenable: _tabChangeListener,
            builder: (_, index, __) => MenuTabBarView(
              selectedIndex: index,
              tabItems: tabItems,
              onChanged: (index) {
                _tabController?.index = findTabBarViewIndex(index);
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                PosPrinterDevicesView(
                  type: widget.type,
                  onConnect: widget.onPOSConnect,
                ),
                StickerPrinterDevices(
                  onConnect: widget.onStickerConnect,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int findTabBarViewIndex(int index) {
    return index == TabIndex.DOCKET ? 0 : 1;
  }
}
