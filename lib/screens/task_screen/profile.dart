// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   // User data
//   String? _userName;
//   String? _userProfession;
//   String? _userImageUrl;
//   File? _cachedProfileImage;
//
//   // Firebase instance
//   final _storage = FirebaseStorage.instance;
//   final _firestore = FirebaseFirestore.instance;
//
//   // Image picker
//   final ImagePicker _picker = ImagePicker();
//
//   // Function to pick image from gallery
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       final ref = _storage.ref().child(
//           'user_images/profile_image.png'); // Use a consistent image name
//       try {
//         final uploadTask = ref.putFile(File(image.path));
//         final downloadUrl = await (await uploadTask).ref.getDownloadURL();
//         await _updateUserData(imageUrl: downloadUrl);
//         _cacheImage(downloadUrl);
//       } catch (e) {
//         print("Error uploading image: $e");
//       }
//     }
//   }
//
//   // Function to cache the image locally
//   Future<void> _cacheImage(String imageUrl) async {
//     try {
//       final response = await http.get(Uri.parse(imageUrl));
//       if (response.statusCode == 200) {
//         final bytes = response.bodyBytes;
//         final tempDir = await getTemporaryDirectory();
//         final file = File('${tempDir.path}/profile_image.png');
//         await file.writeAsBytes(bytes);
//         setState(() {
//           _cachedProfileImage = file;
//         });
//       } else {
//         print('Error downloading image: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error caching image: $e");
//     }
//   }
//
//   // Function to update user data on Firebase
//   Future<void> _updateUserData(
//       {String? userName, String? userProfession, String? imageUrl}) async {
//     setState(() {
//       _userName = userName;
//       _userProfession = userProfession;
//       _userImageUrl = imageUrl;
//     });
//     // Update data in Firestore
//     await _firestore.collection('users').doc('profile').set({
//       'name': userName,
//       'profession': userProfession,
//       'imageUrl': imageUrl,
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }
//
//   // Function to fetch user data from Firebase
//   Future<void> _fetchUserData() async {
//     final docSnapshot =
//         await _firestore.collection('users').doc('profile').get();
//     if (docSnapshot.exists) {
//       setState(() {
//         _userName = docSnapshot.get('name');
//         _userProfession = docSnapshot.get('profession');
//         _userImageUrl =
//             docSnapshot.get('imageUrl') ?? 'https://dummyimage.com/150';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         elevation: 0.0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Stack(
//                 alignment: Alignment.bottomRight,
//                 children: [
//                   CircleAvatar(
//                     radius: 80,
//                     backgroundImage: _cachedProfileImage != null
//                         ? FileImage(_cachedProfileImage!)
//                         : NetworkImage(_userImageUrl ??
//                                 'https://cubanvr.com/wp-content/uploads/2023/07/ai-image-generators.webp')
//                             as ImageProvider,
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('Update Profile Image'),
//                             content: const Text(
//                                 'Choose an image from your gallery.'),
//                             actions: [
//                               TextButton(
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text('Cancel'),
//                               ),
//                               TextButton(
//                                 onPressed: () {
//                                   _pickImage();
//                                   Navigator.of(context).pop();
//                                 },
//                                 child: const Text('Pick Image'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(Icons.camera_alt,
//                         size: 30, color: Colors.blue),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 _userName ?? 'User  Name',
//                 style: const TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 _userProfession ?? 'User  Profession',
//                 style: const TextStyle(fontSize: 20, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),
//               TextField(
//                 onChanged: (value) {
//                   _userName = value;
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Edit User Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (value) {
//                   _userProfession = value;
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Edit User Profession',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   _updateUserData(
//                       userName: _userName, userProfession: _userProfession);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//                 child: const Text('Save Changes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Obx(() {
                    final profile = _controller.profile.value;
                    return CircleAvatar(
                      radius: 80,
                      backgroundImage: profile.imageData != null
                          ? MemoryImage(profile.imageData!)
                          : NetworkImage(
                              'https://www.presstv.ir/custom/images/user-profile.png',
                            ) as ImageProvider,
                    );
                  }),
                  IconButton(
                    onPressed: () {
                      _showImageDialog(context);
                    },
                    icon: const Icon(Icons.camera_alt,
                        size: 30, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                final profile = _controller.profile.value;
                return Text(
                  profile.name ?? 'User  Name',
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                final profile = _controller.profile.value;
                return Text(
                  profile.profession ?? 'User  Profession',
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                );
              }),
              const SizedBox(height: 30),
              TextField(
                onChanged: (value) {
                  _controller.updateProfileField(name: value);
                },
                decoration: InputDecoration(
                  labelText: 'Edit User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  _controller.updateProfileField(profession: value);
                },
                decoration: InputDecoration(
                  labelText: 'Edit User Profession',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _validation();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Profile Image'),
          content: const Text('Choose an image from your gallery.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _controller.pickImage();
                Navigator.of(context).pop();
              },
              child: const Text('Pick Image'),
            ),
          ],
        );
      },
    );
  }

  void _validation() {
    final profile = Get.find<ProfileController>().profile.value;

    if (profile.name == null || profile.name!.isEmpty) {
      Get.defaultDialog(
        title: "Validation Error",
        middleText: "Please enter your name.",
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
        },
      );
    } else if (profile.profession == null || profile.profession!.isEmpty) {
      Get.defaultDialog(
        title: "Validation Error",
        middleText: "Please enter your profession.",
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
        },
      );
    } else if (profile.imageData == null) {
      Get.defaultDialog(
        title: "Validation Error",
        middleText: "Please select a profile image.",
        textConfirm: " OK",
        onConfirm: () {
          Get.back();
        },
      );
    } else {
      // If all validations pass, save the profile
      Get.find<ProfileController>().saveProfile();
    }
  }
}
