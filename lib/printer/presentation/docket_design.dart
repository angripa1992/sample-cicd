import 'package:flutter/material.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/printer/presentation/docket_separator.dart';
import 'package:klikit/resources/assets.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 250,
          child: Column(
            children: [
              _headerWidget(),
              const DocketSeparator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _deliveryInfo(),
              ),
              const DocketSeparator(),
              order.orderComment.isEmpty
                  ? const DocketSeparator()
                  : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _commentView(order.orderComment, true),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _itemsDetails(),
              ),
              const DocketSeparator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _priceView(),
              ),
              const DocketSeparator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _totalPriceView(),
              ),
              const DocketSeparator(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _internalIdView(),
              ),
              const DocketSeparator(),
              if (order.klikitComment.isNotEmpty) _klikitComment(order.klikitComment),
              if (order.klikitComment.isNotEmpty)  const DocketSeparator(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _qrCode(),
              ),
              _footerWidget(),
            ],
          ),
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
              'Order Date: ${DateTimeProvider.orderCreatedDate(order.createdAt)} at ${DateTimeProvider.orderCreatedTime(order.createdAt)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Visibility(
          visible:
              (order.userFirstName.isNotEmpty || order.userLastName.isNotEmpty),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
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
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<Provider>(
                future: _infoProvider.findProviderById(order.providerId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.title,
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
              Text(
                (order.providerId == ProviderID.KLIKIT)
                    ? '#${order.id}'
                    : '#${order.shortId}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStatus() {
    switch (order.status) {
      case OrderStatus.ACCEPTED:
        return 'Accepted';
      case OrderStatus.PLACED:
        return 'Placed';
      case OrderStatus.CANCELLED:
        return 'Canceled';
      case OrderStatus.DELIVERED:
        return 'Delivered';
      case OrderStatus.PICKED_UP:
        return 'Picked Up';
      case OrderStatus.READY:
        return 'Ready';
      case OrderStatus.SCHEDULED:
        return 'Scheduled';
      case OrderStatus.DRIVER_ARRIVED:
        return 'Driver Arrived';
      case OrderStatus.DRIVER_ASSIGNED:
        return 'Driver Assigned';
      default:
        return '';
    }
  }

  Widget _deliveryInfo() {
    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Visibility(
          visible: order.brandName.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              order.brandName,
              style: textStyle,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${order.itemCount} item${order.itemCount > 1 ? '(s)' : ''}',
              style: textStyle,
            ),
            Text(
              _getStatus(),
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }

  Widget _internalIdView() {
    const textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
    return Row(
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
    );
  }

  Widget _itemsDetails() {
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
            _commentView(order.cartV2[index].comment, false),
          ],
        );
      },
    );
  }

  Widget _commentView(String comment, bool isOrderComment) {
    return Visibility(
      visible: comment.isNotEmpty,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${isOrderComment ? 'ORDER' : 'ITEM'} NOTE:',
                style: const TextStyle(
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
      ),
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
          isDiscount: true,
        ),
        _getSubtotalItem(
          'Additional Fee:',
          order.additionalFee,
        ),
      ],
    );
  }

  Widget _totalPriceView() {
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

  Widget _getSubtotalItem(String name, num price, {bool isDiscount = false}) {
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
          '${isDiscount ? '-' : ''}${order.currencySymbol}${_convertPrice(price)}',
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

  Widget _qrCode() {
    return FutureBuilder<Brand>(
      future: _infoProvider.findBrandById(order.brandId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                snapshot.data!.qrLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: QrImage(
                  data: snapshot.data!.qrContent,
                  version: QrVersions.auto,
                  size: 100,
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _footerWidget() {
    return Column(
      children: [
        const Text(
          'Powered by',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          child: Image.asset(
            AppImages.splashLogo,
            color: Colors.black,
            height: 24,
            width: 24,
          ),
        ),
        const Text(
          'klikit',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _klikitComment(String comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'KLIKIT NOTE:',
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
}
