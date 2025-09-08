// lib/myapp.dart
import 'package:anima/page/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // import GetX

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // เปลี่ยนเป็น GetMaterialApp เพื่อใช้งาน GetX
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokémon Team Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(), // เอา title ออก
    );
  }
}