import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/kt_switch.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/action_dialogs.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';

class MenuSwitchView extends StatefulWidget {
  final int menuVersion;
  final bool enabled;
  final bool parentEnabled;
  final Function(bool) onMenuEnableChanged;
  final int brandId;
  final int branchId;
  final int id;
  final int type;
  final bool willShowBg;
  final double? switchWidth;
  final double? switchHeight;

  const MenuSwitchView({
    Key? key,
    required this.menuVersion,
    required this.enabled,
    required this.onMenuEnableChanged,
    required this.parentEnabled,
    required this.brandId,
    required this.id,
    required this.type,
    required this.branchId,
    this.willShowBg = true,
    this.switchWidth,
    this.switchHeight,
  }) : super(key: key);

  @override
  State<MenuSwitchView> createState() => _MenuSwitchViewState();
}

class _MenuSwitchViewState extends State<MenuSwitchView> {
  late bool _enabled;

  @override
  void initState() {
    if (!widget.parentEnabled) {
      _enabled = false;
    } else {
      _enabled = widget.enabled;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MenuSwitchView oldWidget) {
    if (!widget.parentEnabled) {
      _enabled = false;
    } else {
      _enabled = widget.enabled;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleMenu(bool value) {
    showMenuActionDialog(
      context: context,
      brandId: widget.brandId,
      branchId: widget.branchId,
      id: widget.id,
      type: widget.type,
      enabled: value,
      onSuccess: () {
        setState(() {
          _enabled = value;
          widget.onMenuEnableChanged(_enabled);
        });
      },
      menuVersion: widget.menuVersion,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UserPermissionManager().canOosMenu()
        ? KTSwitch(
            width: widget.switchWidth ?? 36.rw,
            height: widget.switchHeight ?? 18.rh,
            controller: ValueNotifier<bool>(_enabled),
            activeColor: AppColors.primaryP300,
            onChanged: (enabled) {
              if (widget.parentEnabled) {
                _handleMenu(enabled);
              }
            },
          )
        : SizedBox(height: AppSize.s40.rh);
  }
}
