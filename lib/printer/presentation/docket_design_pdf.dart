import 'package:flutter/services.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/source.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../app/di.dart';
import '../../core/provider/date_time_provider.dart';
import '../../core/provider/order_information_provider.dart';
import '../../core/utils/price_calculator.dart';
import '../../modules/orders/domain/entities/cart.dart';
import '../../modules/orders/domain/entities/order.dart';

class DocketDesignPdf {
  static final _instance = DocketDesignPdf._internal();
  final _infoProvider = getIt.get<OrderInformationProvider>();

  factory DocketDesignPdf() => _instance;

  DocketDesignPdf._internal();

  List<pw.Font> fontRegularFallback = [];
  List<pw.Font> fontBoldFallback = [];
  List<pw.Font> fontSemiBoldFallback = [];
  List<pw.Font> fontMediumFallback = [];

  late pw.Font fontRegular;
  late pw.Font fontRegularThai;
  late pw.Font fontRegularChinese;
  late pw.Font fontBold;
  late pw.Font fontBoldThai;
  late pw.Font fontBoldChinese;
  late pw.Font fontMedium;
  late pw.Font fontMediumThai;
  late pw.Font fontMediumChinese;
  late pw.Font fontSemiBold;
  late pw.Font fontSemiBoldThai;
  late pw.Font fontSemiBoldChinese;

  late pw.MemoryImage _footerImage;
  late pw.TextStyle _itemTextStyle;
  late pw.TextStyle _modifiersTextStyle;
  late pw.TextStyle _deliveryInfoTextStyle;
  late pw.TextStyle _internalIdTextStyle;
  late pw.TextStyle _totalPriceTextStyle;
  late pw.TextStyle _subTotalTextStyle;

  Brand? _brand;
  Source? _source;
  Provider? _provider;

  Future _initResources() async {
    fontRegular = await PdfGoogleFonts.notoSansRegular();
    fontMedium = await fontFromAssetBundle('assets/docket_fonts/NotoSans-Medium.ttf');
    fontSemiBold = await fontFromAssetBundle('assets/docket_fonts/NotoSans-SemiBold.ttf');
    fontBold = await PdfGoogleFonts.notoSansBold();


    fontRegularThai = await PdfGoogleFonts.notoSansThaiRegular();
    fontMediumThai = await PdfGoogleFonts.notoSansThaiMedium();
    fontSemiBoldThai = await PdfGoogleFonts.notoSansThaiSemiBold();
    fontBoldThai = await PdfGoogleFonts.notoSansThaiBold();

    fontRegularChinese = await PdfGoogleFonts.zCOOLQingKeHuangYouRegular();
    fontBoldChinese = await PdfGoogleFonts.zCOOLQingKeHuangYouRegular();
    fontMediumChinese = await PdfGoogleFonts.zCOOLQingKeHuangYouRegular();
    fontSemiBoldChinese = await PdfGoogleFonts.zCOOLQingKeHuangYouRegular();

    fontRegularFallback = [
      fontRegular,
      fontRegularThai,
      fontRegularChinese,
    ];
    fontBoldFallback = [
      fontBold,
      fontBoldThai,
      fontBoldChinese,
    ];
    fontSemiBoldFallback = [
      fontSemiBold,
      fontSemiBoldThai,
      fontSemiBoldChinese,
    ];
    fontMediumFallback = [
      fontMedium,
      fontMediumThai,
      fontMediumChinese,
    ];

    _itemTextStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 11,
      font: fontSemiBold,
      fontFallback: fontSemiBoldFallback,
    );

    _modifiersTextStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 11,
      font: fontMedium,
      fontFallback: fontMediumFallback,
    );

    _deliveryInfoTextStyle = pw.TextStyle(
      fontSize: 11,
      color: PdfColors.black,
      font: fontMedium,
      fontFallback: fontMediumFallback,
    );

    _internalIdTextStyle = pw.TextStyle(
      fontSize: 11,
      color: PdfColors.black,
      font: fontMedium,
      fontFallback: fontMediumFallback,
    );

    _totalPriceTextStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 11,
      font: fontSemiBold,
      fontFallback: fontSemiBoldFallback,
    );

    _subTotalTextStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 11,
      font: fontRegular,
      fontFallback: fontRegularFallback,
    );

    _footerImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/app_logo.png'))
          .buffer
          .asUint8List(),
    );
  }

  Future<Uint8List> generateTicket(Order order) async {
    await _initResources();
    await _loadInformation(order);
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(0),
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => _fullPdfPage(order),
      ),
    );
    return pdf.save();
  }

  Future _loadInformation(Order order) async {
    _brand = await _infoProvider.findBrandById(order.brandId);
    if (order.source > 0) {
      _source = await _infoProvider.findSourceById(order.source);
    } else {
      _provider = await _infoProvider.findProviderById(order.providerId);
    }
  }

  pw.Widget _fullPdfPage(Order order) {
    return pw.Column(
      children: [
        _headerWidget(order),
        _docketSeparator(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: _deliveryInfo(order),
        ),
        _docketSeparator(),
        order.orderComment.isEmpty
            ? _docketSeparator()
            : pw.Padding(
                padding: const pw.EdgeInsets.only(top: 8.0),
                child: _commentView(order.orderComment, true),
              ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: _itemsDetails(order),
        ),
        _docketSeparator(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: _priceView(order),
        ),
        _docketSeparator(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: _totalPriceView(order),
        ),
        _docketSeparator(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: _internalIdView(order),
        ),
        _docketSeparator(),
        if (order.klikitComment.isNotEmpty) _klikitComment(order.klikitComment),
        if (order.klikitComment.isNotEmpty) _docketSeparator(),
        if (_brand!.qrLabel.isNotEmpty && _brand!.qrContent.isNotEmpty)
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8),
            child: _qrCode(order),
          ),
        _footerWidget(),
      ],
    );
  }

  pw.Widget _headerWidget(Order order) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          color: PdfColors.black,
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Center(
            child: pw.Text(
              'Order Date: ${DateTimeProvider.orderCreatedDate(order.createdAt)} at ${DateTimeProvider.orderCreatedTime(order.createdAt)}',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 11,
                font: fontBold,
                fontFallback: fontBoldFallback,
              ),
            ),
          ),
        ),
        order.userFirstName.isNotEmpty || order.userLastName.isNotEmpty
            ? pw.Padding(
                padding: const pw.EdgeInsets.only(top: 8.0),
                child: pw.Text(
                  '${order.userFirstName} ${order.userLastName}',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 11,
                    font: fontBold,
                    fontFallback: fontBoldFallback,
                  ),
                ),
              )
            : pw.Container(),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                order.source > 0
                    ? (_source?.name ?? '')
                    : (_provider?.title ?? ''),
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 14,
                  font: fontBold,
                  fontFallback: fontBoldFallback,
                ),
              ),
              pw.Text(
                (order.providerId == ProviderID.KLIKIT)
                    ? '#${order.id}'
                    : '#${order.shortId}',
                style: pw.TextStyle(
                  color: PdfColors.black,
                  fontSize: 14,
                  font: fontBold,
                  fontFallback: fontBoldFallback,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _deliveryInfo(Order order) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        order.brandName.isNotEmpty
            ? pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2.0),
                child: pw.Text(
                  order.brandName,
                  style: _deliveryInfoTextStyle,
                ),
              )
            : pw.Container(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${order.itemCount} item${order.itemCount > 1 ? '(s)' : ''}',
              style: _deliveryInfoTextStyle,
            ),
            pw.Text(
              order.type == OrderType.DELIVERY
                  ? 'Delivery'
                  : (order.type == OrderType.PICKUP ? 'Pick-up' : "Manual"),
              style: _deliveryInfoTextStyle,
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _internalIdView(Order order) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'INTERNAL ID',
          style: _internalIdTextStyle,
        ),
        pw.Text(
          '#${order.id}',
          style: _internalIdTextStyle,
        ),
      ],
    );
  }

  pw.Widget _commentView(String comment, bool isOrderComment) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Container(
        color: PdfColors.black,
        padding: const pw.EdgeInsets.all(4),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text(
              '${isOrderComment ? 'ORDER' : 'ITEM'} NOTE:',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 11,
                font: fontMedium,
                fontFallback: fontMediumFallback,
              ),
            ),
            pw.Text(
              comment,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 11,
                font: fontRegular,
                fontFallback: fontRegularFallback,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _cartItemView(
    Order order,
    CartV2 cartV2,
    String currencySymbol,
  ) {
    return pw.Row(
      children: [
        pw.Text('${cartV2.quantity}x', style: _itemTextStyle),
        pw.SizedBox(width: 4),
        pw.Expanded(child: pw.Text(cartV2.name, style: _itemTextStyle)),
        pw.SizedBox(width: 8),
        pw.Text(
          '$currencySymbol${PriceCalculator.calculateItemPrice(order, cartV2)}',
          style: _itemTextStyle,
        ),
      ],
    );
  }

  pw.Widget _modifierItemView(
    Order order,
    Modifiers modifiers,
    int prevQuantity,
    int itemQuantity,
  ) {
    return pw.Row(
      children: [
        pw.Text('• ${modifiers.quantity}x', style: _modifiersTextStyle),
        pw.SizedBox(width: 8),
        pw.Expanded(child: pw.Text(modifiers.name, style: _modifiersTextStyle)),
        pw.SizedBox(width: 8),
        pw.Text(
          '${order.currencySymbol}${PriceCalculator.calculateModifierPrice(order, modifiers, prevQuantity, itemQuantity)}',
          style: _itemTextStyle,
        ),
      ],
    );
  }

  pw.Widget _showModifierGroupName(String name) {
    if (name.isEmpty) {
      return pw.SizedBox();
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Text(
        name,
        style: _itemTextStyle,
      ),
    );
  }

  pw.Widget _priceView(Order order) {
    return pw.Column(
      children: [
        _getSubtotalItem(
          order,
          'Subtotal:',
          PriceCalculator.calculateSubtotal(order),
        ),
        _getSubtotalItem(
          order,
          'VAT:',
          order.vat,
        ),
        _getSubtotalItem(
          order,
          'Delivery Fee:',
          order.deliveryFee,
        ),
        _getSubtotalItem(
          order,
          'Discount:',
          order.discount,
          isDiscount: true,
        ),
        _getSubtotalItem(
          order,
          'Additional Fee:',
          order.additionalFee,
        ),
      ],
    );
  }

  pw.Widget _totalPriceView(Order order) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Total:',
          style: _totalPriceTextStyle,
        ),
        pw.Text(
          '${order.currencySymbol}${PriceCalculator.convertPrice(order.finalPrice)}',
          style: _totalPriceTextStyle,
        ),
      ],
    );
  }

  pw.Widget _getSubtotalItem(
    Order order,
    String name,
    num price, {
    bool isDiscount = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          name,
          style: _subTotalTextStyle,
        ),
        pw.Text(
          '${isDiscount ? '-' : ''}${order.currencySymbol}${PriceCalculator.convertPrice(price)}',
          style: _subTotalTextStyle,
        ),
      ],
    );
  }

  pw.Widget _qrCode(Order order) {
    return pw.Column(
      children: [
        pw.Text(
          _brand?.qrLabel ?? '',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 11,
            font: fontRegular,
            fontFallback: fontRegularFallback,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 4, bottom: 4),
          child: pw.BarcodeWidget(
            color: PdfColor.fromHex("#000000"),
            barcode: pw.Barcode.qrCode(),
            data: _brand?.qrContent ?? '',
            height: 80,
            width: 80,
          ),
        ),
      ],
    );
  }

  pw.Widget _footerWidget() {
    return pw.Column(
      children: [
        pw.Text(
          'Powered by',
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 11,
            font: fontRegular,
            fontFallback: fontRegularFallback,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 2, bottom: 2),
          child: pw.Image(
            _footerImage,
            width: 30,
            height: 30,
          ),
        ),
        pw.Text(
          'klikit',
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 11,
            font: fontRegular,
            fontFallback: fontRegularFallback,
          ),
        ),
      ],
    );
  }

  pw.Widget _klikitComment(String comment) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
      child: pw.Container(
        color: PdfColors.black,
        padding: const pw.EdgeInsets.all(4),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text(
              'KLIKIT NOTE:',
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 11,
                font: fontMedium,
                fontFallback: fontMediumFallback,
              ),
            ),
            pw.Text(
              comment,
              style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 11,
                  font: fontRegular,
                  fontFallback: fontRegularFallback),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _docketSeparator() {
    return pw.Container(
      width: double.infinity,
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
              color: PdfColors.black, width: 1.0, style: pw.BorderStyle.dotted),
        ),
      ),
    );
  }

  pw.Widget _itemsDetails(Order order) {
    return pw.ListView.builder(
      itemCount: order.cartV2.length,
      itemBuilder: (_, index) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            ///cart item
            _cartItemView(order, order.cartV2[index], order.currencySymbol),
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: order.cartV2[index].modifierGroups.map(
                  (modifiersGroup) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        ///level 1 modifiers group
                        _showModifierGroupName(modifiersGroup.name),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: modifiersGroup.modifiers.map(
                            (modifiers) {
                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(
                                  left: 8,
                                ),
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.stretch,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    ///level 1 modifiers
                                    _modifierItemView(order, modifiers, 1,
                                        order.cartV2[index].quantity),
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.only(
                                        left: 8,
                                      ),
                                      child: pw.Column(
                                        crossAxisAlignment:
                                            pw.CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.start,
                                        children: modifiers.modifierGroups.map(
                                          (modifierGroups) {
                                            return pw.Padding(
                                              padding: const pw.EdgeInsets.only(
                                                left: 8,
                                              ),
                                              child: pw.Column(
                                                crossAxisAlignment: pw
                                                    .CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    pw.MainAxisAlignment.start,
                                                children: [
                                                  ///level 2 modifiers group
                                                  _showModifierGroupName(
                                                      modifiersGroup.name),
                                                  pw.Column(
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .stretch,
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .start,
                                                    children: modifierGroups
                                                        .modifiers
                                                        .map(
                                                      (secondModifiers) {
                                                        return pw.Padding(
                                                          padding: const pw
                                                              .EdgeInsets.only(
                                                            left: 8,
                                                          ),

                                                          ///level 2 modifiers
                                                          child: _modifierItemView(
                                                              order,
                                                              secondModifiers,
                                                              modifiers
                                                                  .quantity,
                                                              order
                                                                  .cartV2[index]
                                                                  .quantity),
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
            order.cartV2[index].comment.isNotEmpty
                ? _commentView(order.cartV2[index].comment, false)
                : pw.Container(),
          ],
        );
      },
    );
  }
}