import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

class DateTimeProvider{

  static String today (){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(DateTime.now());
    return formatted;
  }

  static String yesterday (){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(DateTime.now().subtract(const Duration(days: 1)));
    return formatted;
  }

  static String nextDay (){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(DateTime.now().add(const Duration(days: 1)));
    return formatted;
  }

  static Future<String> timeZone () async{
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    return currentTimeZone;
  }
}