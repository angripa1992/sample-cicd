
class BusinessBranchInfo {
  final int id;
  final int businessId;
  final String title;
  final String address;
  final String phone;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;
  final int openingTime;
  final int closingTime;
  final double lat;
  final double lon;
  final int cityId;
  final int countryId;
  final int currencyId;
  final int availabilityMask;
  final int subscriptionType;
  final int serviceChargePercentage;
  final bool isChurned;
  final int menuVersion;
  final int menuVersionForKlikitOrder;
  final bool fromCsv;
  final bool manualOrderAutoAcceptEnabled;
  final String currencyCode;
  final String currencySymbol;
  final String languageId;
  final String languageTitle;
  final String languageCode;
  final String businessTitle;
  final bool isBusy;
  final String busyModeUpdatedAt;
  final List<int> brandIds;
  final List<String> brandTitles;
  final List<int> dayAvailability;
  final List<int> kitchenEquipmentIds;

  BusinessBranchInfo({
    required this.id,
    required this.businessId,
    required this.title,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.openingTime,
    required this.closingTime,
    required this.lat,
    required this.lon,
    required this.cityId,
    required this.countryId,
    required this.currencyId,
    required this.availabilityMask,
    required this.subscriptionType,
    required this.serviceChargePercentage,
    required this.isChurned,
    required this.menuVersion,
    required this.menuVersionForKlikitOrder,
    required this.fromCsv,
    required this.manualOrderAutoAcceptEnabled,
    required this.currencyCode,
    required this.currencySymbol,
    required this.languageId,
    required this.languageTitle,
    required this.languageCode,
    required this.businessTitle,
    required this.isBusy,
    required this.busyModeUpdatedAt,
    required this.brandIds,
    required this.brandTitles,
    required this.dayAvailability,
    required this.kitchenEquipmentIds,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['business_id'] = businessId;
    map['title'] = title;
    map['address'] = address;
    map['phone'] = phone;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['deleted_at'] = deletedAt;
    map['opening_time'] = openingTime;
    map['closing_time'] = closingTime;
    map['lat'] = lat;
    map['lon'] = lon;
    map['city_id'] = cityId;
    map['country_id'] = countryId;
    map['currency_id'] = currencyId;
    map['availability_mask'] = availabilityMask;
    map['subscription_type'] = subscriptionType;
    map['service_charge_percentage'] = serviceChargePercentage;
    map['is_churned'] = isChurned;
    map['menu_version'] = menuVersion;
    map['menu_version_for_klikit_order'] = menuVersionForKlikitOrder;
    map['from_csv'] = fromCsv;
    map['manual_order_auto_accept_enabled'] = manualOrderAutoAcceptEnabled;
    map['currency_code'] = currencyCode;
    map['currency_symbol'] = currencySymbol;
    map['language_id'] = languageId;
    map['language_title'] = languageTitle;
    map['language_code'] = languageCode;
    map['business_title'] = businessTitle;
    map['is_busy'] = isBusy;
    map['busy_mode_updated_at'] = busyModeUpdatedAt;
    map['brand_ids'] = brandIds;
    map['brand_titles'] = brandTitles;
    map['day_availability'] = dayAvailability;
    map['kitchen_equipment_ids'] = kitchenEquipmentIds;
    return map;
  }
}
