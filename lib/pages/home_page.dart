import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/login_page.dart';
import 'package:chat_app_firebase/pages/search_page.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:chat_app_firebase/widgets/list_tile_custom.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final client = FireBaseClient();
  bool isLoading = false;
  void signOutFunction() async {
    setState(() {
      isLoading = true;
    });

    // Check if currentUser is not null before signing out
    if (client.auth.currentUser != null) {
      await client.auth.signOut();
    }

    // Use Navigator to navigate back to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  void handlePopupMenuSelection(int item) {
    switch (item) {
      case 0:
        // Implement edit profile functionality
        break;
      case 1:
        client.auth.signOut();
        signOutFunction();

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    FireBaseClient client = FireBaseClient();
    return isLoading
        ? CircularNumberProgressIndicator(
            time: 1,
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('SnapTalk'),
              centerTitle: true,
              backgroundColor: Colors.black,
              elevation: 7,
              leading: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
              ),
              actions: [
                PopupMenuButton<int>(
                  color: Colors.black,
                  position: PopupMenuPosition.under,
                  icon: const Icon(
                    Icons.mode_edit_rounded,
                    color: Colors.white,
                  ),
                  onSelected: (item) => handlePopupMenuSelection(item),
                  itemBuilder: (context) => const [
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: client.auth.currentUser != null
                        ? StreamBuilder(
                            stream: client.firestore
                                .collection("user_user")
                                .doc(client.auth.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("error"),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularNumberProgressIndicator(
                                  time: 1,
                                ));
                              }
                              final data = snapshot.data!.data();
                              List<dynamic> friends =
                                  data == null ? [] : data["friends"];
                              if (friends.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "You have no friends",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                itemCount: friends.length,
                                itemBuilder: (context, index) {
                                  return ListTileCustom(
                                    uid: friends[index],
                                  );
                                },
                              );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  )
                ],
              ),
            ));
  }
}
