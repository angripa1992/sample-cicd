import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
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
import '../../../domain/entities/menu/menu_categories.dart';
import '../../../domain/entities/menu/menu_item.dart';
import '../../../domain/entities/menu/menu_out_of_stock.dart';
import 'menu_item_details.dart';
import 'menu_snooze_view.dart';

class MenuCategoryItemListView extends StatefulWidget {
  final MenuCategory menuCategory;
  final bool parentEnabled;
  final int brandID;
  final int providerID;
  final Function(List<MenuCategoryItem>) onChanged;

  const MenuCategoryItemListView({
    Key? key,
    required this.menuCategory,
    required this.onChanged,
    required this.parentEnabled,
    required this.brandID,
    required this.providerID,
  }) : super(key: key);

  @override
  State<MenuCategoryItemListView> createState() =>
      _MenuCategoryItemListViewState();
}

class _MenuCategoryItemListViewState extends State<MenuCategoryItemListView> {
  final List<MenuCategoryItem> _items = [];

  @override
  void initState() {
    _items.addAll(widget.menuCategory.items);
    super.initState();
  }

  void _onChanged(int index, MenuOutOfStock oos) {
    setState(() {
      _items[index].outOfStock = oos;
      widget.onChanged(_items);
    });
    SegmentManager().track(
      event: SegmentEvents.ITEM_TOGGLE,
      properties: {
        'id': _items[index].id,
        'name': _items[index].title,
        'enabled': oos.available ? 'Yes' : 'No',
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
          menuCategoryItem: _items[index],
          parentEnabled: widget.parentEnabled && widget.menuCategory.enabled,
          brandID: widget.brandID,
          providerID: widget.providerID,
          brandId: widget.brandID,
          onChanged: (oos) {
            _onChanged(index, oos);
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
                                            color: AppColors.bluewood,
                                            fontSize: AppFontSize.s14.rSp,
                                          ),
                                        ),
                                        SizedBox(width: AppSize.s4.rw),
                                        Expanded(
                                          child: Text(
                                            _items[index].title,
                                            style: regularTextStyle(
                                              color: AppColors.bluewood,
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
                                    menuCategoryItem: _items[index],
                                    providerId: widget.providerID,
                                    borderRadius: AppSize.s8.rSp,
                                    width: AppSize.s80.rw,
                                    bgColor: AppColors.whiteSmoke,
                                    parentEnabled: widget.parentEnabled &&
                                        widget.menuCategory.enabled,
                                    brandId: widget.brandID,
                                    iconPath: AppIcons.editRound,
                                    onChanged: (oos) {
                                      _onChanged(index, oos);
                                    },
                                  ),
                                ),
                                MenuSwitchView(
                                  id: _items[index].id,
                                  brandId: widget.brandID,
                                  providerId: widget.providerID,
                                  type: MenuType.ITEM,
                                  enabled: _items[index].outOfStock.available,
                                  parentEnabled: widget.parentEnabled &&
                                      widget.menuCategory.enabled,
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
                  color: AppColors.bluewood,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
    );
  }
}
