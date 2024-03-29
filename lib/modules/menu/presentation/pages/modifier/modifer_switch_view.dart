import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/action_dialogs.dart';
import 'package:klikit/modules/widgets/snackbars.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../domain/entities/modifier/affected_modifier_response.dart';

class ModifierSwitchView extends StatefulWidget {
  final int menuVersion;
  final int type;
  final bool enabled;
  final int brandId;
  final int branchID;
  final int groupId;
  final Function(bool) onSuccess;
  final int? modifierId;

  const ModifierSwitchView({
    Key? key,
    required this.menuVersion,
    required this.type,
    required this.enabled,
    required this.brandId,
    required this.branchID,
    required this.groupId,
    this.modifierId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<ModifierSwitchView> createState() => _ModifierSwitchViewState();
}

class _ModifierSwitchViewState extends State<ModifierSwitchView> {
  late bool _enabled;

  @override
  void initState() {
    _enabled = widget.enabled;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ModifierSwitchView oldWidget) {
    _enabled = widget.enabled;
    super.didUpdateWidget(oldWidget);
  }

  void _updateEnabled({
    required bool enabled,
    required bool affected,
    required String itemsName,
  }) {
    showUpdateModifierEnabledConfirmationDialog(
      isEnable: enabled,
      menuVersion: widget.menuVersion,
      context: context,
      brandId: widget.brandId,
      branchID: widget.branchID,
      groupId: widget.groupId,
      type: widget.type,
      affected: affected,
      modifierId: widget.modifierId,
      items: itemsName,
      onSuccess: () {
        setState(() {
          _enabled = enabled;
          widget.onSuccess(enabled);
        });
      },
    );
  }

  void _checkAffect(bool enabled) async {
    EasyLoading.show();
    final response = await context.read<CheckAffectedCubit>().checkAffect(
          menuVersion: widget.menuVersion,
          type: widget.type,
          enabled: enabled,
          brandId: widget.brandId,
          branchID: widget.branchID,
          groupId: widget.groupId,
          modifierId: widget.modifierId,
        );
    EasyLoading.dismiss();
    response.fold(
      (failure) {
        showApiErrorSnackBar(context, failure);
      },
      (data) {
        _updateEnabled(
          enabled: false,
          affected: data.affected,
          itemsName: _extractItemsNames(data.items),
        );
      },
    );
  }

  String _extractItemsNames(List<DisabledItem> items) {
    String names = items.map((e) => e.title).toList().join(",");
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return UserPermissionManager().canOosMenu()
        ? Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: _enabled,
              activeColor: AppColors.primary,
              trackColor: AppColors.black,
              onChanged: (enabled) {
                if (enabled) {
                  _updateEnabled(
                    enabled: true,
                    affected: false,
                    itemsName: '',
                  );
                } else {
                  _checkAffect(enabled);
                }
              },
            ),
          )
        : SizedBox(height: AppSize.s32.rh);
  }
}
