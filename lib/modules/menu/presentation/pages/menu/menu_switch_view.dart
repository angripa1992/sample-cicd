import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/action_dialogs.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';

class MenuSwitchView extends StatefulWidget {
  final bool enabled;
  final bool parentEnabled;
  final Function(bool) onChanged;
  final int brandId;
  final int id;
  final int type;
  final int providerId;

  const MenuSwitchView({
    Key? key,
    required this.enabled,
    required this.onChanged,
    required this.parentEnabled,
    required this.brandId,
    required this.id,
    required this.type,
    required this.providerId,
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

  void _handleItem(bool value) {
    showMenuItemActionDialog(
      context: context,
      brandId: widget.brandId,
      itemId: widget.id,
      enabled: value,
      onSuccess: () {
        setState(() {
          _enabled = value;
          widget.onChanged(_enabled);
        });
      },
    );
  }

  void _handleMenu(bool value) {
    showMenuActionDialog(
      context: context,
      brandId: widget.brandId,
      id: widget.id,
      type: widget.type,
      enabled: value,
      onSuccess: () {
        setState(() {
          _enabled = value;
          widget.onChanged(_enabled);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.providerId == ZERO
        ? Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: _enabled,
              activeColor: AppColors.purpleBlue,
              trackColor: AppColors.blackCow,
              onChanged: !widget.parentEnabled
                  ? null
                  : (value) {
                      if (widget.type == MenuType.ITEM) {
                        _handleItem(value);
                      } else {
                        _handleMenu(value);
                      }
                    },
            ),
          )
        : SizedBox(height: AppSize.s32.rh);
  }
}
