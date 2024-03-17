import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/messages.dart';
import 'package:nookmyseatapplication/pages/services/database.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';

class chatsScreen extends StatefulWidget {
  const chatsScreen({Key? key}) : super(key: key);

  @override
  State<chatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<chatsScreen> {
  bool search = false;
  var queryResultSet = [];
  var tempSearchStore = [];
  String? myName,myEmail;
  Stream? chatRoomsStream;

  gettheSharedPref()async{
    myName=await SharedPreferenceHelper().getUserName();
    myEmail=await SharedPreferenceHelper().getUserEmail();

  }


  ontheLoad()async{
    // chatRoomsStream=await DatabasesHelper().getChatRooms();
    await gettheSharedPref();
    chatRoomsStream=await DatabasesHelper().getChatRooms();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    ontheLoad();
  }

  String getChatRoomIdbyUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    }
    else {
      return "$a\_$b";
    }
  }
  void initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedVal =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      DatabasesHelper().search(value).then((docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element["name"].startsWith(capitalizedVal)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  Widget buildSearchResults() {
    return ListView.builder(
      itemCount: tempSearchStore.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tempSearchStore[index]["name"]),

        );
      },
    );
  }
  Widget ChatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,  // Added colon here
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,  // Corrected to use docs
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];  // Corrected document retrieval
            return ChatRoomListTitle(
                lastMessage: ds["lastMessage"],
                chatRoomId: ds.id,
                myUserName: myName!,
                time: ds["lastMessageSendTs"]);
          },
        )  // Added closing parenthesis
            : // Handle loading or error state here
        CircularProgressIndicator();  // Example placeholder for loading state
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        height: MediaQuery.of(context).size.height, // Provide a finite height constraint

        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  search
                      ? Expanded(
                          child: TextField(
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search User",
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500)),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : Text(
                          "Chats Screen",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        search = !search; // Toggle search value
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:search? Icon(
                      Icons.close,

                      color: Colors.white,
                      ): Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: search
                  ? MediaQuery.of(context).size.height / 1.19
                  : MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: search
                  ? ListView(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      primary: false,
                      shrinkWrap: true,
                      children: tempSearchStore.map((element) {
                        return buildResultCard(element);
                      }).toList(),
                    )
                  : ChatRoomList()
            )
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: ()async{
        search=false;
        setState(() {

        });
        var chatRoomId=getChatRoomIdbyUserName(myName!, data["name"]);
        Map<String,dynamic>chatRoomInfoMap={
          "users":[myName,data["name"]],
        };
        await DatabasesHelper().createChatRoom(chatRoomId, chatRoomInfoMap);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  messagesScreen(name: data["name"], email: data["email"])
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(60),
                    child: Image.asset("images/profile.png",height: 70,width: 70,fit: BoxFit.cover,))
                ,SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["name"],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                    SizedBox(height: 10,),
                    Text(data["email"],style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ChatRoomListTitle extends StatefulWidget {
  final String lastMessage, chatRoomId, myUserName, time;
  const ChatRoomListTitle({
    Key? key,
    required this.lastMessage,
    required this.chatRoomId,
    required this.myUserName,
    required this.time,
  }) : super(key: key);

  @override
  State<ChatRoomListTitle> createState() => _ChatRoomListTitleState();
}

class _ChatRoomListTitleState extends State<ChatRoomListTitle> {
  String name = "", email = "", username = "", id = "";

  getThisIserInfo() async {
    username = widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUserName, "");
    QuerySnapshot querySnapshot = await DatabasesHelper().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["name"]}";
    id = "${querySnapshot.docs[0]["uniqueUserId"]}";
    email = "${querySnapshot.docs[0]["email"]}";
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getThisIserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to messages screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => messagesScreen(name: name, email: email),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: 100, // Provide a finite height for the Container
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset("images/profile.png", width: 60, height: 60),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    username,
                    style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.lastMessage,
                        style: TextStyle(color: Colors.black45, fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(color: Colors.black45, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
