import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../db/profile_database_helper.dart';
import '../model/profile_model.dart';
import '../utils/logger.dart';

class ProfileController extends GetxController {
  final Rx<ProfileModel> profile = ProfileModel().obs;
  final RxBool isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // Fetch Profile
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final fetchedProfile = await ProfileDatabaseHelper().getProfile();
      if (fetchedProfile != null) {
        profile.value = fetchedProfile;
      }
    } catch (e) {
      AppLogger.e('Error fetching profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Pick Image
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final imageBytes = await File(image.path).readAsBytes();

        profile.update((val) {
          val?.imageData = imageBytes;
        });
      }
    } catch (e) {
      AppLogger.e('Error picking image: $e');
    }
  }

  // Save Profile
  Future<void> saveProfile() async {
    try {
      isLoading.value = true;
      await ProfileDatabaseHelper().insertProfile(profile.value);
      Get.snackbar('Success', 'Profile Updated Successfully');
      fetchProfile(); // Refresh profile after saving
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
      AppLogger.e('Error saving profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile Fields
  void updateProfileField({String? name, String? profession}) {
    profile.update((val) {
      if (name != null) val?.name = name;
      if (profession != null) val?.profession = profession;
    });
  }
}
