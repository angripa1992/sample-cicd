import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/resources/decorations.dart';

import '../../../../../app/app_preferences.dart';
import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/success_response.dart';
import '../cubit/device_setting_cubit.dart';

class DeviceSettingScreen extends StatefulWidget {
  const DeviceSettingScreen({Key? key}) : super(key: key);

  @override
  State<DeviceSettingScreen> createState() => _DeviceSettingScreenState();
}

class _DeviceSettingScreenState extends State<DeviceSettingScreen> {
  final _devices = [Device.android, Device.sunmi,Device.imin];
  int? _device;
  final Map _devicesDetail = {
    Device.android: 'Android',
    Device.sunmi: 'Sunmi',
    Device.imin: 'Imin'
  };
  final _updateButtonController = KTButtonController(label: AppStrings.update.tr());

  @override
  void initState() {
    // final isSunmiDevice = SessionManager().isSunmiDevice();
    // _device = isSunmiDevice ? Device.sunmi : Device.android;
    _device = SessionManager().getActiveDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<DeviceSettingCubit>(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.choose_device_type_to_connect_printer.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s16.rh),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _devices.map((device) {
              return ListTile(
                contentPadding: EdgeInsets.fromLTRB(12.rw, 0, 8.rw, 0),
                selected: _device == device,
                selectedTileColor: AppColors.neutralB20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.rSp)),
                title: Text(
                  _devicesDetail[device],
                  style: mediumTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
                trailing: Radio<int>(
                  value: device,
                  groupValue: _device,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _device = device;
                    });
                  },
                ),
                onTap: () {
                  setState(() {
                    _device = device;
                  });
                },
              );
            }).toList(),
          ),
          42.verticalSpacer(),
          BlocConsumer<DeviceSettingCubit, ResponseState>(
            listener: (context, state) {
              _updateButtonController.setLoaded(state is! Loading);

              if (state is Failed) {
                Navigator.pop(context, state.failure);
              } else if (state is Success<SuccessResponse>) {
                Navigator.pop(context, state.data.message);
              }
            },
            builder: (context, state) {
              return KTButton(
                controller: _updateButtonController,
                backgroundDecoration: regularRoundedDecoration(backgroundColor: AppColors.primaryP300),
                labelStyle: mediumTextStyle(color: AppColors.white),
                progressPrimaryColor: AppColors.white,
                verticalContentPadding: 10.rh,
                onTap: () {
                  context.read<DeviceSettingCubit>().changeSunmiDeviceSetting(_device == Device.sunmi);
                  getIt<AppPreferences>().setActiveDevice(_device!);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
