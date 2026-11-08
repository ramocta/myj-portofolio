import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/api_config.dart';
import '../../home/models/project_models.dart';

class ProjectService {
  final Dio _dio = Dio();

  // Helper untuk mendapatkan token autentikasi
  Future<Options> _getAuthOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return Options(
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  // GET ALL PROJECTS
  Future<List<ProjectModel>> fetchAllProjects() async {
    try {
      final response = await _dio.get(
        '${ApiConfig.baseUrl}/projects',
        options:
            await _getAuthOptions(), // Hapus options ini jika endpoint publik
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

  // GET Kategori
  Future<List<KategoriModel>> fetchKategori() async {
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}/kategori');
      List data = response.data['data'];
      return data.map((e) => KategoriModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal memuat kategori: $e');
    }
  }

  // GET Teknologi
  Future<List<TeknologiModel>> fetchTeknologi() async {
    try {
      final response = await _dio.get('${ApiConfig.baseUrl}/teknologi');
      List data = response.data['data'];
      return data.map((e) => TeknologiModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Gagal memuat teknologi: $e');
    }
  }

  // CREATE / UPDATE Project
  Future<bool> saveProject(FormData formData, {int? idProject}) async {
    try {
      String url = idProject != null
          ? '${ApiConfig.baseUrl}/projects/$idProject'
          : '${ApiConfig.baseUrl}/projects';

      final response = await _dio.post(
        url,
        data: formData,
        options: await _getAuthOptions(),
      );

      print('saveProject STATUS: ${response.statusCode}');
      print('saveProject BODY: ${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error saveProject: $e');
      throw Exception('Gagal menyimpan project: $e');
    }
  }

  // DELETE Project
  Future<bool> deleteProject(int idProject) async {
    try {
      final response = await _dio.delete(
        '${ApiConfig.baseUrl}/projects/$idProject',
        options: await _getAuthOptions(),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Gagal menghapus project: $e');
    }
  }
}
