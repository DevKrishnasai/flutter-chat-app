import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/home_page.dart';
import 'package:chat_app_firebase/pages/register_page.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final FireBaseClient client = FireBaseClient();
  bool isLoading = false;
  bool passwordVisible = false;
  bool passwordTyping = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void checking(String login) async {
      bool loginStatus = false;
      if (login == "withEmail") {
        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "Please fill all the fields",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ));
        } else {
          setState(() {
            isLoading = true;
          });

          loginStatus = await client.signIn(
            _emailController.text.toString(),
            _passwordController.text.toString(),
            context,
          );

          setState(() {
            isLoading = false;
          });
        }
      }

      if (loginStatus) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading
          ? Center(
              child:
                  CircularNumberProgressIndicator(time: 2, color: Colors.black),
            )
          : SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/solid.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "continue with your previous account",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 19),
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
                    TextField(
                      onTap: () {
                        setState(() {
                          passwordTyping = true;
                        });
                      },
                      obscureText: !passwordVisible,
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white, fontSize: 19),
                      decoration: InputDecoration(
                        suffixIconColor: Colors.white,
                        suffixIcon: passwordTyping
                            ? Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                  icon: passwordVisible
                                      ? const Icon(Icons.visibility_rounded)
                                      : const Icon(Icons.visibility_off_sharp),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
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
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        checking("withEmail");
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
                          "Login",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child:
                          Stack(alignment: Alignment.bottomCenter, children: [
                        Positioned(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don’t have an account?",
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
                                        builder: (context) => RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Register",
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
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
