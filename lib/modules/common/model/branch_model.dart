import 'package:klikit/app/extensions.dart';

import '../entities/branch.dart';

class BranchDataModel {
  List<BranchModel>? results;
  int? total;
  int? page;
  int? size;

  BranchDataModel({this.results, this.total, this.page, this.size});

  BranchDataModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['results'] != null) {
        results = <BranchModel>[];
        json['results'].forEach((v) {
          final branch = BranchModel.fromJson(v);
          results!.add(branch);
        });
      }
    } catch (e) {
      //ignore
    }
    total = json['total'];
    page = json['page'];
    size = json['size'];
  }
}

class BranchModel {
  int? id;
  int? businessId;
  String? title;
  String? address;
  String? phone;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? openingTime;
  int? closingTime;
  num? lat;
  num? lon;
  int? cityId;
  int? countryId;
  int? currencyId;
  int? availabilityMask;
  int? subscriptionType;
  int? serviceChargePercentage;
  bool? isChurned;
  int? menuVersion;
  int? menuVersionForKlikitOrder;
  bool? fromCsv;
  bool? manualOrderAutoAcceptEnabled;
  String? currencyCode;
  String? currencySymbol;
  String? languageId;
  String? languageTitle;
  String? languageCode;
  String? businessTitle;
  bool? isBusy;
  String? busyModeUpdatedAt;
  List<int>? brandIds;
  List<String>? brandTitles;
  List<int>? dayAvailability;
  List<int>? kitchenEquipmentIds;
  String? serviceFeeCustomTitle;
  String? processingFeeCustomTitle;
  bool? mergeFeesEnabled;
  String? mergeFeesTitle;
  bool? webshopCustomFeesEnabled;
  String? webshopCustomFeesTitle;
  String? countryCode;
  bool? prePaymentEnabled;
  bool? postPaymentEnabled;

  BranchModel({
    this.id,
    this.businessId,
    this.title,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.openingTime,
    this.closingTime,
    this.lat,
    this.lon,
    this.cityId,
    this.countryId,
    this.currencyId,
    this.availabilityMask,
    this.subscriptionType,
    this.serviceChargePercentage,
    this.isChurned,
    this.menuVersion,
    this.menuVersionForKlikitOrder,
    this.fromCsv,
    this.manualOrderAutoAcceptEnabled,
    this.currencyCode,
    this.currencySymbol,
    this.languageId,
    this.languageTitle,
    this.languageCode,
    this.businessTitle,
    this.isBusy,
    this.busyModeUpdatedAt,
    this.brandIds,
    this.brandTitles,
    this.dayAvailability,
    this.kitchenEquipmentIds,
    this.serviceFeeCustomTitle,
    this.processingFeeCustomTitle,
    this.mergeFeesEnabled,
    this.mergeFeesTitle,
    this.webshopCustomFeesEnabled,
    this.webshopCustomFeesTitle,
    this.countryCode,
    this.prePaymentEnabled,
    this.postPaymentEnabled,
  });

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    title = json['title'];
    address = json['address'];
    phone = json['phone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    openingTime = json['opening_time'];
    closingTime = json['closing_time'];
    lat = json['lat'];
    lon = json['lon'];
    cityId = json['city_id'];
    countryId = json['country_id'];
    currencyId = json['currency_id'];
    availabilityMask = json['availability_mask'];
    subscriptionType = json['subscription_type'];
    serviceChargePercentage = json['service_charge_percentage'];
    isChurned = json['is_churned'];
    menuVersion = json['menu_version'];
    menuVersionForKlikitOrder = json['menu_version_for_klikit_order'];
    fromCsv = json['from_csv'];
    manualOrderAutoAcceptEnabled = json['manual_order_auto_accept_enabled'];
    currencyCode = json['currency_code'];
    currencySymbol = json['currency_symbol'];
    languageId = json['language_id'];
    languageTitle = json['language_title'];
    languageCode = json['language_code'];
    businessTitle = json['business_title'];
    isBusy = json['is_busy'];
    busyModeUpdatedAt = json['busy_mode_updated_at'];
    brandIds = json['brand_ids']?.cast<int>();
    brandTitles = json['brand_titles']?.cast<String>();
    dayAvailability = json['day_availability']?.cast<int>();
    kitchenEquipmentIds = json['kitchen_equipment_ids']?.cast<int>();
    serviceFeeCustomTitle = json['service_fee_custom_title'];
    processingFeeCustomTitle = json['processing_fee_custom_title'];
    mergeFeesEnabled = json['merge_fees_enabled'];
    mergeFeesTitle = json['merge_fees_title'];
    webshopCustomFeesEnabled = json['webshop_custom_fees_enabled'];
    webshopCustomFeesTitle = json['webshop_custom_fees_title'];
    countryCode = json['country_code'];
    prePaymentEnabled = json['pre_payment_enabled'];
    postPaymentEnabled = json['post_payment_enabled'];
  }

  Branch toEntity() => Branch(
        id: id.orZero(),
        businessId: businessId.orZero(),
        title: title.orEmpty(),
        address: address.orEmpty(),
        phone: phone.orEmpty(),
        createdAt: createdAt.orEmpty(),
        updatedAt: updatedAt.orEmpty(),
        deletedAt: deletedAt.orEmpty(),
        openingTime: openingTime.orZero(),
        closingTime: closingTime.orZero(),
        lat: lat.orZero(),
        lon: lon.orZero(),
        cityId: cityId.orZero(),
        countryId: countryId.orZero(),
        currencyId: currencyId.orZero(),
        availabilityMask: availabilityMask.orZero(),
        subscriptionType: subscriptionType.orZero(),
        serviceChargePercentage: serviceChargePercentage.orZero(),
        isChurned: isChurned.orFalse(),
        menuVersion: menuVersion.orZero(),
        menuVersionForKlikitOrder: menuVersionForKlikitOrder.orZero(),
        fromCsv: fromCsv.orFalse(),
        manualOrderAutoAcceptEnabled: manualOrderAutoAcceptEnabled.orFalse(),
        currencyCode: currencyCode.orEmpty(),
        currencySymbol: currencySymbol.orEmpty(),
        languageId: languageId.orEmpty(),
        languageTitle: languageTitle.orEmpty(),
        languageCode: languageCode.orEmpty(),
        businessTitle: businessTitle.orEmpty(),
        isBusy: isBusy.orFalse(),
        busyModeUpdatedAt: busyModeUpdatedAt.orEmpty(),
        brandIds: brandIds ?? [],
        brandTitles: brandTitles ?? [],
        dayAvailability: dayAvailability ?? [],
        kitchenEquipmentIds: kitchenEquipmentIds ?? [],
        webshopCustomFeesTitle: webshopCustomFeesTitle.orEmpty(),
        mergeFeeEnabled: mergeFeesEnabled.orFalse(),
        mergeFeeTitle: mergeFeesTitle.orEmpty(),

        /// TODO: add remote data
        prePaymentEnabled: true,
        postPaymentEnabled: true,
      );
}
