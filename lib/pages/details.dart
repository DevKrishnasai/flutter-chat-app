import 'dart:io';

import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/login_page.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailedPage extends StatefulWidget {
  final uid;
  const DetailedPage({Key? key, required this.uid});

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage> {
  TextEditingController _nameController = new TextEditingController();
  bool isLoading = false;
  File? file;
  String imageUrl = "";
  FireBaseClient client = FireBaseClient();
  Map<String, dynamic>? details;

  void getFriendsList() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await client.firestore.collection("user").doc(widget.uid).get();
    details = querySnapshot.data();
    setState(() {
      isLoading = false;
      _nameController.text = details!["name"];
    });
  }

  void updateInfo() async {
    setState(() {
      isLoading = true;
    });
    if (file != null) {
      await client.storage
          .child("/profile photos")
          .child("${widget.uid}.jpg")
          .putFile(file!);
      String updatedUrl = await client.storage
          .child("/profile photos")
          .child("${widget.uid}.jpg")
          .getDownloadURL();
      await client.firestore
          .collection("user")
          .doc(widget.uid)
          .update({"name": _nameController.text, "url": updatedUrl.toString()});
    } else {
      await client.firestore
          .collection("user")
          .doc(widget.uid)
          .update({"name": _nameController.text});
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: Duration(seconds: 1),
          content: Text(
            "Data updated successfully",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )),
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getFriendsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details editing'),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                client.auth.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ));
              },
              icon: Icon(
                Icons.login_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  CircularNumberProgressIndicator(time: 1, color: Colors.black))
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/details.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              // height: 200,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            ImagePicker imagePicker = ImagePicker();
                            try {
                              final image = await imagePicker.pickImage(
                                  source: ImageSource.gallery);
                              File file = File(image!.path);
                              setState(() {
                                this.file = file;
                                imageUrl = file.path;
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: ClipOval(
                            child: imageUrl == ""
                                ? Image.network(
                                    details!["url"],
                                    width: 180,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    file!,
                                    height: 180,
                                    width: 180,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 140,
                          right: 14,
                          child: Image.asset(
                            "assets/images/camera.png",
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Icon(
                          Icons.person_2_rounded,
                        ),
                      ),
                      prefixIconColor: Colors.white,
                      hintText: "name",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      updateInfo();
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
