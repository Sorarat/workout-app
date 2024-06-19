import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/auth/firestore_service.dart';

class AuthService{


  // get instance of firebase auth

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get current user
  User ? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // get user role
  Future<String> getUserRole(String uid) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snapshot.get('role');
  }



  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {

    // try sign user in
    try {

      UserCredential userCredential = 
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password,
      );

      return userCredential;

    }  

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

  }


  // sign up

  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {

    // try sign user in
    try {

      UserCredential userCredential = 
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      
      User? user = userCredential.user;

      if (user!= null) {
        String role = email == "sorarat.uow@gmail.com" ? "admin" : "user";
        await FirestoreService().createUserDocument(user, role);
      }

      return userCredential;

    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }

  }


  // sign out

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();

  }


}
