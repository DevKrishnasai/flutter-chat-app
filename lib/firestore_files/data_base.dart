import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseClient {
  //instances of firebase_auth
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance.ref();

  //signin with email and password
  Future<bool> signIn(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          e.message.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )),
      );
      return false;
    }
  }

  //create a account with email and password (signUp)
  Future<bool> signUp(File? path, String email, String name, String password,
      BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Successfully registered',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
      String pathName;
      if (path != null) {
        pathName = "/profile photos/${auth.currentUser!.uid}.png";
      } else {
        pathName = "/profile photos/default/person.png";
      }
      Reference task = FirebaseStorage.instance.ref().child(pathName);
      if (path != null) {
        await task.putFile(path);
      }

      String url = await task.getDownloadURL();

      firestore.collection("user").doc(auth.currentUser!.uid).set(
        {
          "uid": auth.currentUser!.uid,
          "email": auth.currentUser!.email,
          "name": name,
          "url": url,
        },
      );
      return true;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          e.message.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        )),
      );
      return false;
    }
  }
}
