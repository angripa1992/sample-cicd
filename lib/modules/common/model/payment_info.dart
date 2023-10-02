import 'package:klikit/app/extensions.dart';

import '../entities/payment_info.dart';

class PaymentMethodModel {
  int? id;
  String? title;
  List<PaymentChannelModel>? channels;

  PaymentMethodModel({this.id, this.title, this.channels});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['group_id'];
    title = json['group_title'];
    if (json['channels'] != null) {
      channels = <PaymentChannelModel>[];
      json['channels'].forEach((v) {
        channels!.add(PaymentChannelModel.fromJson(v));
      });
    }
  }

  PaymentMethod toEntity() => PaymentMethod(
        id: id.orZero(),
        title: title.orEmpty(),
        channels: channels?.map((e) => e.toEntity()).toList() ?? [],
      );
}

class PaymentChannelModel {
  int? id;
  String? title;
  int? sequence;

  PaymentChannelModel({this.id, this.title, this.sequence});

  PaymentChannelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sequence = json['sequence'];
  }

  PaymentChannel toEntity() {
    return PaymentChannel(
      id: id.orZero(),
      title: title.orEmpty(),
      sequence: sequence.orZero(),
    );
  }
}

class PaymentStatusModel {
  int? id;
  String? title;

  PaymentStatusModel({this.id, this.title});

  PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  PaymentStatus toEntity() => PaymentStatus(
        id: id.orZero(),
        title: title.orEmpty(),
      );
}
