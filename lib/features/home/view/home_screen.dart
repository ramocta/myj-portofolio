import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:my_portofolio/core/shared/app_assets.dart';
import '../controller/home_controller.dart';
import '../widget/custom_textfield.dart';
import '../../auth/models/user_models.dart';
import '../models/project_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final HomeController homeCtrl = Get.put(HomeController());
    final searchCtrl = TextEditingController();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => homeCtrl.loadHomeData(), // Pull to refresh
        backgroundColor: const Color(0xFF1E1E1E),
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil Dinamis
              Obx(() {
                if (homeCtrl.isLoadingProfile.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  );
                }
                final user = homeCtrl.currentUser.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, ${user?.nama ?? 'Mahasiswa'}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.jurusan?.namaJurusan ?? 'Myj Portofolio',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Foto Profil (Jika ada)
                    CircleAvatar(
                      backgroundColor: const Color(0xFF2C2C2C),
                      backgroundImage:
                          (user?.imageProfil != null &&
                              user!.imageProfil!.isNotEmpty)
                          ? CachedNetworkImageProvider(
                              'http://127.0.0.1:8000/storage/${user.imageProfil}',
                            )
                          : null,
                      child:
                          (user?.imageProfil == null ||
                              user!.imageProfil!.isEmpty)
                          ? const Icon(Icons.person, color: Colors.white54)
                          : null,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Search Bar
              CustomTextField(
                hintText: 'Cari mahasiswa, project, atau nama...',
                prefixIcon: Icons.search,
                controller: searchCtrl,
              ),

              // Banner Hero (Statis)
              _buildHeroBanner(),
              const SizedBox(height: 24),

              _buildSectionTitle('Daftar Mahasiswa', 'Lihat Semua >'),
              const SizedBox(height: 12),

              // List Horizontal User (Mahasiswa) Dinamis
              Obx(() {
                if (homeCtrl.isLoadingUsers.value) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white54),
                    ),
                  );
                }

                if (homeCtrl.listUsers.isEmpty) {
                  return const SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        'Belum ada mahasiswa.',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeCtrl.listUsers.length,
                    itemBuilder: (context, index) {
                      return _buildStudentCard(homeCtrl.listUsers[index]);
                    },
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Section Proyek Terbaru Dinamis
              _buildSectionTitle('Proyek Terbaru', 'Lihat Semua >'),
              const SizedBox(height: 12),

              // List Project
              Obx(() {
                if (homeCtrl.isLoadingProjects.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.white54),
                    ),
                  );
                }

                if (homeCtrl.listProjects.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada project.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeCtrl.listProjects.length > 5
                      ? 5
                      : homeCtrl
                            .listProjects
                            .length, // Tampilkan maks 5 di beranda
                  itemBuilder: (context, index) {
                    return _buildProjectCard(homeCtrl.listProjects[index]);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN ---

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.banner,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 12),
          const Text(
            'Politeknik Negeri Jember',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Polije adalah kampus vokasi yang mencetak lulusan unggul, profesional, dan siap bersaing di dunia kerja.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          actionText,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  // Desain Card Mahasiswa (User) Dinamis
  Widget _buildStudentCard(UserModel user) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          // Foto Profil
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF2C2C2C),
            backgroundImage:
                (user.imageProfil != null && user.imageProfil!.isNotEmpty)
                ? CachedNetworkImageProvider(
                    'http://127.0.0.1:8000/storage/${user.imageProfil}',
                  )
                : null,
            child: (user.imageProfil == null || user.imageProfil!.isEmpty)
                ? const Icon(
                    Icons.person,
                    color: Colors.white54,
                  ) // Icon default jika kosong
                : null,
          ),
          const SizedBox(height: 8),

          // Nama Mahasiswa
          Text(
            user.nama,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Jurusan Mahasiswa
          Text(
            user.jurusan?.namaJurusan ?? '-',
            style: const TextStyle(color: Colors.white54, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Desain Card Project dengan Data Asli
  Widget _buildProjectCard(ProjectModel project) {
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
          // Gambar Project Dinamis
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
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.white24),
                    )
                  : const Icon(Icons.image, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 12),

          // Detail Project Dinamis
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Menampilkan nama pembuat project
                Text(
                  'Oleh: ${project.user?.nama ?? 'Anonim'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
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
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
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
