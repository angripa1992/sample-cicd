import 'package:klikit/app/extensions.dart';

import '../../domain/entity/pause_store_data.dart';

class PauseStoreDataModel {
  bool? isBusy;
  String? branchName;
  String? busyModeUpdatedAt;
  int? duration;
  int? timeLeft;
  List<BrandPauseInfoModel>? breakdowns;

  PauseStoreDataModel({
    this.isBusy,
    this.branchName,
    this.busyModeUpdatedAt,
    this.duration,
    this.timeLeft,
    this.breakdowns,
  });

  PauseStoreDataModel.fromJson(Map<String, dynamic> json) {
    isBusy = json['is_busy'];
    branchName = json['branch_name'];
    busyModeUpdatedAt = json['busy_mode_updated_at'];
    duration = json['duration'];
    timeLeft = json['time_left'];
    if (json['breakdowns'] != null) {
      breakdowns = <BrandPauseInfoModel>[];
      json['breakdowns'].forEach((v) {
        breakdowns!.add(BrandPauseInfoModel.fromJson(v));
      });
    }
  }

  PauseStoresData toEntity() => PauseStoresData(
    isBusy: isBusy.orFalse(),
        branchName: branchName.orEmpty(),
        busyModeUpdatedAt: busyModeUpdatedAt.orEmpty(),
        duration: duration.orZero(),
        timeLeft: timeLeft.orZero(),
        breakdowns: breakdowns?.map((e) => e.toEntity()).toList() ?? [],
      );
}

class BrandPauseInfoModel {
  int? brandId;
  int? branchId;
  String? brandName;
  String? branchName;
  String? brandLogo;
  bool? isBusy;
  String? busyModeUpdatedAt;
  int? duration;
  int? timeLeft;

  BrandPauseInfoModel({
    this.brandId,
    this.branchId,
    this.brandName,
    this.branchName,
    this.brandLogo,
    this.isBusy,
    this.busyModeUpdatedAt,
    this.duration,
    this.timeLeft,
  });

  BrandPauseInfoModel.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    branchId = json['branch_id'];
    brandName = json['brand_name'];
    branchName = json['branch_name'];
    brandLogo = json['brand_logo'];
    isBusy = json['is_busy'];
    busyModeUpdatedAt = json['busy_mode_updated_at'];
    duration = json['duration'];
    timeLeft = json['time_left'];
  }

  PausedStore toEntity() => PausedStore(
    brandId: brandId.orZero(),
        branchId: branchId.orZero(),
        brandName: brandName.orEmpty(),
        branchName: branchName.orEmpty(),
        brandLogo: brandLogo.orEmpty(),
        isBusy: isBusy.orFalse(),
        busyModeUpdatedAt: busyModeUpdatedAt.orEmpty(),
        duration: duration.orZero(),
        timeLeft: timeLeft.orZero(),
      );
}
