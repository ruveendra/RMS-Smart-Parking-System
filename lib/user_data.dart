import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User appUser;

List<dynamic> signUpData = new List.filled(5, "");

Future<String> signUp(String userID) async{

  await FirebaseFirestore.instance.collection("user").doc(userID).set({
    'name':signUpData[0].toString(),
    'email':signUpData[2].toString(),
    'role':'user'
  });

  return 'successful';
}