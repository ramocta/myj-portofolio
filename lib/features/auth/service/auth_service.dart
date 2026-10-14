import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_models.dart'; // Sesuaikan path import dengan model Anda
import '../../../core/api/api_config.dart';

class AuthService {
  final Dio _dio = Dio();

  // ==========================================
  // 1. FUNGSI LOGIN
  // ==========================================
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/login',
        data: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      // Jika sukses (Status 200)
      if (response.statusCode == 200) {
        final responseData = response.data;
        
        // Ambil token dan simpan ke Shared Preferences
        final String token = responseData['access_token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', token);

        // Ubah data user (JSON) menjadi objek UserModel
        return UserModel.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal login: Respons tidak dikenal');
      }
    } on DioException catch (e) {
      // Menangani error dari backend (misal: 401 Unauthorized, 422 Validation Error)
      if (e.response != null) {
        final errorData = e.response?.data;
        throw Exception(errorData['message'] ?? 'Username atau Password salah');
      } else {
        throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
      }
    }
  }

  // ==========================================
  // 2. FUNGSI REGISTER
  // ==========================================
  Future<bool> register({
    required String nama,
    required String nim,
    required int angkatan,
    required String username,
    required String password,
    required int idJurusan,
    required int idProdi,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/register',
        data: {
          'nama': nama,
          'nim': nim,
          'angkatan': angkatan,
          'username': username,
          'password': password,
          'id_jurusan': idJurusan,
          'id_prodi': idProdi,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      // Jika berhasil (Status 201 Created)
      if (response.statusCode == 201) {
        return true; 
      } else {
        throw Exception('Gagal melakukan registrasi');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 422) {
        // Mengambil pesan error validasi spesifik dari backend Laravel
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        // Mengambil error pertama yang muncul untuk ditampilkan ke user
        final firstError = errors.values.first[0]; 
        throw Exception(firstError);
      } else {
        throw Exception('Terjadi kesalahan pada server atau jaringan.');
      }
    }
  }

  // ==========================================
  // 3. FUNGSI LOGOUT (Hapus Token)
  // ==========================================
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // Memberitahu server untuk menghapus token (opsional tapi disarankan)
      if (token != null) {
        await _dio.post(
          '${ApiConfig.baseUrl}/logout',
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
        );
      }
    } catch (e) {
      print('Logout API gagal, melanjutkan hapus token lokal: $e');
    } finally {
      // Wajib: Hapus token dari memori HP
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
    }
  }
}