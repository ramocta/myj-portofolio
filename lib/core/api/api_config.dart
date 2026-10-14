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
}
