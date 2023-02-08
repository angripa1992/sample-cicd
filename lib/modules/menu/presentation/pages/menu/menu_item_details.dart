import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../app/constants.dart';
import '../../../domain/entities/items.dart';
import 'menu_switch_view.dart';

class MenuItemDetails extends StatefulWidget {
  final Items items;
  final bool parentEnabled;
  final Function(bool) onChanged;
  final int brandID;
  final int providerID;

  const MenuItemDetails({
    Key? key,
    required this.items,
    required this.parentEnabled,
    required this.onChanged,
    required this.brandID,
    required this.providerID,
  }) : super(key: key);

  @override
  State<MenuItemDetails> createState() => _MenuItemDetailsState();
}

class _MenuItemDetailsState extends State<MenuItemDetails> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ScreenSizes.screenHeight / 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
            MenuSwitchView(
              id: widget.items.id,
              brandId: widget.brandID,
              providerId: widget.providerID,
              type: MenuType.ITEM,
              enabled: widget.items.stock.available,
              parentEnabled: widget.parentEnabled,
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
