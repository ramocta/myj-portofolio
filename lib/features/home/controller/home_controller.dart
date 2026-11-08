import 'package:get/get.dart';
import '../models/project_models.dart';
import '../../auth/models/user_models.dart';
import '../service/home_service.dart';

class HomeController extends GetxController {
  final DataService _dataService = DataService();

  var isLoadingProfile = true.obs;
  var isLoadingProjects = true.obs;
  var isLoadingUsers = true.obs;

  var currentUser = Rxn<UserModel>();
  var listProjects = <ProjectModel>[].obs;
  var listUsers = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  void loadHomeData() {
    fetchProfile();
    fetchProjects();
    fetchUsers();
  }

  Future<void> fetchProfile() async {
    isLoadingProfile.value = true;
    try {
      UserModel user = await _dataService.fetchProfile();
      currentUser.value = user;
    } catch (e) {
      print(e);
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchProjects() async {
    isLoadingProjects.value = true;
    try {
      List<ProjectModel> projects = await _dataService.fetchAllProjects();
      listProjects.value = projects;
    } catch (e) {
      print(e);
    } finally {
      isLoadingProjects.value = false;
    }
  }

  Future<void> fetchUsers() async {
    isLoadingUsers.value = true;
    try {
      List<UserModel> users = await _dataService.fetchAllUsers();
      listUsers.value = users;
    } catch (e) {
      print(e);
    } finally {
      isLoadingUsers.value = false;
    }
  }
}