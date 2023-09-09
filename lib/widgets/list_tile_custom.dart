import 'package:chat_app_firebase/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_firebase/firestore_files/data_base.dart';

class ListTileCustom extends StatefulWidget {
  final String uid;
  const ListTileCustom({Key? key, required this.uid}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
              ))
          : const CircularProgressIndicator(
              color: Colors.black,
            ),
      title:
          userData != null ? Text(userData!["name"]) : const Text("Loading..."),
      subtitle: userData != null
          ? Text(userData!["name"].toString())
          : const Text("Loading..."),
    );
  }
}
