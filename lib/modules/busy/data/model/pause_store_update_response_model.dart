import 'package:klikit/app/extensions.dart';

import '../../domain/entity/pause_store_update_response.dart';

class PauseStoreUpdateResponseModel {
  int? duration;
  String? message;
  int? timeLeft;
  List<String>? warning;

  PauseStoreUpdateResponseModel({this.message, this.warning});

  PauseStoreUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    duration = json['duration'];
    message = json['message'];
    timeLeft = json['time_left'];
    warning = json['warning']?.cast<String>() ?? [];
  }

  PauseStoreUpdateResponse toEntity() => PauseStoreUpdateResponse(
        duration: duration.orZero(),
        timeLeft: timeLeft.orZero(),
        message: message.orEmpty(),
        warnings: warning ?? [],
      );
}
