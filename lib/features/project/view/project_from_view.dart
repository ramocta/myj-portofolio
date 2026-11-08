import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controller/project_controller.dart';
import '../widget/custom_textfield.dart';
import '../widget/custom_dropdown.dart';
import '../widget/custom_button.dart';

class ProjectFormView extends StatelessWidget {
  const ProjectFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Memanggil controller yang sudah ada dari halaman sebelumnya
    final ProjectController projectCtrl = Get.find<ProjectController>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            projectCtrl.clearForm(); // Bersihkan form saat kembali
            context.pop();
          },
        ),
        title: Obx(
          () => Text(
            projectCtrl.editingProjectId.value == null
                ? 'Tambah Project'
                : 'Edit Project',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Area Upload Gambar (Mendukung Web, Mobile, dan Gambar Lama di Mode Edit)
              GestureDetector(
                onTap: () => projectCtrl.pickImage(),
                child: Obx(() {
                  // 1. Jika user memilih gambar baru
                  if (projectCtrl.selectedImage.value != null) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: kIsWeb
                            ? Image.network(
                                projectCtrl.selectedImage.value!.path,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Image.file(
                                File(projectCtrl.selectedImage.value!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                      ),
                    );
                  }
                  // 2. Jika sedang mode Edit dan belum ganti gambar, tampilkan gambar lama dari server
                  else if (projectCtrl.existingImageUrl.value != null &&
                      projectCtrl.existingImageUrl.value!.isNotEmpty) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          'http://127.0.0.1:8000/storage/${projectCtrl.existingImageUrl.value}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white24,
                                  size: 40,
                                ),
                              ),
                        ),
                      ),
                    );
                  }
                  // 3. Tampilan awal jika kosong
                  else {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white24,
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.image_outlined,
                            color: Colors.white54,
                            size: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Upload Gambar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pilih gambar dari galeri atau kamera',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ),
              const SizedBox(height: 24),

              // Form Input
              const Text(
                'Nama Project',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Masukkan nama project',
                prefixIcon: Icons.edit_note,
                controller: projectCtrl.formNamaCtrl,
              ),

              const SizedBox(height: 16),
              const Text(
                'Kategori',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Obx(
                () => CustomDropdown<int>(
                  hintText: 'Pilih kategori',
                  prefixIcon: Icons.category_outlined,
                  value: projectCtrl.selectedKategori.value,
                  items: projectCtrl.listKategori.map((item) {
                    return DropdownMenuItem(
                      value: item.idKategori,
                      child: Text(item.namaKategori),
                    );
                  }).toList(),
                  onChanged: (val) => projectCtrl.selectedKategori.value = val,
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                'Tahun',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Masukkan tahun',
                prefixIcon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                controller: projectCtrl.formTahunCtrl,
              ),

              const SizedBox(height: 16),
              const Text(
                'Deskripsi',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: 'Jelaskan project Anda secara singkat...',
                prefixIcon: Icons.description_outlined,
                controller: projectCtrl.formDeskripsiCtrl,
              ),

              const SizedBox(height: 16),
              const Text(
                'Teknologi',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Obx(
                () => CustomDropdown<int>(
                  hintText: 'Pilih teknologi',
                  prefixIcon: Icons.code,
                  value: projectCtrl.selectedTeknologi.value,
                  items: projectCtrl.listTeknologi.map((item) {
                    return DropdownMenuItem(
                      value: item.idTeknologi,
                      child: Text(item.namaTeknologi),
                    );
                  }).toList(),
                  onChanged: (val) => projectCtrl.selectedTeknologi.value = val,
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Simpan
              Obx(
                () => CustomButton(
                  text: 'Simpan',
                  isLoading: projectCtrl.isSubmitting.value,
                  onPressed: () async {
                    bool isSuccess = await projectCtrl.submitProject();
                    if (isSuccess && context.mounted) {
                      context.pop(); // Kembali ke halaman list
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
