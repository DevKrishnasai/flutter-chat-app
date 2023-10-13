import 'package:chat_app_firebase/pages/chat_screen.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_firebase/firestore_files/data_base.dart';

class ListTileCustom extends StatefulWidget {
  final String uid;
  final bool isDark;
  const ListTileCustom({Key? key, required this.uid, required this.isDark})
      : super(key: key);

  @override
  State<ListTileCustom> createState() => _ListTileCustomState();
}

class _ListTileCustomState extends State<ListTileCustom> {
  final client = FireBaseClient();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchData();
    lastMsg();
  }

  fetchData() async {
    try {
      final docSnapshot =
          await client.firestore.collection("user").doc(widget.uid).get();

      if (docSnapshot.exists) {
        setState(() {
          userData = docSnapshot.data() as Map<String, dynamic>;
        });
        print(userData.toString());
      } else {
        print("User not found");
      }
    } catch (e) {
      print(e);
    }
  }

  lastMsg() async {
    String msgUid1 = widget.uid + "_" + client.auth.currentUser!.uid;
    String msgUid2 = client.auth.currentUser!.uid + "_" + widget.uid;

    DocumentSnapshot docSnapshot =
        await client.firestore.collection("messages").doc(msgUid1).get();

    if (!docSnapshot.exists) {
      docSnapshot =
          await client.firestore.collection("messages").doc(msgUid2).get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return userData == null
        ? LinearProgressIndicator(
            minHeight: 60,
            borderRadius: BorderRadius.circular(30),
            color: !widget.isDark ? Colors.white : Colors.black,
            backgroundColor: widget.isDark ? Colors.white : Colors.black,
          )
        : ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen(
                      senderUid: client.auth.currentUser!.uid,
                      receiverUid: widget.uid,
                    );
                  },
                ),
              );
            },
            leading: userData != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      userData!["url"],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                : CircularNumberProgressIndicator(
                    color: Colors.black,
                    time: 2,
                  ),
            title: userData != null
                ? Text(
                    userData!["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  )
                : Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
            subtitle: userData != null
                ? Text(
                    userData!["name"].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  )
                : Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
          );
  }
}
