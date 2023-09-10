import 'dart:io';
import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/pages/login_page.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final client = FireBaseClient();
  bool isLoading = false;

  String imageUrl = "Assets/Images/person.png";
  File? file;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool passwordTyping = false;
  int passwordLength = 0;
  bool confirmPasswordTyping = false;
  int confirmPasswordLength = 0;

  @override
  void initState() {
    super.initState();
  }

  Future? registor(registerWith) async {
    bool registerStatus = false;
    if (registerWith == "withEmail") {
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill in all fields',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.black,
          ),
        );
      } else if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Passwords do not match',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      } else if (_passwordController.text.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Passwords must contain atleast 6 characters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
      } else {
        setState(() {
          isLoading = true;
        });
        registerStatus = await client.signUp(
            file,
            _emailController.text.toString(),
            _nameController.text.toString(),
            _passwordController.text.toString(),
            context);
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = true;
      });
      await client.signInWithGoogle(context);
      registerStatus = true;
      setState(() {
        isLoading = false;
      });
    }
    if (registerStatus) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularNumberProgressIndicator(
            time: 2,
          )
        : Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.93,
                    width: MediaQuery.sizeOf(context).width,
                    child: Stack(
                      children: [
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            const Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Create a new account with us ...",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 19),
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.person_2_rounded,
                                  ),
                                ),
                                prefixIconColor: Colors.white,
                                hintText: "name",
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              controller: _emailController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 19),
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.email,
                                  ),
                                ),
                                prefixIconColor: Colors.white,
                                hintText: "email",
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              onTap: () {
                                setState(() {
                                  passwordTyping = true;
                                });
                              },
                              obscureText: !passwordVisible,
                              controller: _passwordController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 19),
                              decoration: InputDecoration(
                                suffixIconColor: Colors.white,
                                suffixIcon: passwordTyping
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: IconButton(
                                          icon: passwordVisible
                                              ? const Icon(
                                                  Icons.visibility_rounded)
                                              : const Icon(
                                                  Icons.visibility_off_sharp),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        ),
                                      )
                                    : null,
                                fillColor: Colors.red,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.password,
                                  ),
                                ),
                                prefixIconColor: Colors.white,
                                hintText: "password",
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextField(
                              onTap: () {
                                setState(() {
                                  confirmPasswordTyping = true;
                                });
                              },
                              obscureText: !confirmPasswordVisible,
                              controller: _confirmPasswordController,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 19),
                              decoration: InputDecoration(
                                suffixIconColor: Colors.white,
                                suffixIcon: confirmPasswordTyping
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: IconButton(
                                          icon: confirmPasswordVisible
                                              ? const Icon(
                                                  Icons.visibility_rounded)
                                              : const Icon(
                                                  Icons.visibility_off_sharp),
                                          onPressed: () {
                                            setState(() {
                                              confirmPasswordVisible =
                                                  !confirmPasswordVisible;
                                            });
                                          },
                                        ),
                                      )
                                    : null,
                                fillColor: Colors.red,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.password,
                                  ),
                                ),
                                prefixIconColor: Colors.white,
                                hintText: "confirm password",
                                hintStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 3),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            GestureDetector(
                              onTap: () {
                                registor("withEmail");
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
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                registor("withGoogle");
                              },
                              child: Container(
                                height: 55,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/google.png"),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Text(
                                      "Register with google",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Positioned(
                          width: MediaQuery.of(context).size.width * 0.90,
                          bottom: 0,
                          child: Container(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal: 20, vertical: 20),
                            // width: MediaQuery.of(context).size.width,
                            height: MediaQuery.sizeOf(context).height * 0.07,
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}





// Stack(alignment: Alignment.center, children: [
//                     GestureDetector(
//                       onTap: () async {
//                         ImagePicker imagePicker = ImagePicker();
//                         try {
//                           final image = await imagePicker.pickImage(
//                               source: ImageSource.gallery);
//                           File file = File(image!.path);
//                           setState(() {
//                             this.file = file;
//                             imageUrl = file.path;
//                           });
//                           print(file.path);
//                         } catch (e) {
//                           print(e);
//                         }
//                       },
//                       child: ClipOval(
//                         child: imageUrl.contains("Assets")
//                             ? Image.asset(
//                                 imageUrl,
//                                 width: 120,
//                                 height: 120,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.file(
//                                 File(imageUrl),
//                                 width: 120,
//                                 height: 120,
//                                 fit: BoxFit.cover,
//                               ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 73,
//                       right: 0,
//                       child: Image.asset(
//                         "Assets/Images/camera.png",
//                         width: 30,
//                         height: 30,
//                       ),
//                     ),
//                   ]),
