import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <--- ตรวจสอบบรรทัดนี้ให้ถูกต้อง
import 'package:anima/controllers/team_controller.dart';
import 'package:anima/models/pokemon_team_model.dart';
import 'package:anima/models/pokemon_model.dart';
import 'team_detail_view.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final TeamController controller = Get.put(TeamController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Team Builder'),
        actions: [
          Obx(() => controller.activeEditingTeamId.value != null
              ? IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  tooltip: 'เสร็จสิ้นการแก้ไข',
                  onPressed: () => controller.selectTeamForEditing(null),
                )
              : Container()),
        ],
      ),
      body: Column(
        children: [
          _buildTeamListSection(),
          const Divider(thickness: 2),
          Obx(() => controller.activeEditingTeamId.value != null
              ? Expanded(
                  child: Column(
                    children: [
                      _buildSearchBar(),
                      _buildPokemonGrid(),
                    ],
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Text(
                      'กด "สร้างทีม" หรือ "แก้ไข" เพื่อเริ่มจัดทีมของคุณ',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createNewTeam,
        icon: const Icon(Icons.add),
        label: const Text("สร้างทีม"),
      ),
    );
  }

  // ส่วนแสดงรายการทีมทั้งหมด
  Widget _buildTeamListSection() {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(
        () => controller.teams.isEmpty
            ? const Center(child: Text('ยังไม่มีทีม... ลองสร้างทีมใหม่ดูสิ!'))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.teams.length,
                itemBuilder: (context, index) {
                  final team = controller.teams[index];
                  final isEditing = controller.activeEditingTeamId.value == team.id;
                  return _buildTeamCard(team, isEditing);
                },
              ),
      ),
    );
  }

  // การ์ดแสดงข้อมูลของแต่ละทีม
  Widget _buildTeamCard(PokemonTeam team, bool isEditing) {
    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: isEditing ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEditing ? Colors.blueAccent : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 4, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    team.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'view_details') {
                      Get.to(() => TeamDetailView(team: team));
                    } else if (value == 'edit_name') {
                      _showEditNameDialog(team);
                    } else if (value == 'delete') {
                      controller.deleteTeam(team.id);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'view_details',
                      child: ListTile(
                        leading: Icon(Icons.visibility),
                        title: Text('ดูรายละเอียด'),
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem<String>(
                      value: 'edit_name',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('แก้ไขชื่อ'),
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('ลบทีม', style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(controller.maxMembersPerTeam, (index) {
                if (index < team.members.length) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(team.members[index].imageUrl),
                    backgroundColor: Colors.transparent,
                  );
                }
                return CircleAvatar(backgroundColor: Colors.grey.shade200);
              }),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              icon: Icon(isEditing ? Icons.edit_off : Icons.edit),
              label: Text(isEditing ? 'กำลังแก้ไข' : 'แก้ไขทีม'),
              onPressed: () => controller.selectTeamForEditing(isEditing ? null : team.id),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isEditing ? Colors.blueAccent : Colors.grey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog สำหรับแก้ไขชื่อทีม
  void _showEditNameDialog(PokemonTeam team) {
    final textController = TextEditingController(text: team.name);
    Get.defaultDialog(
      title: "แก้ไขชื่อทีม",
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: const InputDecoration(labelText: "ชื่อทีมใหม่"),
      ),
      textConfirm: "บันทึก",
      textCancel: "ยกเลิก",
      onConfirm: () {
        if (textController.text.isNotEmpty) {
          controller.updateTeamName(team.id, textController.text);
          Get.back();
        }
      },
    );
  }

  // Widget ช่องค้นหา
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          labelText: 'ค้นหาโปเกมอนเพื่อเพิ่มเข้าทีม',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // Widget ตารางโปเกมอน
  Widget _buildPokemonGrid() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemCount: controller.filteredPokemon.length,
          itemBuilder: (context, index) {
            final pokemon = controller.filteredPokemon[index];
            final isSelected = controller.activeTeam?.members.any((p) => p.name == pokemon.name) ?? false;

            return GestureDetector(
              onTap: () => controller.togglePokemonInActiveTeam(pokemon),
              child: Opacity(
                opacity: isSelected ? 1.0 : 0.6,
                child: Card(
                  color: isSelected ? Colors.green.shade100 : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Image.network(pokemon.imageUrl, fit: BoxFit.contain)),
                      Text(pokemon.name, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}