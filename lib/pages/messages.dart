import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nookmyseatapplication/pages/seats_exchange.dart';
import 'package:nookmyseatapplication/pages/services/database.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';
import 'package:random_string/random_string.dart';

class messagesScreen extends StatefulWidget {
  String name, email;
  messagesScreen({required this.name, required this.email});
  @override
  State<messagesScreen> createState() => _messagesScreenState();
}

class _messagesScreenState extends State<messagesScreen> {
  TextEditingController messageController = new TextEditingController();
  String? myUserName, myEmail, messageId, chatRoomId;
  Stream? messageStream;
  String? selectedOption; // Add this line to declare selectedOption


  getsharepref() async {
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    chatRoomId = getChatRoomIdbyUserName(widget.name, myUserName!);
    setState(() {});
  }

  ontheLoad() async {
    await getsharepref();
    await getAndSetMessages();
    setState(() {});
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment: sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
                bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
              ),
              color: sendByMe ? Color.fromARGB(255, 234, 236, 240) : Color.fromARGB(255, 211, 220, 243),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 90, top: 130),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return chatMessageTile(
                        ds["message"], myUserName == ds["sendBy"]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  addMessage(bool sendClicked) async {
    if (messageController.text != "") {
      String message = messageController.text;
      messageController.text = "";
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(now);
      messageId ??= randomAlphaNumeric(10);


      if (chatRoomId == null) {
        chatRoomId = getChatRoomIdbyUserName(widget.name, myUserName!);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, widget.name],
        };
        await DatabasesHelper().createChatRoom(chatRoomId!, chatRoomInfoMap);
      }

      // Add message to the chat room
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
      };
      await DatabasesHelper()
          .addMessage(chatRoomId!, messageId!, messageInfoMap);

      Map<String, dynamic> lastMessageInfoMap = {
        "lastMessage": message,
        "lastMessageSendTs": formattedDate,
        "time": FieldValue.serverTimestamp(),
        "lastMessageSendBy": myUserName
      };

      try {
        await DatabasesHelper()
            .updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        print("Last message updated successfully.");
      } catch (e) {
        print("Error updating last message: $e");
      }

      if (sendClicked) {
        messageId = null;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ontheLoad();
    print("user name is ${widget.name} and email is ${widget.email}");
  }

  String getChatRoomIdbyUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  getAndSetMessages()async{
    messageStream=await DatabasesHelper().getChatRoomMessages(chatRoomId);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text(widget.name),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 40),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: chatMessage(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // Your text field widget
                        controller: messageController, // Add this line

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          hintStyle: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => addMessage(true), // Your send message function
                      icon: Icon(Icons.send_rounded),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (String result) {
                        setState(() {
                          selectedOption = result;

                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: Text('Transfer seats'),
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        seats_exchange(name: widget.name,email: widget.email,)
                                        // messagesScreen(name: data["name"], email: data["email"])
                                ),
                              );

                            },

                          ),
                          PopupMenuItem(
                            child: Text('Option 2'),
                            value: 'Option 2',
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
                  ],
      ),
    );
  }

}
