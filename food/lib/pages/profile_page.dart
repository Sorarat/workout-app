
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plan'),
      ),

      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        )
      )
    );

  }
}