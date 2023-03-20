import 'package:flutter/material.dart';

class CategoriesColorProvider {
  static final _instance = CategoriesColorProvider._internal();
  final _colors = [
    const Color(0xFFF0E7FE),
    const Color(0xFFD3FDE8),
    const Color(0xFFFDFECA),
    const Color(0xFFBEE9FD)
  ];

  factory CategoriesColorProvider() => _instance;

  CategoriesColorProvider._internal();

  Color color(int index) => _colors[index % 4];
}
