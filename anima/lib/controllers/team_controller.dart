// lib/controllers/team_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:anima/models/pokemon_model.dart'; // แก้ไข path
import 'package:anima/models/pokemon_team_model.dart'; // แก้ไข path

class TeamController extends GetxController {
  // ... (เนื้อหาของคลาสไม่ต้องเปลี่ยนแปลง) ...
  // --- State Variables ---
  var allPokemon = <Pokemon>[].obs;
  var filteredPokemon = <Pokemon>[].obs;
  var isLoading = true.obs;

  var teams = <PokemonTeam>[].obs; // เปลี่ยนเป็น List ของทีม
  var activeEditingTeamId = Rx<int?>(null); // ID ของทีมที่กำลังแก้ไขอยู่

  final _storage = GetStorage();
  final searchController = TextEditingController();
  final int maxMembersPerTeam = 3; // กำหนดจำนวนสมาชิกสูงสุดต่อทีม

  // --- Computed Properties ---
  // ดึงข้อมูลทีมที่กำลังแก้ไขอยู่
  PokemonTeam? get activeTeam => teams.firstWhereOrNull((t) => t.id == activeEditingTeamId.value);

  @override
  void onInit() {
    super.onInit();
    loadData();
    searchController.addListener(() {
      filterPokemon(searchController.text);
    });
  }

  // --- Data Loading & Persistence ---
  Future<void> loadData() async {
    // 1. โหลดทีมทั้งหมดที่บันทึกไว้
    List<dynamic>? savedTeams = _storage.read<List>('teams');
    if (savedTeams != null) {
      teams.value = savedTeams.map((item) => PokemonTeam.fromJson(item)).toList();
    }

    // 2. ดึงข้อมูลโปเกมอน (ทำครั้งเดียว)
    if (allPokemon.isEmpty) {
      await fetchPokemon();
    }
  }

  void _saveTeams() {
    _storage.write('teams', teams.map((team) => team.toJson()).toList());
  }

  // --- Team Management Methods ---
  void createNewTeam() {
    // สร้าง ID ที่ไม่ซ้ำกันโดยใช้ timestamp
    final newTeamId = DateTime.now().millisecondsSinceEpoch;
    final newTeam = PokemonTeam(
      name: 'ทีม ${teams.length + 1}',
      members: [],
      id: newTeamId,
    );
    teams.add(newTeam);
    selectTeamForEditing(newTeamId);
    _saveTeams();
  }

  void deleteTeam(int teamId) {
    // ถ้าทีมที่กำลังแก้ไขถูกลบ ให้ยกเลิกการแก้ไข
    if (activeEditingTeamId.value == teamId) {
      activeEditingTeamId.value = null;
    }
    teams.removeWhere((team) => team.id == teamId);
    Get.snackbar('สำเร็จ', 'ลบทีมเรียบร้อยแล้ว');
    _saveTeams();
  }

  void updateTeamName(int teamId, String newName) {
    final teamIndex = teams.indexWhere((t) => t.id == teamId);
    if (teamIndex != -1) {
      teams[teamIndex].name = newName;
      teams.refresh(); // บังคับให้ UI อัปเดต
      _saveTeams();
    }
  }

  void selectTeamForEditing(int? teamId) {
    activeEditingTeamId.value = teamId;
  }

  // --- Pokémon Management in Active Team ---
  void togglePokemonInActiveTeam(Pokemon pokemon) {
    if (activeTeam == null) {
      Get.snackbar('ข้อผิดพลาด', 'กรุณาเลือกทีมที่ต้องการแก้ไขก่อน');
      return;
    }

    final isAlreadyInTeam = activeTeam!.members.any((p) => p.name == pokemon.name);

    if (isAlreadyInTeam) {
      // ถ้ามีอยู่แล้ว ให้ลบออก
      activeTeam!.members.removeWhere((p) => p.name == pokemon.name);
    } else {
      // ถ้ายังไม่มี ให้เพิ่มเข้าไป (ถ้าทีมยังไม่เต็ม)
      if (activeTeam!.members.length < maxMembersPerTeam) {
        activeTeam!.members.add(pokemon);
      } else {
        Get.snackbar('ทีมเต็มแล้ว', 'ทีมของคุณมีสมาชิกได้สูงสุด $maxMembersPerTeam ตัว');
      }
    }
    teams.refresh(); // สำคัญมาก! เพื่อให้ Obx ทำงานเมื่อข้อมูลใน List เปลี่ยน
    _saveTeams();
  }

  // --- Utility Methods ---
  Future<void> fetchPokemon() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = (data['results'] as List).asMap().entries;
        allPokemon.assignAll(results.map((entry) => Pokemon(
              name: entry.value['name'],
              imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${entry.key + 1}.png',
            )));
        filteredPokemon.assignAll(allPokemon);
      }
    } finally {
      isLoading(false);
    }
  }

  void filterPokemon(String query) {
    filteredPokemon.value = query.isEmpty
        ? allPokemon
        : allPokemon.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}