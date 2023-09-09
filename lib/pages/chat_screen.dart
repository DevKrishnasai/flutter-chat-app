import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final senderUid;
  final receiverUid;
  const ChatScreen(
      {Key? key, required this.senderUid, required this.receiverUid})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final client = FireBaseClient();
  TextEditingController textController = TextEditingController();
  Map<String, dynamic>? userData;
  List<Map<dynamic, dynamic>> messages = []; // List to store chat messages

  fetchData() async {
    try {
      final docSnapshot = await client.firestore
          .collection("user")
          .doc(widget.receiverUid)
          .get();

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
  void initState() {
    super.initState();
    fetchData();
    // Load chat messages (replace with your own logic)
    loadChatMessages();
  }

  // Load chat messages (replace with your own logic)
  void loadChatMessages() {
    // messages = [
    //   "Hello!",
    //   "How are you?",
    //   "I'm doing well, thanks!",
    //   "What's new?",
    //   "Not much, just working on some projects.",
    //   "Hello!",
    //   "How are you?",
    //   "I'm doing well, thanks!",
    //   "What's new?",
    //   "Not much, just working on some projects.",
    //   "Hello!",
    //   "How are you?",
    //   "I'm doing well, thanks!",
    //   "What's new?",
    //   "Not much, just working on some projects.",
    //   "Hello!",
    //   "How are you?",
    //   "I'm doing well, thanks!",
    //   "What's new?",
    //   "Not much, just working on some projects.",
    // ];
  }

  // Function to add a new message to the chat
  void addMessage(String message) {
    setState(() {
      messages.add(
        {
          "msg": message,
          "time": Timestamp.now().toDate(),
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/chatBG.jpg", // Replace with your background image path
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 130,
                            color: Colors.black,
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    child: userData?["url"] == null
                                        ? CircularProgressIndicator()
                                        : Container(
                                            padding: const EdgeInsets.all(20),
                                            width: 50,
                                            height: 50,
                                            decoration: ShapeDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    userData!["url"]),
                                                fit: BoxFit.fill,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                side: BorderSide(
                                                  width: 1,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 24,
                                  left: 75,
                                  child: Text(
                                    userData?["name"] == null
                                        ? "Loading..."
                                        : userData!["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 8,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_vert_outlined,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return ChatBubble(
                                    message: messages[index]["msg"],
                                    sender:
                                        FirebaseAuth.instance.currentUser!.uid,
                                    time: messages[index]["time"]);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            hintText: "Type a message",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (textController.text.isNotEmpty) {
                            addMessage(textController.text);
                            textController.clear();
                          }
                        },
                        icon: Icon(Icons.send),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// ignore: must_be_immutable
class ChatBubble extends StatelessWidget {
  String message;
  String sender;
  DateTime time;
  ChatBubble(
      {super.key,
      required this.message,
      required this.sender,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          children: [
            Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              time.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
