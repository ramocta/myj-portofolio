import 'package:flutter/material.dart';
import '../models/project_model.dart';

class PortfolioController extends ChangeNotifier {

  final PageController pageController = PageController();

  int _currentPage = 0;
  int get currentPage => _currentPage;

  final List<String> technologies = [
    'Flutter',
    'Laravel',
    'React',
    'Python',
    'Java',
    'PHP',
  ];

  String? _selectedTech = 'Flutter';
  String? get selectedTech => _selectedTech;

  List<ProjectModel> get projects => projectList;

  void selectTechnology(String tech) {
    _selectedTech = tech;
    notifyListeners(); 
  }

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < projects.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}