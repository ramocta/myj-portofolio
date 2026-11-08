import 'package:flutter/material.dart';
import '../widget/bottom,_navbar.dart';
import 'home_screen.dart';
import '../../project/view/project_list_view.dart';
import '../../profile/view/profile_list_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai urutan tab
  final List<Widget> _pages = [
    const HomeView(),
    const ProjectListView(),
    const ProfileListView(),
    const Center(
      child: Text(
        'Halaman Profil (Segera Hadir)',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const Center(
      child: Text(
        'Halaman Pengaturan (Segera Hadir)',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
