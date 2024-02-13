import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/wifi_printer_ip_input_view.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../app/extensions.dart';

class WifiPrinterDeviceView extends StatefulWidget {
  final PrinterHandler handler;

  const WifiPrinterDeviceView({
    super.key,
    required this.handler,
  });

  @override
  State<WifiPrinterDeviceView> createState() => _WifiPrinterDeviceViewState();
}

class _WifiPrinterDeviceViewState extends State<WifiPrinterDeviceView> {
  final _textController = TextEditingController();
  String _wifiIP = EMPTY;

  @override
  void initState() {
    _wifiIP = LocalPrinterDataManager().localPrinter()?.deviceAddress ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.rw),
      child: Column(
        children: [
          _wifiIP.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No Wifi Printer are connected yet',
                      style: mediumTextStyle(
                        color: AppColors.neutralB200,
                        fontSize: 14.rSp,
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 16.rh),
                  child: _connectedDevice(),
                ),
          const Spacer(),
          KTButton(
            controller: KTButtonController(label: 'Add New Printer'),
            suffixWidget: Icon(Icons.add, color: AppColors.white),
            backgroundDecoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16.rSp),
            ),
            labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
            onTap: () {
              _showPrinterIPInputView();
            },
          ),
        ],
      ),
    );
  }

  Widget _connectedDevice() {
    return Row(
      children: [
        const Icon(Icons.wifi),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.rw),
            child: Text(
              _wifiIP,
              style: mediumTextStyle(
                color: AppColors.neutralB500,
                fontSize: 14.rSp,
              ),
            ),
          ),
        ),
        KTButton(
          controller: KTButtonController(
            label: AppStrings.disconnect.tr(),
          ),
          labelStyle: regularTextStyle(
            color: AppColors.errorR300,
            fontSize: 12.rSp,
          ),
          backgroundDecoration: BoxDecoration(
            border: Border.all(color: AppColors.neutralB30),
            borderRadius: BorderRadius.circular(16.rSp),
          ),
          horizontalContentPadding: 16.rw,
          onTap: () async {
            _disconnect();
          },
        ),
      ],
    );
  }

  void _showPrinterIPInputView() {
    showDialog(
      context: context,
      builder: (ct) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.rSp))),
        content: WifiPrinterIPInputView(
          onSetIP: (ip) {
            if (ip.isNotEmpty) {
              _connect(ip);
            }
          },
        ),
      ),
    );
  }

  void _connect(String ip) async {
    final localPrinter = LocalPrinter(
      deviceType: CType.WIFI,
      deviceAddress: ip,
      deviceName: '',
      productId: '',
      vendorId: '',
    );
    widget.handler.connect(localPrinter: localPrinter, isFromBackground: false, showMessage: true).then((connected) {
      if (connected) {
        setState(() {
          _wifiIP = ip;
        });
      }
    });
  }

  void _disconnect() {
    final localPrinter = LocalPrinterDataManager().localPrinter();
    widget.handler.disconnect(localPrinter, false).then((value) {
      setState(() {
        _wifiIP = EMPTY;
      });
    });
  }
}
