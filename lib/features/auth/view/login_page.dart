import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_portofolio/core/shared/app_assets.dart';
import 'package:go_router/go_router.dart';
import '../controller/auth_controller.dart';
import '../widget/custom_textfield.dart';
import '../widget/custom_button.dart';

class LoginView extends StatelessWidget {
  final AuthController authCtrl = Get.put(AuthController());

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Background gelap
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppAssets.logo, width: 200, height: 200),
              const SizedBox(height: 20),
              const Text(
                'Masuk untuk melanjutkan',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Form Input
              CustomTextField(
                hintText: 'Username',
                prefixIcon: Icons.person_outline,
                controller: authCtrl.loginUsernameCtrl,
              ),
              CustomTextField(
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: authCtrl.loginPasswordCtrl,
              ),
              const SizedBox(height: 24),

              // Tombol Login
              Obx(
                () => CustomButton(
                  text: 'Masuk',
                  isLoading: authCtrl.isLoading.value,
                  onPressed: () async {
                    // Tunggu proses login selesai
                    bool isSuccess = await authCtrl.login();

                    // Jika sukses dan context masih aktif, pindah halaman
                    if (isSuccess && context.mounted) {
                      context.go('/main'); // Buka komentar ini nanti
                    }
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Teks Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(color: Colors.white54),
                  ),
                  GestureDetector(
                    // Pindah ke halaman register menggunakan GoRouter
                    onTap: () => context.push('/register'),
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
