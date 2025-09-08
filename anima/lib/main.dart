// lib/main.dart
import 'package:anima/myapp.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // เริ่มต้น GetStorage สำหรับการเก็บข้อมูล
  await GetStorage.init();
  runApp(const MyApp());
}