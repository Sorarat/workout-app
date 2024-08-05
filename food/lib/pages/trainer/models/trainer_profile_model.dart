import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_trainer_profile_service.dart';

class TrainerProfile {
  String? name;
  String? gender;
  int? age;
  int? experience;
  List<String>? expertise;
  String? profilePictureUrl;

  TrainerProfile({
    this.name,
    this.gender,
    this.age,
    this.experience,
    this.expertise,
    this.profilePictureUrl,
  });

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        Map<String, dynamic>? userData =
            await TrainerSettingProfileService().fetchUserData(user.uid);

        if (userData != null) {
          name = userData['Name'] ?? 'No name';
          gender = userData['Gender'];
          profilePictureUrl = userData['profilePictureUrl'];
          // Update other fields if needed
        } else {
          log('No user data found for uid: ${user.uid}');
        }
      } catch (e) {
        log('Error fetching user data: $e');
      }
    } else {
      log('No user is currently signed in.');
    }
  }
}