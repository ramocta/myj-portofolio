import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/project_controller.dart';
import '../../home/models/project_models.dart';

class ProjectListView extends StatelessWidget {
  const ProjectListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisiasi Controller
    final ProjectController projectCtrl = Get.put(ProjectController());

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Sesuai Screen 5)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Project Saya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Explore • Connect • Build',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                // Tombol Tambah Project
                GestureDetector(
                  onTap: () => context.push('/project/add'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // // Filter Kategori (Chips)
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 20.0,
          //     vertical: 10.0,
          //   ),
          //   child: Row(
          //     children: [
          //       _buildFilterChip('Semua', true),
          //       _buildFilterChip('Web', false),
          //       _buildFilterChip('Mobile', false),
          //       _buildFilterChip('UI/UX', false),
          //     ],
          //   ),
          // ),

          // Daftar Project
          Expanded(
            child: Obx(() {
              if (projectCtrl.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white54),
                );
              }
              if (projectCtrl.listProjects.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada project.',
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async => projectCtrl.fetchProjects(),
                backgroundColor: const Color(0xFF1E1E1E),
                color: Colors.white,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: projectCtrl.listProjects.length,
                  itemBuilder: (context, index) {
                    return _buildProjectCard(
                      context,
                      projectCtrl,
                      projectCtrl.listProjects[index],
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Tambahkan parameter context dan projectCtrl
  Widget _buildProjectCard(
    BuildContext context,
    ProjectController projectCtrl,
    ProjectModel project,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 60,
              width: 60,
              color: const Color(0xFF2C2C2C),
              child: project.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: project.fullImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.white24),
                    )
                  : const Icon(Icons.image, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (project.teknologi != null)
                      _buildTag(project.teknologi!.namaTeknologi),
                    const SizedBox(width: 4),
                    if (project.kategori != null)
                      _buildTag(project.kategori!.namaKategori),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  project.deskripsi ?? '',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Text(
                  project.tahun.toString(),
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),

          // Ganti chevron_right dengan PopupMenuButton untuk fitur Edit & Hapus
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white54),
            color: const Color(0xFF2C2C2C),
            onSelected: (value) {
              if (value == 'edit') {
                projectCtrl.prepareEdit(project); // Isi form dengan data lama
                context.push('/project/add'); // Buka halaman form
              } else if (value == 'delete') {
                _showDeleteDialog(context, projectCtrl, project.idProject);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Edit', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.redAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showDeleteDialog(BuildContext context, ProjectController ctrl, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Hapus Project?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Apakah Anda yakin ingin menghapus project ini? Data yang dihapus tidak dapat dikembalikan.',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup dialog tanpa hapus
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog terlebih dahulu
              ctrl.deleteProject(id); // Panggil fungsi hapus dari controller
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white54, fontSize: 10),
      ),
    );
  }
}
