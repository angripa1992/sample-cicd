import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/menu/menu_data.dart';

class MenuScreen extends StatefulWidget {
  final Brand? brand;
  final int? providerId;

  const MenuScreen({Key? key, required this.brand, this.providerId}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    SegmentManager().screen(event: SegmentEvents.MENU_SCREEN, name: 'Menu Screen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.brand != null) {
      context.read<MenusCubit>().fetchMenu(widget.brand!.id, widget.providerId);
    }
    return Expanded(
      child: widget.brand == null
          ? emptyScreen()
          : BlocBuilder<MenusCubit, ResponseState>(
              builder: (context, state) {
                if (state is Success<MenuData>) {
                  if (state.data.sections.isEmpty) {
                    return Center(
                      child: Text(AppStrings.no_menus_found.tr()),
                    );
                  }
                  return MenuListView(
                    sections: state.data.sections,
                    brandID: widget.brand!.id,
                    providerID: widget.providerId.orZero(),
                  );
                } else if (state is Failed) {
                  return Center(child: Text(state.failure.message));
                }
                return const Center(child: CircularProgress());
              },
            ),
    );
  }

  Widget emptyScreen() {
    return Container(
      color: AppColors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageResourceResolver.menuBrandPNG.getImageWidget(width: 131.rw, height: 131.rh),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s48.rw),
              child: Text(
                'Select a brand to seamlessly manage menus and modifiers',
                style: mediumTextStyle(
                  color: AppColors.neutralB600,
                  fontSize: AppFontSize.s14.rSp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
