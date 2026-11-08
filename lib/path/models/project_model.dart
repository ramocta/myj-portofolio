class ProjectModel {
  final String title;
  final String year;
  final String technology;
  final String description;
  final String image;

  ProjectModel({
    required this.title,
    required this.year,
    required this.technology,
    required this.description,
    required this.image,
  });
}

List<ProjectModel> projectList = [
  ProjectModel(
    title: 'Pesblak Website',
    year: '2025',
    technology: 'PHP . MySql',
    description: 'Website informasi UMKM Seblak Say Cafe yang menyediakan informasi menu, serta pemesanan.',
    image: 'assets/image/poster.png',
  ),

  ProjectModel(
    title: 'Pesblak Applications',
    year: '2026',
    technology: 'Flutter . Dart',
    description: 'Aplikasi Pemesanan untuk UMKM Seblak Say Cafe dengan fitur menu, topping, dan pembayaran digital.',
    image: 'assets/image/poster.png',
  ),

  ProjectModel(
    title: 'JTI Port Poster',
    year: '2026',
    technology: 'UI/UX',
    description: 'Desain UI/UX untuk platform pembelajaran online JTI Port',
    image: 'assets/image/poster3.jpeg',
  ),
];
