import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/jurusan_models.dart';
import '../models/prodi_models.dart';
import '../../../core/api/api_config.dart';
import '../service/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final Dio _dio = Dio(); // Untuk get jurusan & prodi

  // Controllers untuk TextFields
  final loginUsernameCtrl = TextEditingController();
  final loginPasswordCtrl = TextEditingController();

  final regNamaCtrl = TextEditingController();
  final regNimCtrl = TextEditingController();
  final regAngkatanCtrl = TextEditingController();
  final regUsernameCtrl = TextEditingController();
  final regPasswordCtrl = TextEditingController();

  var isLoading = false.obs;

  // State untuk Dropdowns
  var listJurusan = <JurusanModel>[].obs;
  var listProdi = <ProdiModel>[].obs;

  var selectedJurusan = Rxn<int>();
  var selectedProdi = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    // Panggil data saat controller diinisialisasi
    fetchJurusanAndProdi();
  }

  Future<void> fetchJurusanAndProdi() async {
    try {
      final resJurusan = await _dio.get('${ApiConfig.baseUrl}/jurusan');
      final resProdi = await _dio.get('${ApiConfig.baseUrl}/prodi');

      if (resJurusan.statusCode == 200) {
        final List data = resJurusan.data['data'];
        listJurusan.value = data.map((e) => JurusanModel.fromJson(e)).toList();
      }
      if (resProdi.statusCode == 200) {
        final List data = resProdi.data['data'];
        listProdi.value = data.map((e) => ProdiModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Gagal mengambil data master: $e");
    }
  }

  Future<bool> login() async {
    if (loginUsernameCtrl.text.isEmpty || loginPasswordCtrl.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan Password harus diisi!',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return false;
    }

    isLoading.value = true;
    try {
      await _authService.login(
        username: loginUsernameCtrl.text.trim(),
        password: loginPasswordCtrl.text,
      );
      Get.snackbar(
        'Sukses',
        'Berhasil Login!',
        backgroundColor: const Color(0xFF43A047),
        colorText: const Color(0xFFFFFFFF),
      );

      return true; // Berhasil login
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Ubah menjadi Future<bool>
  Future<bool> register() async {
    if (selectedJurusan.value == null || selectedProdi.value == null) {
      Get.snackbar(
        'Error',
        'Pilih Jurusan dan Prodi!',
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return false;
    }

    isLoading.value = true;
    try {
      bool success = await _authService.register(
        nama: regNamaCtrl.text,
        nim: regNimCtrl.text,
        angkatan: int.tryParse(regAngkatanCtrl.text) ?? 0,
        username: regUsernameCtrl.text,
        password: regPasswordCtrl.text,
        idJurusan: selectedJurusan.value!,
        idProdi: selectedProdi.value!,
      );

      if (success) {
        regNamaCtrl.clear();
        regNimCtrl.clear();
        regAngkatanCtrl.clear();
        regUsernameCtrl.clear();
        regPasswordCtrl.clear();
        selectedJurusan.value = null;
        selectedProdi.value = null;

        Get.snackbar(
          'Sukses',
          'Registrasi berhasil, silakan masuk.',
          backgroundColor: const Color(0xFF43A047),
          colorText: const Color(0xFFFFFFFF),
        );
        return true; // Berhasil registrasi
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Gagal Registrasi',
        e.toString(),
        backgroundColor: const Color(0xFFE53935),
        colorText: const Color(0xFFFFFFFF),
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}