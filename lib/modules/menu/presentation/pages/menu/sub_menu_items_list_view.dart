import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/modules/widgets/image_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/items.dart';
import 'menu_item_details.dart';

class SubMenuItemsListView extends StatelessWidget {
  final SubSections subSections;
  final bool parentEnabled;
  final int brandID;
  final int providerID;
  final Function(List<Items>) onChanged;

  const SubMenuItemsListView({
    Key? key,
    required this.subSections,
    required this.onChanged,
    required this.parentEnabled,
    required this.brandID,
    required this.providerID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: subSections.items.length,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return MenuItemDetails(
                    items: subSections.items[index],
                    parentEnabled: parentEnabled && subSections.enabled,
                    brandID: brandID,
                    providerID: providerID,
                    onChanged: (enabled) {
                      subSections.items[index].stock.available = enabled;
                      onChanged(subSections.items);
                      SegmentManager().track(
                        event: SegmentEvents.ITEM_TOGGLE,
                        properties: {
                          'id': subSections.items[index].id,
                          'name': subSections.items[index].title,
                          'enabled': enabled ? 'Yes' : 'No',
                        },
                      );
                    },
                  );
                },
              );
            },
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s4.rh,
                  horizontal: AppSize.s10.rw,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: AppSize.s10.rw),
                      child: ImageView(path: subSections.items[index].image),
                    ),
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
                      providerId: providerID,
                      type: MenuType.ITEM,
                      enabled: subSections.items[index].stock.available,
                      parentEnabled: parentEnabled && subSections.enabled,
                      onChanged: (enabled) {
                        subSections.items[index].stock.available = enabled;
                        onChanged(subSections.items);
                        SegmentManager().track(
                          event: SegmentEvents.ITEM_TOGGLE,
                          properties: {
                            'id': subSections.items[index].id,
                            'name': subSections.items[index].title,
                            'enabled': enabled ? 'Yes' : 'No',
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    ;
  }
}
