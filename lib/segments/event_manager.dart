import 'package:dio/dio.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/environment_variables.dart';
import 'package:klikit/segments/segemnt_data_provider.dart';

import '../app/constants.dart';

class SegmentManager {
  static final _instance = SegmentManager._internal();
  final _eventParams = getIt.get<SegmentDataProvider>();
  final _dio = Dio()
    ..options.baseUrl = 'https://api.segment.io/v1'
    ..options.headers['Content-Type'] = 'application/json'
    ..options.headers['Authorization'] =
        'Basic ${getIt.get<EnvironmentVariables>().segmentWriteKey}';

  factory SegmentManager() => _instance;

  SegmentManager._internal();

  void identify({required String event}) async {
    final data = await _eventParams.identifyData(event: event);
    try {
      _dio.post('/identify', data: data.toJson());
    } on Exception {
      // ignored
    }
  }

  void track({
    required String event,
    Map<String, dynamic>? properties,
  }) async {
    final data =
        await _eventParams.trackData(event: event, properties: properties);
    try {
      _dio.post('/track', data: data.toJson());
    } on Exception {
      // ignored
    }
  }

  void screen({
    required String event,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    final data = await _eventParams.screenData(
      event: event,
      name: name,
      properties: properties,
    );
    try {
      _dio.post('/screen', data: data.toJson());
    } on Exception {
      // ignored
    }
  }

  void trackOrderSegment({
    required String sourceTab,
    int status = -1,
    bool willPrint = false,
    bool isFromDetails = false,
  }){
    String eventName = '';
    if(willPrint){
      eventName = SegmentEvents.PRINT_ORDER;
    }else if(status == OrderStatus.ACCEPTED){
      eventName = SegmentEvents.ACCEPT_ORDER;
    }else if(status == OrderStatus.CANCELLED){
      eventName = SegmentEvents.CANCEL_ORDER;
    }else if(status == OrderStatus.DELIVERED){
      eventName = SegmentEvents.DELIVER_ORDER;
    }else if(status == OrderStatus.READY){
      eventName = SegmentEvents.READY_ORDER;
    }else if(status == OrderStatus.PICKED_UP){
      eventName = SegmentEvents.PICKUP_ORDER;
    }
    track(
      event: eventName,
      properties: {
        'source_tab': sourceTab,
        'source_screen': isFromDetails ? 'See Details Page' : 'Order Main Page',
      },
    );
  }
}
