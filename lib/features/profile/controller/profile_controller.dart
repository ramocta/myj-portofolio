import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/models/user_models.dart';
import '../../home/models/project_models.dart';
import '../service/profile_services.dart';

class ProfileController extends GetxController {
  final ProfileServices _dataService = ProfileServices();

  var isLoading = false.obs;
  var listUsers = <UserModel>[].obs;
  
  // State untuk Detail Profil (Screen 8)
  var isLoadingDetail = false.obs;
  var selectedUser = Rxn<UserModel>();
  var userProjects = <ProjectModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // Mengambil semua user (untuk Screen 7)
  Future<void> fetchUsers() async {
    isLoading.value = true;
    try {
      listUsers.value = await _dataService.fetchAllUsers();
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  void selectUser(UserModel user) {
    selectedUser.value = user;
    fetchUserProjects(user.idUser);
  }

  // Hanya mengambil project milik user tersebut
  Future<void> fetchUserProjects(int userId) async {
    isLoadingDetail.value = true;
    try {
      List<ProjectModel> allProjects = await _dataService.fetchAllProjects();
      userProjects.value = allProjects.where((p) => p.user?.idUser == userId).toList();
    } catch (e) {
      print("Error detail project: $e");
    } finally {
      isLoadingDetail.value = false;
    }
  }
}