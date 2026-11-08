import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controller/profile_controller.dart';
import '../../auth/models/user_models.dart';
import '../../auth/widget/custom_textfield.dart';

class ProfileListView extends StatelessWidget {
  const ProfileListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileCtrl = Get.put(ProfileController());
    final searchCtrl = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Mahasiswa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),


            // List Mahasiswa
            Expanded(
              child: Obx(() {
                if (profileCtrl.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  );
                }
                if (profileCtrl.listUsers.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada mahasiswa ditemukan.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: profileCtrl.listUsers.length,
                  itemBuilder: (context, index) {
                    final user = profileCtrl.listUsers[index];
                    return _buildUserCard(context, user, profileCtrl);
                  },
                );
              }),
            ),
          ],
        ),
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

  Widget _buildUserCard(
    BuildContext context,
    UserModel user,
    ProfileController ctrl,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF2C2C2C),
          backgroundImage:
              (user.imageProfil != null && user.imageProfil!.isNotEmpty)
              ? CachedNetworkImageProvider(
                  'http://127.0.0.1:8000/storage/${user.imageProfil}',
                )
              : null,
          child: (user.imageProfil == null || user.imageProfil!.isEmpty)
              ? const Icon(Icons.person, color: Colors.white54)
              : null,
        ),
        title: Text(
          user.nama,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          user.jurusan?.namaJurusan ?? 'Teknik Informatika',
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () {
          ctrl.selectUser(user);
          context.push('/profile/detail'); // Navigasi ke Detail Profil
        },
      ),
    );
  }
}
