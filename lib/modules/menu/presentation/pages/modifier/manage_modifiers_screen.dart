import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/base/kt_app_bar.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../../resources/values.dart';
import '../../../domain/entities/modifier/modifier_group.dart';
import 'modifier_group_info.dart';
import 'modifier_list_view.dart';

class ManageModifiersScreen extends StatelessWidget {
  const ManageModifiersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    ModifierGroup modifierGroup = args[ArgumentKey.kGROUP];
    final brandId = args[ArgumentKey.kBRAND_ID];
    final branchID = args[ArgumentKey.kBRANCH_ID];
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, modifierGroup);
        return Future.value(false);
      },
      child: BlocProvider(
        create: (_) => getIt.get<CheckAffectedCubit>(),
        child: Scaffold(
          appBar: KTAppBar(
            title: AppStrings.manage_modifiers.tr(),
            onNavBack: () {
              Navigator.pop(context, modifierGroup);
            },
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSize.s2.verticalSpacer(),
              ModifierGroupInfoView(
                modifiersGroup: modifierGroup,
                brandId: brandId,
                branchID: branchID,
                onChanged: (modifiedGroup) {
                  modifierGroup.isEnabled = modifiedGroup.isEnabled;
                },
              ),
              AppSize.s4.verticalSpacer(),
              ModifierListView(
                modifierGroup: modifierGroup,
                branchID: branchID,
                brandId: brandId,
                onChanged: (changedModifiers) {
                  modifierGroup.modifiers = changedModifiers;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
