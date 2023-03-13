import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/modules/widgets/image_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/items.dart';
import '../../../domain/entities/stock.dart';
import 'menu_item_details.dart';
import 'menu_snooze_view.dart';

class SubMenuItemsListView extends StatefulWidget {
  final SubSections subSections;
  final bool parentEnabled;
  final int brandID;
  final int providerID;
  final Function(List<MenuItems>) onChanged;

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
  final List<MenuItems> _items = [];

  @override
  void initState() {
    _items.addAll(widget.subSections.items);
    super.initState();
  }

  void _onChangedEnabled(int index, bool enabled) {
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

  void _onChangedOos(int index, Stock stock) {
    print(stock.snooze.duration);
    setState(() {
      _items[index].stock = stock;
      widget.onChanged(_items);
    });
  }

  void _showItemDetails(int index) {
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
          parentEnabled: widget.parentEnabled && widget.subSections.enabled,
          brandID: widget.brandID,
          providerID: widget.providerID,
          brandId: widget.brandID,
          onChanged: (enabled) {
            _onChangedEnabled(index, enabled);
          },
          onChangedOos: (stock) {
            _onChangedOos(index, stock);
          },
        );
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
          return Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s8.rh,
                horizontal: AppSize.s10.rw,
              ),
              child: IntrinsicHeight(
                child: InkWell(
                  onTap: () {
                    _showItemDetails(index);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: AppSize.s10.rw),
                              child: ImageView(
                                path: _items[index].image,
                                width: AppSize.s36.rw,
                                height: AppSize.s36.rh,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Text('${index + 1}.'),
                                  SizedBox(width: AppSize.s4.rw),
                                  Expanded(child: Text(_items[index].title)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: AppSize.s8.rw),
                            child: MenuSnoozeView(
                              items: _items[index],
                              providerId: widget.providerID,
                              borderRadius: AppSize.s8.rSp,
                              width: AppSize.s80.rw,
                              bgColor: AppColors.whiteSmoke,
                              parentEnabled: widget.parentEnabled,
                              brandId: widget.brandID,
                              onEnabledChange: (enabled) {
                                _onChangedEnabled(index, enabled);
                              },
                              onOosChanged: (stock) {
                                _onChangedOos(index, stock);
                              },
                            ),
                          ),
                          MenuSwitchView(
                            id: _items[index].id,
                            brandId: widget.brandID,
                            providerId: widget.providerID,
                            type: MenuType.ITEM,
                            enabled: _items[index].stock.available,
                            parentEnabled: widget.parentEnabled &&
                                widget.subSections.enabled,
                            onChanged: (enabled) {
                              _onChangedEnabled(index, enabled);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
