import 'package:flutter/material.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/action_dialogs.dart';

import '../../../../../resources/colors.dart';

class ModifierSwitchView extends StatefulWidget {
  final int type;
  final bool enabled;
  final int brandId;
  final int groupId;
  final Function(bool) onSuccess;
  final int? modifierId;

  const ModifierSwitchView({
    Key? key,
    required this.type,
    required this.enabled,
    required this.brandId,
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

  void _handleEnableAction(bool enabled) {
    showEnableModifierDialog(
      context: context,
      brandId: widget.brandId,
      groupId: widget.groupId,
      type: widget.type,
      modifierId: widget.modifierId,
      onSuccess: () {
       setState(() {
         _enabled = enabled;
         widget.onSuccess(enabled);
       });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _enabled,
      activeColor: AppColors.purpleBlue,
      activeTrackColor: AppColors.lightViolet,
      inactiveThumbColor: AppColors.black,
      inactiveTrackColor: AppColors.smokeyGrey,
      onChanged: (enabled) {
        if (enabled) {
          _handleEnableAction(enabled);
        } else {
          setState(() {
            _enabled = enabled;
          });
        }
      },
    );
  }
}
