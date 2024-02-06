import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/presentation/wifi_printer_ip_input_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../app/extensions.dart';

class WifiPrinterDeviceView extends StatefulWidget {
  const WifiPrinterDeviceView({super.key});

  @override
  State<WifiPrinterDeviceView> createState() => _WifiPrinterDeviceViewState();
}

class _WifiPrinterDeviceViewState extends State<WifiPrinterDeviceView> {
  final _textController = TextEditingController();
  String _IP = EMPTY;

  @override
  void initState() {
    _IP = SessionManager().wifiPrinterIPAddress();
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
          _IP.isEmpty
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
              _IP,
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
            _saveIPAddressLocally(ip: EMPTY, connected: false);
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
              _saveIPAddressLocally(ip: ip, connected: true);
            }
          },
        ),
      ),
    );
  }

  void _saveIPAddressLocally({
    required String ip,
    required bool connected,
  }) {
    SessionManager().setWifiPrinterIPAddress(ip).then((value) {
      setState(() {
        _IP = ip;
      });
      if (connected) {
        showSuccessSnackBar(context, 'Wi-Fi printer successfully connected');
      } else {
        showErrorSnackBar(context, 'Wi-Fi printer disconnected');
      }
    });
  }
}
