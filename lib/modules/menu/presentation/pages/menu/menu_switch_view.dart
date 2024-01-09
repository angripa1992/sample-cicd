import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
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
        ? Container(
            decoration: const BoxDecoration(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
              child: Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  key: UniqueKey(),
                  value: _enabled,
                  activeColor: AppColors.primary,
                  trackColor: AppColors.black,
                  onChanged: !widget.parentEnabled ? null : _handleMenu,
                ),
              ),
            ),
          )
        : SizedBox(height: AppSize.s40.rh);
  }
}
