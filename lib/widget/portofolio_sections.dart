import 'package:flutter/material.dart';
import '../controller/page_controller.dart';
import 'project_card.dart';

class PortfolioSection extends StatelessWidget {
  final PortfolioController controller;

  const PortfolioSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    const activeDotColor = Color(0xFF111111);
    const inactiveDotColor = Color.fromARGB(255, 84, 83, 83);

    const buttonBgColor = Color(0xFF111111);
    const buttonTextColor = Colors.white;

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.projects.length,
            itemBuilder: (context, index) {
              return ProjectCard(projectModel: controller.projects[index]);
            },
          ),
        ),

        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            controller.projects.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: controller.currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: controller.currentPage == index
                    ? activeDotColor
                    : inactiveDotColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: controller.currentPage > 0
                    ? controller.previousPage
                    : null,
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Sebelumnya'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  foregroundColor: buttonTextColor,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[500],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              ElevatedButton.icon(
                onPressed:
                    controller.currentPage < controller.projects.length - 1
                    ? controller.nextPage
                    : null,
                label: const Text('Berikutnya'),
                icon: const Icon(Icons.arrow_forward, size: 18),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonBgColor,
                  foregroundColor: buttonTextColor,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[500],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
