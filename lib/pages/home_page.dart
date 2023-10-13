import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/details.dart';
import 'package:chat_app_firebase/pages/search_page.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:chat_app_firebase/widgets/list_tile_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final client = FireBaseClient();
  bool isLoading = false;
  late Map<String, dynamic>? friends;
  late List<dynamic> friendsList;
  bool isDark = false;
  var data;

  void details() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot = await client
          .firestore
          .collection("user")
          .doc(client.auth.currentUser!.uid)
          .get();

      if (mounted) {
        setState(() {
          data = querySnapshot.data();
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    details();
  }

  @override
  Widget build(BuildContext context) {
    return data == null
        ? Scaffold(
            body: Center(
              child: CircularNumberProgressIndicator(
                color: Colors.black,
                time: 2,
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 4,
              toolbarHeight: 60,
              backgroundColor: !isDark ? Colors.white : Colors.black,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return DetailedPage(
                        uid: client.auth.currentUser!.uid,
                      );
                    },
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      data["url"],
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isDark = !isDark;
                      });
                    },
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: isDark ? Colors.white : Colors.black,
                      size: 37,
                    ),
                  ),
                ),
              ],
              title: Text(
                "SnapTalk",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              foregroundColor: isDark ? Colors.white : Colors.black,
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 1000),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SearchPage();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = 0.0;
                      const end = 1.0;
                      var curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      var opacityAnimation = animation.drive(tween);
                      return FadeTransition(
                        opacity: opacityAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              backgroundColor: !isDark ? Colors.white : Colors.black,
              child: Icon(Icons.person_add_alt_sharp),
            ),
            body: SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white : Colors.black,
                  image: DecorationImage(
                    image: AssetImage("assets/images/homeBG.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: isLoading
                          ? CircularNumberProgressIndicator(
                              time: 1, color: Colors.black)
                          : StreamBuilder(
                              stream: client.firestore
                                  .collection("user_user")
                                  .doc(client.auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularNumberProgressIndicator(
                                      time: 2,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  );
                                }

                                friends = snapshot.data?.data();
                                if (friends == null) {
                                  return Center(
                                    child: Text(
                                      "Add friends",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  friendsList = friends?["friends"] == null
                                      ? []
                                      : friends?["friends"];
                                  if (friendsList.length == 0) {
                                    return Center(
                                      child: Text("no friends"),
                                    );
                                  }
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: friendsList.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 3,
                                          ),
                                          ListTileCustom(
                                            uid: friendsList[index],
                                            isDark: isDark,
                                          ),
                                          Divider(
                                            thickness: 2,
                                            color: !isDark
                                                ? Colors.white
                                                : Colors.black,
                                            indent: 10,
                                            endIndent: 10,
                                          )
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
