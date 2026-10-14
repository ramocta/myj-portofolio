import 'jurusan_models.dart';
import 'prodi_models.dart';

class UserModel {
  final int idUser;
  final String nama;
  final String nim;
  final int angkatan;
  final String username;
  // Password biasanya tidak disertakan karena dari backend disembunyikan (hidden)
  final String? imageProfil; // Nullable karena bisa kosong
  final String? deskripsi; // Nullable karena bisa kosong
  final int idJurusan;
  final int idProdi;

  // Relasi (Nullable karena saat login mungkin tidak di-load, tapi saat get profile di-load)
  final JurusanModel? jurusan;
  final ProdiModel? prodi;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.nim,
    required this.angkatan,
    required this.username,
    this.imageProfil,
    this.deskripsi,
    required this.idJurusan,
    required this.idProdi,
    this.jurusan,
    this.prodi,
  });

  // Fungsi untuk mengubah JSON dari API Laravel menjadi Object Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] ?? 0,
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      // Parsing aman untuk angka (angkatan kadang dibaca sebagai String oleh API)
      angkatan: int.tryParse(json['angkatan'].toString()) ?? 0,
      username: json['username'] ?? '',
      imageProfil: json['image_profil'],
      deskripsi: json['deskripsi'],
      idJurusan: int.tryParse(json['id_jurusan'].toString()) ?? 0,
      idProdi: int.tryParse(json['id_prodi'].toString()) ?? 0,

      // Mengubah objek bersarang (nested JSON) menjadi model relasi
      jurusan: json['jurusan'] != null
          ? JurusanModel.fromJson(json['jurusan'])
          : null,
      prodi: json['prodi'] != null ? ProdiModel.fromJson(json['prodi']) : null,
    );
  }

  // Fungsi untuk mengubah Object Dart menjadi JSON (misal untuk disimpan ke Local Storage)
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nama': nama,
      'nim': nim,
      'angkatan': angkatan,
      'username': username,
      'image_profil': imageProfil,
      'deskripsi': deskripsi,
      'id_jurusan': idJurusan,
      'id_prodi': idProdi,
      if (jurusan != null) 'jurusan': jurusan!.toJson(),
      if (prodi != null) 'prodi': prodi!.toJson(),
    };
  }
}
