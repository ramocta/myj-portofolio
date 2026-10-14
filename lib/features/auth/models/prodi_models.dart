class ProdiModel {
  final int idProdi;
  final String namaProdi;

  ProdiModel({
    required this.idProdi,
    required this.namaProdi,
  });

  factory ProdiModel.fromJson(Map<String, dynamic> json) {
    return ProdiModel(
      idProdi: json['id_prodi'] ?? 0,
      namaProdi: json['nama_prodi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_prodi': idProdi,
      'nama_prodi': namaProdi,
    };
  }
}