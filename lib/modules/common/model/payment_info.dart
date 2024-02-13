import 'package:klikit/app/extensions.dart';

import '../entities/payment_info.dart';

class PaymentMethodModel {
  int? id;
  String? title;
  String? logo;
  List<PaymentChannelModel>? channels;

  PaymentMethodModel({this.id, this.title, this.channels});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['group_id'];
    title = json['group_title'];
    logo = json['group_logo'];
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
        logo: logo.orEmpty(),
        channels: channels?.map((e) => e.toEntity()).toList() ?? [],
      );
}

class PaymentChannelModel {
  int? id;
  String? title;
  String? logo;
  int? sequence;
  int? paymentMethodId;

  PaymentChannelModel({this.id, this.title, this.sequence});

  PaymentChannelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
    sequence = json['sequence'];
    paymentMethodId = json['payment_method_id'];
  }

  PaymentChannel toEntity() {
    return PaymentChannel(
      id: id.orZero(),
      title: title.orEmpty(),
      logo: logo.orEmpty(),
      sequence: sequence.orZero(),
      paymentMethodId: paymentMethodId.orZero(),
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
