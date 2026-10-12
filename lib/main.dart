import 'package:flutter/material.dart';
import '../controller/page_controller.dart';
import '../widget/profile_header.dart';
import '../widget/portofolio_sections.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const PortfolioScreen(),
    );
  }
}

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  late final PortfolioController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PortfolioController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(
                  technologies: _controller.technologies,
                  selectedTech: _controller.selectedTech,
                  onTechSelected: (tech) {
                    if (tech != null) {
                      _controller.selectTechnology(tech);
                    }
                  },
                ),
                const SizedBox(height: 20),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'My Project',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                PortfolioSection(controller: _controller),
              ],
            ),
          );
        },
      ),
    );
  }
}
