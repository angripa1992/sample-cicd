import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_button.dart';
import 'package:klikit/modules/common/data/business_info_provider_repo.dart';
import 'package:klikit/modules/common/model/delivery_time_success_response.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

class AddDeliveryTimeView extends StatefulWidget {
  final int initialDeliveryTime;

  const AddDeliveryTimeView({super.key, required this.initialDeliveryTime});

  @override
  State<AddDeliveryTimeView> createState() => _AddDeliveryTimeViewState();
}

class _AddDeliveryTimeViewState extends State<AddDeliveryTimeView> {
  TextEditingController? _textEditingController;
  final _buttonController = KTButtonController(label: AppStrings.ok.tr());

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.initialDeliveryTime.toString());
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  Future<void> _setDeliveryTime() async {
    try {
      _buttonController.setLoaded(false);
      final min = _textEditingController?.text.toInt() ?? 0;
      final data = DeliveryTimeDataModel(
        branchId: SessionManager().branchId(),
        deliveryTimeMinute: min,
      );
      final response = await getIt.get<BusinessInfoProviderRepo>().setDeliveryTime(data);
      _buttonController.setLoaded(true);
      response.fold(
        (error) {
          showErrorSnackBar(context, error.message);
        },
        (data) {
          _textEditingController?.text = data.deliveryTimeMinute.toString();
          Navigator.pop(context);
          showSuccessSnackBar(context, 'Delivery time successfully updated');
        },
      );
    } catch (e) {
      _buttonController.setLoaded(true);
      //ignored
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ImageResourceResolver.riderBgSVG.getImageWidget(width: 32.rSp, height: 32.rSp),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rw),
                child: Text(
                  'Delivery Time',
                  style: mediumTextStyle(
                    color: AppColors.neutralB700,
                    fontSize: 18.rSp,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.clear),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.rh),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  final currentMins = _textEditingController?.text.toInt() ?? 0;
                  if (currentMins > 5) {
                    _textEditingController?.text = (currentMins - 5).toString();
                  }
                },
                icon: Icon(Icons.remove_circle_outline, color: AppColors.neutralB100),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.rw),
                decoration: BoxDecoration(
                  color: AppColors.neutralB20,
                  borderRadius: BorderRadius.circular(8.rSp),
                ),
                child: SizedBox(
                  width: 70.rw,
                  child: TextField(
                    controller: _textEditingController,
                    cursorColor: AppColors.neutralB700,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  final text = (_textEditingController?.text.toInt() ?? 0) + 5;
                  _textEditingController?.text = text.toString();
                },
                icon: Icon(Icons.add_circle_outline, color: AppColors.neutralB100),
              ),
              Text(
                AppStrings.mins.tr(),
                style: regularTextStyle(
                  color: AppColors.neutralB200,
                  fontSize: 14.rSp,
                ),
              ),
            ],
          ),
        ),
        Text(
          '*Average Time required to delivered the order using your own fleet. Applicable for Ubereats Orders only',
          style: regularTextStyle(
            color: AppColors.neutralB300,
            fontSize: 14.rSp,
          ),
        ),
        SizedBox(height: 16.rh),
        KTButton(
          controller: _buttonController,
          labelStyle: mediumTextStyle(color: AppColors.white, fontSize: 14.rSp),
          backgroundDecoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.rSp),
          ),
          onTap: () {
            _setDeliveryTime();
          },
        ),
      ],
    );
  }
}
