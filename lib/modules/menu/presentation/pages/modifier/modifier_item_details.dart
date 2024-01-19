import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/grouped_modifier_item.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/styles.dart';
import '../../../../../resources/values.dart';
import '../menu/provider_advanced_price.dart';
import 'modifer_switch_view.dart';

class ModifierItemDetails extends StatefulWidget {
  final GroupedModifierItem item;
  final int menuVersion;
  final int brandID;
  final int branchID;
  final int groupID;
  final Function(bool) onEnabledChanged;

  const ModifierItemDetails({
    Key? key,
    required this.item,
    required this.menuVersion,
    required this.brandID,
    required this.branchID,
    required this.groupID,
    required this.onEnabledChanged,
  }) : super(key: key);

  @override
  State<ModifierItemDetails> createState() => _ModifierItemDetailsState();
}

class _ModifierItemDetailsState extends State<ModifierItemDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIconButton(context),
          _buildBody(),
        ],
      ),
    );
  }

  Expanded _buildBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.rw),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.title.trim(),
                      style: mediumTextStyle(
                        fontSize: 20.rSp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  ModifierSwitchView(
                    menuVersion: widget.menuVersion,
                    branchID: widget.branchID,
                    brandId: widget.brandID,
                    groupId: widget.groupID,
                    modifierId: widget.item.id,
                    enabled: widget.item.isEnabled,
                    type: ModifierType.MODIFIER,
                    onSuccess: (enabled) {
                      setState(() {
                        widget.item.isEnabled = enabled;
                        widget.onEnabledChanged(enabled);
                      });
                    },
                  ),
                ],
              ),
            ),
            Divider(thickness: 1.rh),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.rw),
              child: ProviderAdvancePrice(itemPrices: widget.item.prices),
            ),
          ],
        ),
      ),
    );
  }

  IconButton _buildIconButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.remove,
        color: AppColors.greyDarker,
        size: AppSize.s32.rSp,
      ),
    );
  }
}
