import 'package:klikit/app/extensions.dart';

import '../../domain/entities/payment_info.dart';

class PaymentMethodModel {
  int? id;
  String? title;
  int? sequence;

  PaymentMethodModel({this.id, this.title, this.sequence});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    sequence = json['sequence'];
  }

  PaymentMethod toEntity() => PaymentMethod(
        id: id.orZero(),
        title: title.orEmpty(),
        sequence: sequence.orZero(),
      );
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
