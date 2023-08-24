import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/modules/widgets/image_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/assets.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/fonts.dart';
import '../../../../../resources/strings.dart';
import '../../../../../resources/styles.dart';
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

  void _onChanged(int index, Stock stock) {
    setState(() {
      _items[index].stock = stock;
      widget.onChanged(_items);
    });
    SegmentManager().track(
      event: SegmentEvents.ITEM_TOGGLE,
      properties: {
        'id': _items[index].id,
        'name': _items[index].title,
        'enabled': stock.available ? 'Yes' : 'No',
      },
    );
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
          onChanged: (stock) {
            _onChanged(index, stock);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _items.isNotEmpty
          ? ListView.builder(
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
                                    padding:
                                        EdgeInsets.only(right: AppSize.s10.rw),
                                    child: ImageView(
                                      path: _items[index].image,
                                      width: AppSize.s36.rw,
                                      height: AppSize.s36.rh,
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Text(
                                          '${index + 1}.',
                                          style: regularTextStyle(
                                            color: AppColors.black,
                                            fontSize: AppFontSize.s14.rSp,
                                          ),
                                        ),
                                        SizedBox(width: AppSize.s4.rw),
                                        Expanded(
                                          child: Text(
                                            _items[index].title,
                                            style: regularTextStyle(
                                              color: AppColors.black,
                                              fontSize: AppFontSize.s14.rSp,
                                            ),
                                          ),
                                        ),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppSize.s8.rw),
                                  child: MenuSnoozeView(
                                    items: _items[index],
                                    providerId: widget.providerID,
                                    borderRadius: AppSize.s8.rSp,
                                    width: AppSize.s80.rw,
                                    bgColor: AppColors.grey,
                                    parentEnabled: widget.parentEnabled &&
                                        widget.subSections.enabled,
                                    brandId: widget.brandID,
                                    iconPath: AppIcons.editRound,
                                    onChanged: (stock) {
                                      _onChanged(index, stock);
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
                                  onItemChanged: (stock) {
                                    _onChanged(index, stock);
                                  },
                                  onMenuChanged: (enabled) {},
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
            )
          : Center(
              child: Text(
                AppStrings.no_item_found.tr(),
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
    );
    ;
  }
}
