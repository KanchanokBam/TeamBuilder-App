class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  // Factory constructor สำหรับแปลง JSON เป็น Object
  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  // Method สำหรับแปลง Object เป็น JSON เพื่อบันทึกลง Storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}