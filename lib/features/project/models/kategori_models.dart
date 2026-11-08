class KategoriModel {
  final int idKategori;
  final String namaKategori;

  KategoriModel({
    required this.idKategori,
    required this.namaKategori,
  });

  // Mengubah JSON dari backend menjadi Object Dart
  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      // Menggunakan tryParse agar aman jika API mengirimkan angka dalam bentuk String
      idKategori: int.tryParse(json['id_kategori'].toString()) ?? 0, 
      namaKategori: json['nama_kategori'] ?? '',
    );
  }

  // Mengubah Object Dart kembali menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_kategori': namaKategori,
    };
  }
}