// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import '../db/profile_database_helper.dart';
// import '../model/profile_model.dart';
//
// class ProfileController extends GetxController {
//   final Rx<ProfileModel> profile = ProfileModel().obs;
//   final RxBool isEditing = false.obs;
//   final ImagePicker _picker = ImagePicker();
//
//   // Initialize controller
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProfile();
//   }
//
//   // Fetch Profile from Database
//   Future<void> fetchProfile() async {
//     try {
//       final fetchedProfile = await DatabaseHelper().getProfile();
//       if (fetchedProfile != null) {
//         profile.value = fetchedProfile;
//       }
//     } catch (e) {
//       print('Error fetching profile: $e');
//     }
//   }
//
//   // Pick Image from Gallery
//   Future<void> pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         // Read image as Uint8List
//         final imageBytes = await File(image.path).readAsBytes();
//
//         // Update profile with new image
//         profile.update((val) {
//           val?.imageData = imageBytes;
//         });
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
//
//   // Save Profile
//   Future<void> saveProfile() async {
//     try {
//       await DatabaseHelper().insertProfile(profile.value);
//       isEditing.value = false;
//       Get.snackbar('Success', 'Profile Updated Successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to update profile');
//       print('Error saving profile: $e');
//     }
//   }
//
//   // Toggle Editing Mode
//   void toggleEditing() {
//     isEditing.toggle();
//   }
//
//   // Update Profile Fields
//   void updateProfileField({String? name, String? profession}) {
//     profile.update((val) {
//       if (name != null) val?.name = name;
//       if (profession != null) val?.profession = profession;
//     });
//   }
// }
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
      final fetchedProfile = await DatabaseHelper().getProfile();
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
      await DatabaseHelper().insertProfile(profile.value);
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
