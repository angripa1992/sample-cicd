import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/core/widgets/kt_network_image.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_switch_view.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../app/constants.dart';
import '../../../../../app/user_permission_manager.dart';
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
  final int branchID;
  final Function(List<MenuCategoryItem>) onChanged;

  const MenuCategoryItemListView({
    Key? key,
    required this.menuCategory,
    required this.onChanged,
    required this.parentEnabled,
    required this.brandID,
    required this.branchID,
  }) : super(key: key);

  @override
  State<MenuCategoryItemListView> createState() => _MenuCategoryItemListViewState();
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
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.s14.rSp),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: ScreenSizes.screenHeight / 1.2,
          child: MenuItemDetails(
            menuCategoryItem: _menuCategoryItems[index],
            parentEnabled: widget.parentEnabled && widget.menuCategory.enabled,
            brandID: widget.brandID,
            branchID: widget.branchID,
            onMenuItemSnoozeChanged: (oos) {
              _onItemSnoozeChanged(index, oos);
            },
            onMenuEnabledChanged: (enabled) {
              _onMenuEnabledChanged(index, enabled);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _menuCategoryItems.isNotEmpty
          ? ListView.separated(
              key: UniqueKey(),
              itemCount: _menuCategoryItems.length,
              itemBuilder: (_, index) {
                final categoryItem = _menuCategoryItems[index];

                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s6.rh),
                  child: InkWell(
                    onTap: () {
                      _showItemDetails(index);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: (UserPermissionManager().canOosMenu() && !categoryItem.enabled) ? 0.5 : 1.0,
                          child: KTNetworkImage(
                            imageUrl: categoryItem.image,
                            width: AppSize.s48.rSp,
                            height: AppSize.s48.rSp,
                            boxFit: BoxFit.cover,
                            boxShape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                            imageBorderWidth: 0,
                          ),
                        ),
                        SizedBox(width: AppSize.s16.rw),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryItem.title.trim(),
                                style: mediumTextStyle(fontSize: AppSize.s14.rSp, color: AppColors.neutralB500),
                              ),
                              AppSize.s4.verticalSpacer(),
                              Text(
                                PriceCalculator.formatPrice(
                                  price: categoryItem.klikitPrice().price(),
                                  code: categoryItem.klikitPrice().currencyCode,
                                  symbol: categoryItem.klikitPrice().currencySymbol,
                                ),
                                textAlign: TextAlign.center,
                                style: regularTextStyle(fontSize: AppSize.s12.rSp, color: AppColors.neutralB400),
                              ),
                              if (UserPermissionManager().canOosMenu() && !categoryItem.enabled)
                                MenuSnoozeView(
                                  menuCategoryItem: categoryItem,
                                  branchID: widget.branchID,
                                  parentEnabled: widget.parentEnabled && widget.menuCategory.enabled,
                                  brandId: widget.brandID,
                                  onMenuItemSnoozeChanged: (oos) {
                                    _onItemSnoozeChanged(index, oos);
                                  },
                                  onMenuEnabledChanged: (enabled) {
                                    _onMenuEnabledChanged(index, enabled);
                                  },
                                ).setVisibilityWithSpace(direction: Axis.vertical, startSpace: AppSize.s6.rh),
                            ],
                          ),
                        ),
                        AppSize.s12.horizontalSpacer(),
                        MenuSwitchView(
                          menuVersion: widget.menuCategory.menuVersion,
                          id: categoryItem.id,
                          brandId: widget.brandID,
                          branchId: widget.branchID,
                          type: MenuType.ITEM,
                          enabled: categoryItem.enabled,
                          parentEnabled: widget.parentEnabled && widget.menuCategory.enabled,
                          onMenuEnableChanged: (enabled) {
                            _onMenuEnabledChanged(index, enabled);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rh),
                  child: Divider(height: AppSize.s1.rh),
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
  }
}
