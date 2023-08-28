import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

class DateTimeProvider {
  static String currentDateTime() {
    final formatter = DateFormat('d MMM yyyy • h:mm a');
    final String formatted = formatter.format(DateTime.now().toLocal());
    return formatted;
  }

  static String today() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(DateTime.now());
    return formatted;
  }

  static String yesterday() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted =
        formatter.format(DateTime.now().subtract(const Duration(days: 1)));
    return formatted;
  }

  static String nextDay() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted =
        formatter.format(DateTime.now().add(const Duration(days: 1)));
    return formatted;
  }

  static String getDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  static String getStickerDocketDate(String createdAt) {
    final DateFormat formatter = DateFormat('yyyy/MM/dd');
    final dateTime = DateTime.parse(createdAt).toLocal();
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  static String dateRangeString(DateTimeRange dateTimeRange) {
    final formatter = DateFormat('d MMMM yyy');
    final start = formatter.format(dateTimeRange.start);
    final end = formatter.format(dateTimeRange.end);
    return '$start - $end';
  }

  static String parseOrderCreatedDate(String createdAt) {
    final formatter = DateFormat('d MMM yyyy • h:mm a');
    final dateTime = DateTime.parse(createdAt).toLocal();
    return formatter.format(dateTime);
  }

  static String dateTime(String dateTimeStr) {
    final formatter = DateFormat('d MMM yyyy • h:mm a');
    final dateTime = DateTime.parse(dateTimeStr).toLocal();
    return formatter.format(dateTime);
  }

  static String parseSnoozeEndTime(String endTime) {
    final formatter = DateFormat('d MMM yyyy, h:mm a');
    final dateTime = DateTime.parse(endTime).toLocal();
    return formatter.format(dateTime);
  }

  static String orderCreatedDate(String createdAt) {
    final formatter = DateFormat('MMMM d');
    final dateTime = DateTime.parse(createdAt).toLocal();
    return formatter.format(dateTime);
  }

  static String orderCreatedTime(String createdAt) {
    final formatter = DateFormat('h:mm a');
    final dateTime = DateTime.parse(createdAt).toLocal();
    return formatter.format(dateTime);
  }

  static String scheduleDate(String scheduleTime) {
    final formatter = DateFormat('d MMMM yyyy');
    final dateTime = DateTime.parse(scheduleTime).toLocal();
    return formatter.format(dateTime);
  }

  static String scheduleTime(String scheduleTime) {
    final formatter = DateFormat('h:mm a');
    final dateTime = DateTime.parse(scheduleTime).toLocal();
    return formatter.format(dateTime);
  }

  static Future<String> timeZone() async {
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    return currentTimeZone;
  }

  static int timeZoneOffset() {
    return DateTime.now().timeZoneOffset.inMinutes * -1;
  }
}
