import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import '../../home/models/project_models.dart';

import '../service/project_service.dart';

class ProjectController extends GetxController {
  final ProjectService _projectService = ProjectService();

  // State untuk List View (Screen 5)
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var listProjects = <ProjectModel>[].obs;
  var listKategori = <KategoriModel>[].obs;
  var listTeknologi = <TeknologiModel>[].obs;

  // State untuk Form (Screen 6)
  final formNamaCtrl = TextEditingController();
  final formTahunCtrl = TextEditingController();
  final formDeskripsiCtrl = TextEditingController();

  var selectedKategori = Rxn<int>();
  var selectedTeknologi = Rxn<int>();
  var selectedImage = Rxn<XFile>();

  var editingProjectId = Rxn<int>();
  var existingImageUrl = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
    fetchMasterData();
  }

  // Mengambil daftar project milik semua orang (atau bisa difilter khusus milik user)
  Future<void> fetchProjects() async {
    isLoading.value = true;
    try {
      listProjects.value = await _projectService.fetchAllProjects();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void prepareEdit(ProjectModel project) {
    editingProjectId.value = project.idProject;
    formNamaCtrl.text = project.nama;
    formTahunCtrl.text = project.tahun.toString();
    formDeskripsiCtrl.text = project.deskripsi ?? '';
    selectedKategori.value = project.kategori?.idKategori;
    selectedTeknologi.value = project.teknologi?.idTeknologi;

    // Set gambar lama dan kosongkan pilihan gambar baru
    existingImageUrl.value = project.imageUrl;
    selectedImage.value = null;
  }

  // Mengambil data kategori dan teknologi untuk dropdown form
  Future<void> fetchMasterData() async {
    try {
      listKategori.value = await _projectService.fetchKategori();
      listTeknologi.value = await _projectService.fetchTeknologi();
    } catch (e) {
      print("Gagal fetch master data: $e");
    }
  }

  // Fungsi pilih gambar dari galeri
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  // Menyimpan Project Baru
  Future<bool> submitProject() async {
    final nama = formNamaCtrl.text.trim();
    final tahunText = formTahunCtrl.text.trim();

    if (nama.isEmpty ||
        tahunText.isEmpty ||
        selectedKategori.value == null ||
        selectedTeknologi.value == null) {
      Get.snackbar(
        'Error',
        'Lengkapi form yang wajib diisi!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    final tahun = int.tryParse(tahunText);
    if (tahun == null) {
      Get.snackbar(
        'Error',
        'Tahun harus berupa angka valid!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    isSubmitting.value = true;
    try {
      final formData = dio.FormData.fromMap({
        'nama': nama,
        'tahun': tahun,
        'deskripsi': formDeskripsiCtrl.text.trim(),
        'id_kategori': selectedKategori.value,
        'id_teknologi': selectedTeknologi.value,
      });

      final image = selectedImage.value;
      if (image != null) {
        final bytes = await image.readAsBytes();
        formData.files.add(
          MapEntry(
            'image_url',
            dio.MultipartFile.fromBytes(bytes, filename: image.name),
          ),
        );
      }
      
      if (editingProjectId.value != null) {
        formData.fields.add(const MapEntry('_method', 'PUT'));
      }

      print(
        'submitProject: selectedImage=${image?.name} fileCount=${formData.files.length}',
      );
      print(
        'submitProject: form fields=${formData.fields.map((e) => '${e.key}=${e.value}').toList()}',
      );

      bool success = await _projectService.saveProject(
        formData,
        idProject: editingProjectId.value,
      );

      if (success) {
        Get.snackbar(
          'Sukses',
          editingProjectId.value != null
              ? 'Project diperbarui'
              : 'Project ditambahkan',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchProjects();
        clearForm();
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // TAMBAHAN: Fungsi Hapus Project
  Future<void> deleteProject(int id) async {
    isLoading.value = true;
    try {
      bool success = await _projectService.deleteProject(id);
      if (success) {
        Get.snackbar(
          'Sukses',
          'Project berhasil dihapus',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        fetchProjects(); // Refresh list
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // PERBARUI: Reset state edit saat form dibersihkan
  void clearForm() {
    formNamaCtrl.clear();
    formTahunCtrl.clear();
    formDeskripsiCtrl.clear();
    selectedKategori.value = null;
    selectedTeknologi.value = null;
    selectedImage.value = null;

    editingProjectId.value = null;
    existingImageUrl.value = null;
  }
}
