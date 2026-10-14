import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controller/auth_controller.dart';
import '../widget/custom_textfield.dart';
import '../widget/custom_button.dart';
import '../widget/custom_dropdown.dart';

class RegisterView extends StatelessWidget {
  final AuthController authCtrl = Get.find<AuthController>();

  RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 16),
              const Text(
                'Myj Portofolio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Buat akun untuk memulai',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 32),

              // Form Input
              CustomTextField(
                hintText: 'Nama Lengkap',
                prefixIcon: Icons.person_outline,
                controller: authCtrl.regNamaCtrl,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'NIM (e412...)',
                      prefixIcon: Icons.badge_outlined,
                      controller: authCtrl.regNimCtrl,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Angkatan (Tahun)',
                      prefixIcon: Icons.date_range,
                      keyboardType: TextInputType.number,
                      controller: authCtrl.regAngkatanCtrl,
                    ),
                  ),
                ],
              ),
              CustomTextField(
                hintText: 'Username',
                prefixIcon: Icons.alternate_email,
                controller: authCtrl.regUsernameCtrl,
              ),

              // Dropdown Jurusan & Prodi
              Obx(
                () => CustomDropdown<int>(
                  hintText: 'Pilih Jurusan',
                  prefixIcon: Icons.account_balance_outlined,
                  value: authCtrl.selectedJurusan.value,
                  items: authCtrl.listJurusan.map((item) {
                    return DropdownMenuItem(
                      value: item.idJurusan,
                      child: Text(item.namaJurusan),
                    );
                  }).toList(),
                  onChanged: (val) => authCtrl.selectedJurusan.value = val,
                ),
              ),

              Obx(
                () => CustomDropdown<int>(
                  hintText: 'Pilih Program Studi',
                  prefixIcon: Icons.library_books_outlined,
                  value: authCtrl.selectedProdi.value,
                  items: authCtrl.listProdi.map((item) {
                    return DropdownMenuItem(
                      value: item.idProdi,
                      child: Text(item.namaProdi),
                    );
                  }).toList(),
                  onChanged: (val) => authCtrl.selectedProdi.value = val,
                ),
              ),

              CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: authCtrl.regPasswordCtrl,
              ),
              const SizedBox(height: 16),

              // Tombol Daftar
              Obx(
                () => CustomButton(
                  text: 'Daftar',
                  isLoading: authCtrl.isLoading.value,
                  onPressed: () async {
                    // Tunggu proses register di Controller selesai
                    bool isSuccess = await authCtrl.register();

                    // Jika registrasi berhasil, otomatis kembali ke halaman Login
                    if (isSuccess && context.mounted) {
                      context.pop();
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Teks Kembali ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(color: Colors.white54),
                  ),
                  GestureDetector(
                    // Gunakan pop() agar tidak menumpuk history halaman
                    onTap: () => context.pop(),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
