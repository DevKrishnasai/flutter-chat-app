import 'package:chat_app_firebase/firestore_files/data_base.dart';
import 'package:chat_app_firebase/pages/chat_screen.dart';
import 'package:chat_app_firebase/widgets/animater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FireBaseClient client = FireBaseClient();
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> resultList = [];
  bool isLoading = false;

  void searchQuery(String search) async {
    if (search.isEmpty) {
      setState(() {
        isLoading = false;
        resultList.clear();
      });
      return;
    } else {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot querySnapshot =
          await client.firestore.collection("user").get();

      setState(() {
        resultList.clear();
        isLoading = false;
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data["uid"] != client.auth.currentUser!.uid) {
            String name = (data['name'] as String).toLowerCase();
            search = search.toLowerCase();

            if (name.contains(search)) {
              resultList.add(data);
            }
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              searchQuery(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: "Search...",
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    resultList.clear();
                  });
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 7,
      ),
      body: isLoading
          ? Center(
              child: CircularNumberProgressIndicator(
                time: 1,
                color: Colors.black,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: resultList.isEmpty
                      ? const Center(
                          child: Text(
                            'No results found.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: resultList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                DocumentReference docRef1 = client.firestore
                                    .collection("user_user")
                                    .doc(client.auth.currentUser!.uid);
                                DocumentReference docRef2 = client.firestore
                                    .collection("user_user")
                                    .doc(resultList[index]["uid"]);

                                docRef1
                                    .get()
                                    .then((DocumentSnapshot documentSnapshot) {
                                  if (documentSnapshot.exists) {
                                    docRef1.update({
                                      "friends": FieldValue.arrayUnion(
                                          [resultList[index]["uid"]]),
                                    });
                                  } else {
                                    docRef1.set({
                                      "friends": [resultList[index]["uid"]],
                                    });
                                  }

                                  docRef2.get().then(
                                      (DocumentSnapshot documentSnapshot) {
                                    if (documentSnapshot.exists) {
                                      docRef2.update({
                                        "friends": FieldValue.arrayUnion(
                                            [client.auth.currentUser!.uid]),
                                      });
                                    } else {
                                      docRef2.set({
                                        "friends": [
                                          client.auth.currentUser!.uid
                                        ],
                                      });
                                    }

                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return ChatScreen(
                                          senderUid:
                                              client.auth.currentUser!.uid,
                                          receiverUid: resultList[index]["uid"],
                                        );
                                      }),
                                    );
                                  }).catchError((error) {
                                    print("Error getting document: $error");
                                  });
                                });
                              },
                              title: Text(resultList[index]["name"]),
                              // subtitle: Text(resultList[index]["uid"]),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    resultList[index]["url"],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
