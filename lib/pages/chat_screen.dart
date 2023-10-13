import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final senderUid;
  final receiverUid;

  const ChatScreen({
    Key? key,
    required this.senderUid,
    required this.receiverUid,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final client = FireBaseClient();
  TextEditingController textController = TextEditingController();
  String msgUid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? userData;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadChatMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadChatMessages() async {
    String msgUid1 = widget.receiverUid + "_" + widget.senderUid;
    String msgUid2 = widget.senderUid + "_" + widget.receiverUid;

    DocumentSnapshot docSnapshot =
        await client.firestore.collection("messages").doc(msgUid1).get();

    if (!docSnapshot.exists) {
      docSnapshot =
          await client.firestore.collection("messages").doc(msgUid2).get();
    }

    if (docSnapshot.exists) {
      setState(() {
        msgUid = docSnapshot.id;
      });
    } else {
      msgUid = msgUid1;
      await client.firestore.collection("messages").doc(msgUid1).set({
        "messageData": [],
      });
    }
  }

  void addMessage(String message) async {
    final newMessage = {
      "uid": widget.senderUid,
      "msg": message,
      "time": Timestamp.now(),
    };

    await client.firestore.collection("messages").doc(msgUid).update({
      "messageData": FieldValue.arrayUnion([newMessage]),
    });

    // Scroll to the bottom after adding a message
    scrollToBottom();
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future:
            client.firestore.collection("user").doc(widget.receiverUid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularNumberProgressIndicator(
              color: Colors.black,
              time: 2,
            ));
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return Center(child: Text("User not found"));
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  "assets/images/chatBG.jpg",
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
                                            child: userData["url"] == null
                                                ? CircularNumberProgressIndicator(
                                                    time: 1,
                                                    color: Colors.black)
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    width: 50,
                                                    height: 50,
                                                    decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          userData["url"],
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
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
                                            userData["name"] ?? "Loading...",
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
                                    child: StreamBuilder<DocumentSnapshot>(
                                      stream: client.firestore
                                          .collection("messages")
                                          .doc(msgUid)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularNumberProgressIndicator(
                                                      time: 1,
                                                      color: Colors.black));
                                        }

                                        final DocumentSnapshot document =
                                            snapshot.data!;

                                        if (document.exists) {
                                          final Map<String, dynamic>? data =
                                              document.data()
                                                  as Map<String, dynamic>?;

                                          if (data != null) {
                                            final List<dynamic>? messageData =
                                                data["messageData"]
                                                    as List<dynamic>?;

                                            if (messageData != null) {
                                              return ListView.builder(
                                                controller: _scrollController,
                                                reverse: false,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                itemCount: messageData.length,
                                                itemBuilder: (context, index) {
                                                  final message =
                                                      messageData[index];
                                                  final isSender =
                                                      message["uid"] ==
                                                          widget.senderUid;
                                                  return ChatBubble(
                                                    message: message["msg"],
                                                    isSender: isSender,
                                                    timestamp: message["time"],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                          scrollToBottom();
                                        }

                                        return Center(
                                            child: Text("No messages"));
                                      },
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
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              hintText: "Type a message",
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            onSubmitted: (text) {
                                              if (text.isNotEmpty) {
                                                addMessage(text);
                                                textController.clear();
                                              }
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (textController
                                                .text.isNotEmpty) {
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  final Timestamp timestamp;

  ChatBubble({
    required this.message,
    required this.isSender,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final time = timestamp.toDate();
    final formattedTime = DateFormat('h:mm a').format(time);

    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: isSender ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isSender ? Colors.white : Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            formattedTime,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}
