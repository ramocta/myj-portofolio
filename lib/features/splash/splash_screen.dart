import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portofolio/core/shared/app_colors.dart';
import 'package:my_portofolio/core/shared/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Logika untuk pindah ke halaman Login setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Center(
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Image.asset(
            AppAssets.logo,
            width: 400,
            height: 400,
          ),
          const SizedBox(height: 20),
        ],
        ),
      ),
    );
  }
}