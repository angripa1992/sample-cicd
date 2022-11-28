import 'package:flutter/material.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/printer/presentation/docket_separator.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../../core/provider/order_information_provider.dart';
import '../../modules/orders/domain/entities/cart.dart';
import '../../modules/orders/domain/entities/order.dart';
import '../../modules/orders/domain/entities/provider.dart';

class DocketDesign extends StatelessWidget {
  final _infoProvider = getIt.get<OrderInformationProvider>();
  final Order order;

  DocketDesign({Key? key, required this.order}) : super(key: key);

  final _itemTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  final _modifiersTextStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: SingleChildScrollView(
    //     child: SizedBox(
    //       width: 300,
    //       child: Column(
    //         children: [
    //           _headerWidget(),
    //           const DocketSeparator(),
    //           _deliveryInfo(),
    //           order.orderComment.isEmpty
    //               ? const DocketSeparator()
    //               : _commentView(order.orderComment),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 2.0),
    //             child: _itemsDetails(context),
    //           ),
    //           const DocketSeparator(),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 2.0),
    //             child: _priceView(),
    //           ),
    //           const DocketSeparator(),
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 2.0),
    //             child: _totalPriceView(),
    //           ),
    //           const DocketSeparator(),
    //           _internalIdView(),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return  SingleChildScrollView(
      child: SizedBox(
        width: 250,
        child: Column(
          children: [
            _headerWidget(),
            const DocketSeparator(),
            _deliveryInfo(),
            order.orderComment.isEmpty
                ? const DocketSeparator()
                : _commentView(order.orderComment),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: _itemsDetails(context),
            ),
            const DocketSeparator(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: _priceView(),
            ),
            const DocketSeparator(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: _totalPriceView(),
            ),
            const DocketSeparator(),
            _internalIdView(),
          ],
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: Colors.black,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Order by ${DateTimeProvider.orderCreatedDate(order.createdAt)} at ${DateTimeProvider.orderCreatedTime(order.createdAt)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Visibility(
          visible: (order.userFirstName.isNotEmpty || order.userLastName.isNotEmpty),
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${order.userFirstName} ${order.userLastName}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: FutureBuilder<Provider>(
            future: _infoProvider.getProviderById(order.providerId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data!.title}  ${(order.providerId == ProviderID.KLIKIT) ? '#${order.id}' : '#${order.shortId}'}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _commentView(String comment) {
    return Visibility(
      visible: comment.isNotEmpty,
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'ORDER NOTE:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              comment,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deliveryInfo() {
    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: order.brandName.isNotEmpty,
            child: Text(
              order.brandName,
              style: textStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.cartV2.length} item${order.cartV2.length > 1 ? '(s)' : ''}',
                style: textStyle,
              ),
              Text(
                order.type == OrderType.DELIVERY ? 'Delivery':'Pickup',
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _internalIdView() {
    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'INTERNAL ID',
            style: textStyle,
          ),
          Text(
            '#${order.id}',
            style: textStyle,
          ),
        ],
      ),
    );
  }

  Widget _itemsDetails(BuildContext context) {
    return ListView.builder(
      itemCount: order.cartV2.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ///cart item
            _cartItemView(order.cartV2[index], order.currencySymbol),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: order.cartV2[index].modifierGroups.map(
                  (modifiersGroup) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ///level 1 modifiers group
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: modifiersGroup.modifiers.map(
                            (modifiers) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ///level 1 modifiers
                                    _modifierItemView(modifiers),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: modifiers.modifierGroups.map(
                                          (modifierGroups) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ///level 2 modifiers group
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: modifierGroups
                                                        .modifiers
                                                        .map(
                                                      (modifiers) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8,
                                                          ),

                                                          ///level 2 modifiers
                                                          child:
                                                              _modifierItemView(
                                                                  modifiers),
                                                        );
                                                      },
                                                    ).toList(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
            ///comment
            _commentView('order.cartV2[index].comment'),
          ],
        );
      },
    );
  }

  Widget _cartItemView(CartV2 cartV2, String currencySymbol) {
    return Row(
      children: [
        Text('${cartV2.quantity}x', style: _itemTextStyle),
        const SizedBox(width: 4),
        Expanded(child: Text(cartV2.name, style: _itemTextStyle)),
        const SizedBox(width: 8),
        Text(
          '$currencySymbol${cartV2.price}',
          style: _itemTextStyle,
        ),
      ],
    );
  }

  Widget _modifierItemView(Modifiers modifiers) {
    return Row(
      children: [
        Text('• ${modifiers.quantity}x', style: _modifiersTextStyle),
        const SizedBox(width: 8),
        Expanded(child: Text(modifiers.name, style: _modifiersTextStyle)),
      ],
    );
  }

  Widget _priceView() {
    return Column(
      children: [
        _getSubtotalItem(
          'Subtotal:',
          _subtotal(),
        ),
        _getSubtotalItem(
          'Vat:',
          order.vat,
        ),
        _getSubtotalItem(
          'Delivery Fee:',
          order.deliveryFee,
        ),
        _getSubtotalItem(
          'Discount:',
          order.discount,
        ),
        _getSubtotalItem(
          'Additional Fee:',
          order.additionalFee,
        ),
      ],
    );
  }

  Widget _totalPriceView(){
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total:',
          style: textStyle,
        ),
        Text(
          '${order.currencySymbol}${_convertPrice(order.finalPrice)}',
          style: textStyle,
        ),
      ],
    );
  }

  Widget _getSubtotalItem(String name, num price) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: textStyle,
        ),
        Text(
          '${order.currencySymbol}${_convertPrice(price)}',
          style: textStyle,
        ),
      ],
    );
  }

  num _subtotal() {
    late num subtotal;
    if (order.providerId == ProviderID.FOOD_PANDA) {
      subtotal = (order.finalPrice + order.discount) - order.deliveryFee;
    } else {
      subtotal = order.itemPrice;
    }
    return subtotal;
  }

  String _convertPrice(num price) {
    return (price / 100).toStringAsFixed(2);
  }
}
