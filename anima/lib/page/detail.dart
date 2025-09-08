import 'package:flutter/material.dart';
import '../pokemon_data.dart'; // 1. import model เข้ามา

class Detail extends StatelessWidget {
  // 2. ประกาศตัวแปรเพื่อรับข้อมูลโปเกมอน
  final PokemonData pokemon;

  // 3. เพิ่ม pokemon เข้าไปใน constructor และกำหนดให้เป็น required
  const Detail({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 4. นำชื่อโปเกมอนที่ได้รับมาแสดงเป็น Title
        title: Text(pokemon.name),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'logoHero',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 5. นำ URL รูปภาพที่ได้รับมาแสดงผล
                Image.asset(
                  pokemon.imageUrl,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  'นี่คือ ${pokemon.name}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}