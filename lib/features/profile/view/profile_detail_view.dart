import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/profile_controller.dart';
import '../../home/models/project_models.dart';

class ProfileDetailView extends StatelessWidget {
  const ProfileDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileCtrl = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (profileCtrl.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.white54));
        }

        final user = profileCtrl.selectedUser.value;
        if (user == null) {
          return const Center(child: Text('Data profil tidak ditemukan.', style: TextStyle(color: Colors.white54)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Foto Profil Besar
              CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFF2C2C2C),
                backgroundImage: (user.imageProfil != null && user.imageProfil!.isNotEmpty)
                    ? CachedNetworkImageProvider('http://127.0.0.1:8000/storage/${user.imageProfil}')
                    : null,
                child: (user.imageProfil == null || user.imageProfil!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white54, size: 40)
                    : null,
              ),
              const SizedBox(height: 12),
              
              // Nama & Jurusan
              Text(user.nama, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '${user.jurusan?.namaJurusan ?? 'Teknik Informatika'} • Polije',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 20),

              // Tab Bar (Portofolio / Tentang Saya)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Portofolio', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Tentang Saya', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Statistik (Project, Followers, Following)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(profileCtrl.userProjects.length.toString(), 'Project'),
                    _buildStatItem('3', 'Followers'),
                    _buildStatItem('1', 'Following'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section List Portofolio Terbaru Mahasiswa Ini
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Portofolio Terbaru', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Lihat Semua >', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),

              // Daftar Project Milik User
              profileCtrl.userProjects.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Mahasiswa ini belum mengunggah project.', style: TextStyle(color: Colors.white54)),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileCtrl.userProjects.length,
                      itemBuilder: (context, index) {
                        return _buildProjectCard(profileCtrl.userProjects[index]);
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 60,
              width: 60,
              color: const Color(0xFF2C2C2C),
              child: project.imageUrl != null
                  ? CachedNetworkImage(imageUrl: project.fullImageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.image, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.nama, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(project.tahun.toString(), style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}