import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/trainer_navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/trainer/views/trainer_base_page.dart';
import 'package:food/pages/trainer/views/trainer_my_client_page.dart';
import 'package:food/pages/trainer/views/trainer_workout_plan_page.dart';
import 'package:food/pages/workout/workout_page.dart';
import 'package:food/services/setting_user_profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;

  const ProfileTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
          child: SizedBox(
            height: 40.0,
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter $label',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrainerProfileSetting extends StatefulWidget {
  @override
  _TrainerProfileSettingState createState() => _TrainerProfileSettingState();
}

class _TrainerProfileSettingState extends State<TrainerProfileSetting> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  Map<String, dynamic> profileData = {
    'Name': '',
    'gender': '',
    'Age': '',
    'Height(cm)': '',
    'Weight(kg)': '',
  };

  Map<String, dynamic> profileData_1 = {
    'Email': '',
  };

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: profileData['Name'] ?? '');
    emailController = TextEditingController(text: profileData_1['Email'] ?? '');
    genderController = TextEditingController(text: profileData['gender'] ?? '');
    ageController = TextEditingController(text: profileData['Age'] ?? '');
    heightController = TextEditingController(text: profileData['Height(cm)'] ?? '');
    weightController = TextEditingController(text: profileData['Weight(kg)'] ?? '');

    fetchProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();

    super.dispose();
  }

  void fetchProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('UserProfile')
          .get();

      Map<String, dynamic> data = {};
      querySnapshot.docs.forEach((doc) {
        data.addAll(doc.data() as Map<String, dynamic>);
      });

      setState(() {
        profileData = data;
        profileData_1['Email'] = user.email ?? '';
        nameController.text = profileData['Name'] ?? '';
        emailController.text = profileData_1['Email'] ?? '';
        genderController.text = profileData['gender'] ?? '';
        ageController.text = profileData['Age'] ?? '';
        heightController.text = profileData['Height(cm)'] ?? '';
        weightController.text = profileData['Weight(kg)'] ?? '';
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  void updateProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      await SettingProfileService().updateSettingProfile(user.uid, profileData);
      print('Profile updated successfully!');
    } catch (e) {
      print('Failed to update profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
            Spacer()
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // profile image avatar
              CircleAvatar(
                backgroundColor: Colors.grey[100],
                radius: 50.0,
              ),
              // text fields
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Name',
                controller: nameController,
                onChanged: (value) {
                  setState(() {
                    profileData['Name'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Email',
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    profileData_1['Email'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Gender',
                controller: genderController,
                onChanged: (value) {
                  setState(() {
                    profileData['gender'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Age',
                controller: ageController,
                onChanged: (value) {
                  setState(() {
                    profileData['Age'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Height(cm)',
                controller: heightController,
                onChanged: (value) {
                  setState(() {
                    profileData['Height(cm)'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Weight(kg)',
                controller: weightController,
                onChanged: (value) {
                  setState(() {
                    profileData['Weight(kg)'] = value;
                  });
                },
              ),
              // update profile button
              ElevatedButton(
                onPressed: updateProfileData,
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TrainerNavbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TrainerBasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => TrainerWorkoutPlanPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => TrainerMyClientPage()));
                break;
            }
          }
        },
      ),
    );
  }
}
