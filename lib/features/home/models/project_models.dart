import '../../auth/models/user_models.dart';

class KategoriModel {
  final int idKategori;
  final String namaKategori;

  KategoriModel({required this.idKategori, required this.namaKategori});

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'] ?? 0,
      namaKategori: json['nama_kategori'] ?? '',
    );
  }
}

class TeknologiModel {
  final int idTeknologi;
  final String namaTeknologi;

  TeknologiModel({required this.idTeknologi, required this.namaTeknologi});

  factory TeknologiModel.fromJson(Map<String, dynamic> json) {
    return TeknologiModel(
      idTeknologi: json['id_teknologi'] ?? 0,
      namaTeknologi: json['nama_teknologi'] ?? '',
    );
  }
}

class ProjectModel {
  final int idProject;
  final String nama;
  final int tahun;
  final String? deskripsi;
  final String? imageUrl;
  final UserModel? user;
  final TeknologiModel? teknologi;
  final KategoriModel? kategori;

  ProjectModel({
    required this.idProject,
    required this.nama,
    required this.tahun,
    this.deskripsi,
    this.imageUrl,
    this.user,
    this.teknologi,
    this.kategori,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      idProject: json['id_project'] ?? 0,
      nama: json['nama'] ?? '',
      tahun: int.tryParse(json['tahun'].toString()) ?? 0,
      deskripsi: json['deskripsi'],
      imageUrl: json['image_url'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      teknologi: json['teknologi'] != null
          ? TeknologiModel.fromJson(json['teknologi'])
          : null,
      kategori: json['kategori'] != null
          ? KategoriModel.fromJson(json['kategori'])
          : null,
    );
  }

  // Fungsi bantuan untuk mendapatkan URL gambar lengkap
  String get fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return '';
    // Sesuaikan IP dengan config Anda (10.0.2.2 untuk emulator, 127.0.0.1 untuk web)
    return 'http://127.0.0.1:8000/storage/$imageUrl';
  }
}
