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

class SubMenuItemsListView extends StatefulWidget {
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
  State<SubMenuItemsListView> createState() => _SubMenuItemsListViewState();
}

class _SubMenuItemsListViewState extends State<SubMenuItemsListView> {
  final List<Items> _items = [];

  @override
  void initState() {
    _items.addAll(widget.subSections.items);
    super.initState();
  }

  void _onChanged(int index, bool enabled) {
    setState(() {
      _items[index].stock.available = enabled;
      widget.onChanged(_items);
    });
    SegmentManager().track(
      event: SegmentEvents.ITEM_TOGGLE,
      properties: {
        'id': _items[index].id,
        'name': _items[index].title,
        'enabled': enabled ? 'Yes' : 'No',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        key: UniqueKey(),
        itemCount: _items.length,
        itemBuilder: (_, index) {
          return InkWell(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSize.s14.rSp),
                  ),
                ),
                builder: (BuildContext context) {
                  return MenuItemDetails(
                    items: _items[index],
                    parentEnabled:
                        widget.parentEnabled && widget.subSections.enabled,
                    brandID: widget.brandID,
                    providerID: widget.providerID,
                    onChanged: (enabled) {
                      _onChanged(index, enabled);
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
                      child: ImageView(
                        path: _items[index].image,
                        width: AppSize.s36.rw,
                        height: AppSize.s36.rh,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text('${index + 1}.'),
                          SizedBox(width: AppSize.s4.rw),
                          Expanded(
                            child: Text(_items[index].title),
                          ),
                        ],
                      ),
                    ),
                    MenuSwitchView(
                      id: _items[index].id,
                      brandId: widget.brandID,
                      providerId: widget.providerID,
                      type: MenuType.ITEM,
                      enabled: _items[index].stock.available,
                      parentEnabled: widget.parentEnabled && widget.subSections.enabled,
                      onChanged: (enabled) {
                        _onChanged(index, enabled);
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
