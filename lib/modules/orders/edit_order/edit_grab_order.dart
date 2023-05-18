import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';
import '../../add_order/presentation/pages/components/modifier/quantity_selector.dart';
import '../../widgets/menu_item_image_view.dart';
import '../domain/entities/cart.dart';
import 'editing_manager.dart';

class EditGrabOrderView extends StatelessWidget {
  final Order order;

  const EditGrabOrderView({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          _appBar(),
          _brandSpecificCartItemsListView(),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.s4.rh),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.clear)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cart',
                  style: getMediumTextStyle(
                    color: AppColors.balticSea,
                    fontSize: AppFontSize.s17.rSp,
                  ),
                ),
                SizedBox(height: AppSize.s4.rh),
                Text(
                  '#${order.id} (Order ID)',
                  style: getRegularTextStyle(
                    color: AppColors.dustyGreay,
                    fontSize: AppFontSize.s12.rSp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _brandSpecificCartItemsListView() {
    final brandSpecificCartItems = EditingManager().extractCartItems(order);
    return Expanded(
      child: ListView.builder(
        itemCount: brandSpecificCartItems.length,
        itemBuilder: (context, index) {
          final menuBrand = brandSpecificCartItems[index].first.cartBrand;
          return Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            menuBrand.title,
                            style: getBoldTextStyle(
                              color: AppColors.balticSea,
                              fontSize: AppFontSize.s15.rSp,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Remove All',
                            style: getMediumTextStyle(
                              color: AppColors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _cartItemListView(brandSpecificCartItems[index]),
                  const Divider(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cartItemListView(List<CartV2> items) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                MenuItemImageView(url: item.image),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(item.name),
                      ],
                    ),
                    Text(EditingManager().allCsvModifiersName(item.modifierGroups)),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outlined,
                        color: AppColors.red,
                        size: AppSize.s20.rSp,
                      ),
                      Text(
                        'Delete item',
                        style: getMediumTextStyle(color: AppColors.red),
                      ),
                    ],
                  ),
                ),
                QuantitySelector(
                  quantity: 1,
                  onQuantityChanged: (quantity) {},
                ),
              ],
            ),
          ],
        );
      }, separatorBuilder: (BuildContext context, int index) {
        return Divider();
    },
    );
  }
}
