import 'package:flutter/material.dart';
import 'package:anima/models/pokemon_team_model.dart';

class TeamDetailView extends StatelessWidget {
  // ประกาศตัวแปรเพื่อรับข้อมูลทีม
  final PokemonTeam team;

  // กำหนดให้ต้องส่งข้อมูลทีมเข้ามาตอนสร้าง Widget นี้
  const TeamDetailView({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // แสดงชื่อทีมที่ได้รับมา
        title: Text("ทีม: ${team.name}"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: team.members.isEmpty
            ? const Center(
                child: Text(
                  'ทีมนี้ยังไม่มีสมาชิก',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // แสดง 2 คอลัมน์
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: team.members.length,
                itemBuilder: (context, index) {
                  final pokemon = team.members[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              pokemon.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            pokemon.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}