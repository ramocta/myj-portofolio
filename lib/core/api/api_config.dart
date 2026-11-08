import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static const String login = '/login';
  static const String register = '/register';

  static const String jurusan = '/jurusan';
  static const String prodi = '/prodi';

  // ==========================================
  // ENDPOINT TERPROTEKSI (Wajib pakai Bearer Token)
  // ==========================================
  static const String logout = '/logout';
  static const String userProfile = '/profile';
  static const String getUsers = '/users';
  static const String updateProfile = '/profile/update';
  static const String imageProfile = '/profile/image';


  // ==========================================
  // ENDPOINT UNTUK CRUD PROJECT
  // ==========================================

  static const String kategori = '/kategori';
  static const String teknologi = '/teknologi';

  static const String getprojects = '/projects'; //get all
  static const String getproject = '/projects/{id}'; //get by id
  static const String project = '/projects'; //add
  static const String updateproject = '/projects/{id}'; //update
  static const String deleteproject = '/projects/{id}'; //delete 

}
