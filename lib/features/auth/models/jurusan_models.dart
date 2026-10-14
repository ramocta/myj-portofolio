class JurusanModel {
  final int idJurusan;
  final String namaJurusan;

  JurusanModel({
    required this.idJurusan,
    required this.namaJurusan,
  });

  factory JurusanModel.fromJson(Map<String, dynamic> json) {
    return JurusanModel(
      idJurusan: json['id_jurusan'] ?? 0,
      namaJurusan: json['nama_jurusan'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jurusan': idJurusan,
      'nama_jurusan': namaJurusan,
    };
  }
}