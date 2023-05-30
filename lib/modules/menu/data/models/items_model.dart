import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/models/prices_model.dart';
import 'package:klikit/modules/menu/data/models/status_model.dart';
import 'package:klikit/modules/menu/data/models/stock_model.dart';
import 'package:klikit/modules/menu/data/models/v2_data_model.dart';

import '../../domain/entities/items.dart';
import '../../domain/entities/price.dart';
import '../../domain/entities/status.dart';

part 'items_model.g.dart';

@JsonSerializable()
class ItemsModel {
  int? id;
  String? title;
  List<PricesModel>? prices;
  int? vat;
  String? description;
  String? image;
  bool? enabled;
  bool? hidden;
  List<StatusesModel>? statuses;
  int? sequence;
  StockModel? stock;
  @JsonKey(name: 'default_item_id')
  int? defaultItemId;
  @JsonKey(name: 'title_v2')
  TitleV2Model? titleV2;
  @JsonKey(name: 'description_v2')
  DescriptionV2Model? descriptionV2;

  ItemsModel({
    this.id,
    this.title,
    this.prices,
    this.vat,
    this.description,
    this.image,
    this.enabled,
    this.hidden,
    this.statuses,
    this.sequence,
    this.defaultItemId,
    this.stock,
    this.titleV2,
    this.descriptionV2,
  });

  factory ItemsModel.fromJson(Map<String, dynamic> json) =>
      _$ItemsModelFromJson(json);

  MenuItems toEntity() {
    return MenuItems(
      id: id.orZero(),
      title: title.orEmpty(),
      prices: _prices(),
      vat: vat.orZero(),
      description: description.orEmpty(),
      image: image.orEmpty(),
      enabled: enabled.orFalse(),
      hidden: hidden.orFalse(),
      statuses: _statuses(),
      sequence: sequence.orZero(),
      defaultItemId: defaultItemId.orZero(),
      stock: stock?.toEntity() ?? StockModel().toEntity(),
      titleV2: titleV2?.toEntity() ?? TitleV2Model().toEntity(),
      descriptionV2: descriptionV2?.toEntity() ?? DescriptionV2Model().toEntity(),
    );
  }

  List<Prices> _prices() {
    List<Prices> pricesData = [];
    if (prices == null) return pricesData;
    for (var element in prices!) {
      pricesData.add(element.toEntity());
    }
    return pricesData;
  }

  List<Statuses> _statuses() {
    List<Statuses> statusesData = [];
    if (statuses == null) return statusesData;
    for (var element in statuses!) {
      statusesData.add(element.toEntity());
    }
    return statusesData;
  }
}
