import 'pokemon_model.dart';

class PokemonTeam {
  String name;
  List<Pokemon> members;
  final int id; // ใช้ ID ที่ไม่ซ้ำกันเพื่อจัดการทีมได้ง่ายขึ้น

  PokemonTeam({required this.name, required this.members, required this.id});

  // แปลง Object เป็น JSON เพื่อบันทึก
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'members': members.map((pokemon) => pokemon.toJson()).toList(),
    };
  }

  // แปลง JSON กลับเป็น Object
  factory PokemonTeam.fromJson(Map<String, dynamic> json) {
    var memberList = json['members'] as List;
    List<Pokemon> members = memberList.map((i) => Pokemon.fromJson(i)).toList();
    return PokemonTeam(
      name: json['name'],
      id: json['id'],
      members: members,
    );
  }
}