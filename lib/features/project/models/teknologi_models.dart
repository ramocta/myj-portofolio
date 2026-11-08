class TeknologiModel {
  final int idTeknologi;
  final String namaTeknologi;

  TeknologiModel({
    required this.idTeknologi,
    required this.namaTeknologi,
  });

  factory TeknologiModel.fromJson(Map<String, dynamic> json) {
    return TeknologiModel(
      idTeknologi: int.tryParse(json['id_teknologi'].toString()) ?? 0,
      namaTeknologi: json['nama_teknologi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_teknologi': idTeknologi,
      'nama_teknologi': namaTeknologi,
    };
  }
}