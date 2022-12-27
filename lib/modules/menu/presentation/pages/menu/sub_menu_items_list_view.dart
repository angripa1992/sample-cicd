import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../domain/entities/items.dart';

class SubMenuItemsListView extends StatelessWidget {
  final SubSections subSections;
  final bool parentEnabled;
  final int brandID;
  final Function(List<Items>) onChanged;

  const SubMenuItemsListView(
      {Key? key,
      required this.subSections,
      required this.onChanged,
      required this.parentEnabled,
      required this.brandID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: subSections.items.length,
        itemBuilder: (_, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s4.rh,
                horizontal: AppSize.s20.rw,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text('${index + 1}.'),
                        SizedBox(width: AppSize.s4.rw),
                        Expanded(
                          child: Text(subSections.items[index].title),
                        ),
                      ],
                    ),
                  ),
                  MenuSwitchView(
                    id: subSections.items[index].id,
                    brandId: brandID,
                    type: MenuType.ITEM,
                    enabled: subSections.items[index].stock.available,
                    parentEnabled: parentEnabled && subSections.enabled,
                    onChanged: (enabled) {
                      subSections.items[index].stock.available = enabled;
                      onChanged(subSections.items);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    ;
  }
}
