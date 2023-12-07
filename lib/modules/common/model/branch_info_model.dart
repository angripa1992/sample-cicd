import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/common/entities/branch_info.dart';

class BusinessBranchInfoModel {
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
  double? lat;
  double? lon;
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
  String? webshopCustomFeesTitle;
  bool? mergeFeeEnable;
  String? mergeFeeTitle;

  BusinessBranchInfoModel({
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
    this.webshopCustomFeesTitle,
    this.mergeFeeEnable,
    this.mergeFeeTitle,
  });

  BusinessBranchInfoModel.fromJson(dynamic json) {
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
    brandIds = json['brand_ids'] != null ? json['brand_ids'].cast<int>() : [];
    brandTitles = json['brand_titles'] != null ? json['brand_titles'].cast<String>() : [];
    dayAvailability = json['day_availability'] != null ? json['day_availability'].cast<int>() : [];
    kitchenEquipmentIds = json['kitchen_equipment_ids'] != null ? json['kitchen_equipment_ids'].cast<int>() : [];
    webshopCustomFeesTitle = json['webshop_custom_fees_title'];
    mergeFeeEnable = json['merge_fees_enabled'];
    mergeFeeTitle = json['merge_fees_title'];
  }

  BusinessBranchInfo toEntity() => BusinessBranchInfo(
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
        webshopCustomFeesTitle: webshopCustomFeesTitle ?? 'Packaging Fee',
        mergeFeeTitle: mergeFeeTitle.orEmpty(),
        mergeFeeEnabled: mergeFeeEnable.orFalse(),
      );
}
