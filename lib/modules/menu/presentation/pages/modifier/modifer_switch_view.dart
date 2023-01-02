import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/action_dialogs.dart';
import 'package:klikit/modules/widgets/snackbars.dart';

import '../../../../../resources/colors.dart';
import '../../../domain/entities/modifier_disabled_response.dart';

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

  void _checkAffect(bool enabled) async {
    showLoadingSnackBar(context);
    final response = await context.read<CheckAffectedCubit>().checkAffect(
          type: widget.type,
          enabled: enabled,
          brandId: widget.brandId,
          groupId: widget.groupId,
          modifierId: widget.modifierId,
        );
    response.fold(
      (failure) {
        dismissCurrentSnackBar(context);
        showApiErrorSnackBar(context, failure);
      },
      (data) {
        dismissCurrentSnackBar(context);
        _disableModifier(data);
      },
    );
  }

  String _extractItemsNames(List<DisabledItem> items) {
    String names = items.map((e) => e.title).toList().join(",");
    return names;
  }

  void _disableModifier(ModifierDisabledResponse response) {
    showDisableModifierDialog(
      context: context,
      brandId: widget.brandId,
      groupId: widget.groupId,
      type: widget.type,
      affected: response.affected,
      modifierId: widget.modifierId,
      items: response.affected ? _extractItemsNames(response.items) : '',
      onSuccess: () {
        setState(() {
          _enabled = false;
          widget.onSuccess(false);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.7,
      child: CupertinoSwitch(
        value: _enabled,
        activeColor: AppColors.purpleBlue,
        trackColor: AppColors.blackCow,
        onChanged: (enabled) {
          if (enabled) {
            _handleEnableAction(enabled);
          } else {
            _checkAffect(enabled);
          }
        },
      ),
    );
  }
}
