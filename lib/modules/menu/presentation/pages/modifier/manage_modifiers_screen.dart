import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import 'modifier_group_info.dart';
import 'modifier_list_view.dart';

class ManageModifiersScreen extends StatelessWidget {
  const ManageModifiersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    ModifiersGroup modifierGroup = args[ArgumentKey.kGROUP];
    final brandId = args[ArgumentKey.kBRAND_ID];
    return BlocProvider(
      create: (_) => getIt.get<CheckAffectedCubit>(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, modifierGroup);
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          title: const Text('Modifiers'),
          titleTextStyle: getAppBarTextStyle(),
          flexibleSpace: getAppBarBackground(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSize.s10.rh,
            horizontal: AppSize.s16.rw,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModifierGroupInfoView(
                modifiersGroup: modifierGroup,
                brandId: brandId,
                onChanged: (modifiedGroup) {
                  modifierGroup.statuses[0] = modifiedGroup.statuses[0];
                },
              ),
              SizedBox(height: AppSize.s16.rh),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s4.rh,
                  horizontal: AppSize.s4.rw,
                ),
                child: Text(
                  'MODIFIERS',
                  style: getRegularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
              ModifierListView(
                modifiersGroup: modifierGroup,
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
