import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_config.dart';
import '../../auth/models/user_models.dart';
import '../models/project_models.dart';

class DataService {
  final Dio _dio = Dio();

  // Helper untuk mendapatkan token dan menyisipkannya ke header
  Future<Options> _getAuthOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return Options(
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  // 1. GET PROFILE (User Login)
  Future<UserModel> fetchProfile() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/profile',
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('Gagal memuat profil');
      }
    } catch (e) {
      throw Exception('Error fetch profile: $e');
    }
  }

  // 2. GET ALL PROJECTS
  Future<List<ProjectModel>> fetchAllProjects() async {
    try {
      // Endpoint /projects kita asumsikan butuh token jika diproteksi,
      // atau gunakan Options biasa jika rute publik.
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/projects', // Pastikan rute ini ada di api.php
        options: await _getAuthOptions(),
      );

      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((json) => ProjectModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat project');
      }
    } catch (e) {
      throw Exception('Error fetch projects: $e');
    }
  }

  // 3. GET ALL USERS (Mahasiswa)
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/users',
        options:
            await _getAuthOptions(), // Pakai ini jika rute di dalam middleware auth
      );

      if (response.statusCode == 200) {
        List data = response.data['data'];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data mahasiswa');
      }
    } catch (e) {
      throw Exception('Error fetch users: $e');
    }
  }
}
