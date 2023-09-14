import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../core/utils/response_state.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../../../../widgets/loading_button.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/success_response.dart';
import '../cubit/device_setting_cubit.dart';

class DeviceSettingScreen extends StatefulWidget {
  const DeviceSettingScreen({Key? key}) : super(key: key);

  @override
  State<DeviceSettingScreen> createState() => _DeviceSettingScreenState();
}

class _DeviceSettingScreenState extends State<DeviceSettingScreen> {
  final _devices = [Device.android, Device.sunmi];
  int? _device;

  @override
  void initState() {
    final isSunmiDevice = SessionManager().isSunmiDevice();
    _device = isSunmiDevice ? Device.sunmi : Device.android;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<DeviceSettingCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Device Setting'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s16.rh,
            horizontal: AppSize.s16.rw,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose device type to connect printer',
                style: mediumTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
              SizedBox(height: AppSize.s8.rh),
              Column(
                children: _devices.map((device) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      device == Device.android ? 'Android' : 'Sunmi',
                      style: mediumTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                    leading: Radio<int>(
                      value: device,
                      groupValue: _device,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _device = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              BlocConsumer<DeviceSettingCubit, ResponseState>(
                listener: (context, state) {
                  if (state is Failed) {
                    showApiErrorSnackBar(context, state.failure);
                  } else if (state is Success<SuccessResponse>) {
                    showSuccessSnackBar(context, state.data.message);
                  }
                },
                builder: (context, state) {
                  return LoadingButton(
                    isLoading: (state is Loading),
                    text: AppStrings.save.tr(),
                    color: AppColors.primary,
                    borderColor: AppColors.primary,
                    textColor: AppColors.white,
                    onTap: () {
                      context.read<DeviceSettingCubit>().changeSunmiDeviceSetting(_device == Device.sunmi);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
