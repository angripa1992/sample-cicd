import 'dart:convert';
import 'dart:typed_data';

import 'package:klikit/app/constants.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

class StickerDocketGenerator {
  static final _instance = StickerDocketGenerator._internal();

  static const _kYPosition = 'position';
  static const _kValue = 'value';
  static const _font = 'TSS24.BF2'; // font
  static const _lineHeight = 30.0; // Specify the desired line height
  static const _gap = 40.0; // Specify the desired gap between line

  factory StickerDocketGenerator() => _instance;

  StickerDocketGenerator._internal();

  Uint8List generateDocket(Order order, CartV2 item) {
    final content1Map = _orderDetails(order);
    final content2Map = _itemName(item, content1Map[_kYPosition]);
    final content3Map = _modifiers(item, content2Map[_kYPosition]);
    final content4Map = _bottom(
      order: order,
      item: item,
      initialYPosition: content3Map[_kYPosition],
    );
    return _generateBytes(
      content1: content1Map[_kValue],
      content2: content2Map[_kValue],
      content3: content3Map[_kValue],
      content4: content4Map[_kValue],
    );
  }

  Map<String, dynamic> _orderDetails(Order order) {
    final klikitOrderId = order.id;
    final type = _type(order.type);
    final customerName = '${order.userFirstName} ${order.userLastName}';
    final orderDetails = '$klikitOrderId/$type${order.providerId == ProviderID.KLIKIT && customerName.isNotEmpty ? '/$customerName' : ''}';
    final lines = _splitTextIntoLines(orderDetails, 20);
    String tslText = "";
    double yPosition = 0;
    for (int i = 0; i < lines.length; i++) {
      if(i > 0){
        yPosition += _lineHeight;
      }
      tslText += '''TEXT 10,$yPosition,"$_font",0,1,1,"${lines[i]}"\n''';
    }
    return {
      _kYPosition: yPosition,
      _kValue: tslText,
    };
  }

  Map<String, dynamic> _itemName(CartV2 item, double initialYPosition) {
    final lines = _splitTextIntoLines(item.name, 20);
    String tslText = "";
    double yPosition = initialYPosition + _gap;
    for (int i = 0; i < lines.length; i++) {
      if(i > 0){
        yPosition += _lineHeight;
      }
      tslText += '''TEXT 10,$yPosition,"$_font",0,1,1,"${lines[i]}"\n''';
    }
    return {
      _kYPosition: yPosition,
      _kValue: tslText,
    };
  }

  Map<String, dynamic> _modifiers(CartV2 item, double initialYPosition) {
    double yPosition = initialYPosition + _gap - _lineHeight;
    String tslText = "";
    for (var groupOne in item.modifierGroups) {
      for (var modifierOne in groupOne.modifiers) {
        yPosition += _lineHeight;
        final linesOne = _splitTextIntoLines(modifierOne.name, 20);
        for (int i = 0; i < linesOne.length; i++) {
          if(i > 0){
            yPosition += _lineHeight;
          }
          tslText += '''TEXT 10,$yPosition,"$_font",0,1,1,"${linesOne[i]}"\n''';
        }
        for (var groupTwo in modifierOne.modifierGroups) {
          for (var modifierTwo in groupTwo.modifiers) {
            yPosition += _lineHeight;
            final linesTwo = _splitTextIntoLines(modifierTwo.name, 20);
            for (int i = 0; i < linesTwo.length; i++) {
              if(i > 0){
                yPosition += _lineHeight;
              }
              tslText +=
                  '''TEXT 25,$yPosition,"$_font",0,1,1,"${linesTwo[i]}"\n''';
            }
          }
        }
      }
    }
    return {
      _kYPosition: yPosition,
      _kValue: tslText,
    };
  }

  Map<String, dynamic> _bottom({
    required Order order,
    required CartV2 item,
    required double initialYPosition,
  }) {
    String tslText = "";
    final date = DateTimeProvider.getStickerDocketDate(order.createdAt);
    final itemPosition = order.cartV2.indexOf(item) + 1;
    final itemCount = '$itemPosition/${order.cartV2.length}';
    double yPosition = initialYPosition + _gap;
    tslText += '''TEXT 10,$yPosition,"$_font",0,1,1,"$date ........ $itemCount"\n''';
    return {
      _kYPosition: yPosition,
      _kValue: tslText,
    };
  }

  Uint8List _generateBytes({
    required String content1,
    required String content2,
    required String content3,
    required String content4,
  }) {
    String tsplCommands = '''
    SIZE 80 mm, 40 mm
    GAP 4 mm, 0
    SPEED 4
    DENSITY 8
    DIRECTION 1
    REFERENCE 0,0
    OFFSET 0 mm
    $content1
    $content2
    $content3
    $content4    
    PRINT 1
    CLS
  ''';
    List<int> tsplBytes = utf8.encode(tsplCommands);
    return Uint8List.fromList(tsplBytes);
  }

  List<String> _splitTextIntoLines(String text, int lineLength) {
    List<String> lines = [];
    List<String> words = text.split(' ');

    String line = '';
    for (String word in words) {
      if (line.isEmpty) {
        line = word;
      } else {
        String tempLine = '$line $word';
        if (tempLine.length <= lineLength) {
          line = tempLine;
        } else {
          lines.add(line);
          line = word;
        }
      }
    }

    if (line.isNotEmpty) {
      lines.add(line);
    }

    return lines;
  }

  String _type(int type) {
    if (type == OrderType.DELIVERY) {
      return 'Delivery';
    } else if (type == OrderType.PICKUP) {
      return 'Pickup';
    } else {
      return 'Dine-In';
    }
  }
}
