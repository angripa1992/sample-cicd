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
  final List<MenuCategoryItem> _menuCategoryItems = [];

  @override
  void initState() {
    _menuCategoryItems.addAll(widget.menuCategory.items);
    super.initState();
  }

  void _onMenuEnabledChanged(int index, bool enabled) {
    setState(() {
      _menuCategoryItems[index].enabled = enabled;
      _menuCategoryItems[index].outOfStock.available = enabled;
      widget.onChanged(_menuCategoryItems);
      _sendSegment(_menuCategoryItems[index]);
    });
  }

  void _onItemSnoozeChanged(int index, MenuOutOfStock oos) {
    setState(() {
      _menuCategoryItems[index].outOfStock = oos;
      widget.onChanged(_menuCategoryItems);
      _sendSegment(_menuCategoryItems[index]);
    });
  }

  void _sendSegment(MenuCategoryItem item) {
    SegmentManager().track(
      event: SegmentEvents.ITEM_TOGGLE,
      properties: {
        'id': item.id,
        'name': item.title,
        'enabled': item.enabled ? 'Yes' : 'No',
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
          menuCategoryItem: _menuCategoryItems[index],
          parentEnabled: widget.parentEnabled && widget.menuCategory.enabled,
          brandID: widget.brandID,
          providerID: widget.providerID,
          brandId: widget.brandID,
          onMenuItemSnoozeChanged: (oos) {
            _onItemSnoozeChanged(index, oos);
          },
          onMenuEnabledChanged: (enabled) {
            _onMenuEnabledChanged(index, enabled);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _menuCategoryItems.isNotEmpty
          ? ListView.builder(
              key: UniqueKey(),
              itemCount: _menuCategoryItems.length,
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
                                      path: _menuCategoryItems[index].image,
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
                                            _menuCategoryItems[index].title,
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
                                    horizontal: AppSize.s8.rw,
                                  ),
                                  child: MenuSnoozeView(
                                    menuCategoryItem: _menuCategoryItems[index],
                                    providerId: widget.providerID,
                                    borderRadius: AppSize.s8.rSp,
                                    width: AppSize.s80.rw,
                                    bgColor: AppColors.whiteSmoke,
                                    parentEnabled: widget.parentEnabled && widget.menuCategory.enabled,
                                    brandId: widget.brandID,
                                    iconPath: AppIcons.editRound,
                                    onMenuItemSnoozeChanged: (oos) {
                                      _onItemSnoozeChanged(index, oos);
                                    },
                                    onMenuEnabledChanged: (enabled) {
                                      _onMenuEnabledChanged(index, enabled);
                                    },
                                  ),
                                ),
                                MenuSwitchView(
                                  menuVersion: widget.menuCategory.menuVersion,
                                  id: _menuCategoryItems[index].id,
                                  brandId: widget.brandID,
                                  providerId: widget.providerID,
                                  type: MenuType.ITEM,
                                  enabled: _menuCategoryItems[index].enabled,
                                  parentEnabled: widget.parentEnabled &&
                                      widget.menuCategory.enabled,
                                  onMenuEnableChanged: (enabled) {
                                    _onMenuEnabledChanged(index, enabled);
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