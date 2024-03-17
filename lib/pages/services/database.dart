import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nookmyseatapplication/pages/services/shared_pref.dart';

class DatabasesHelper {
  Future<QuerySnapshot> search(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("searchKey", isEqualTo: userName.substring(0, 1).toUpperCase())
        .get();
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatsroom")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatsroom")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatsroom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  Future<void> updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatsroom")
          .doc(chatRoomId)
          .update(lastMessageInfoMap);
      print("Last message updated successfully.");
    } catch (e) {
      print("Error updating last message: $e");
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatsroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: userName.toUpperCase())
        .get();
  }
  Future<Stream<QuerySnapshot>> getChatRooms() async {
    try {
      String? myUsername = await SharedPreferenceHelper().getUserName();
      print("Current user's username: $myUsername");
      if (myUsername != null) {
        Stream<QuerySnapshot> snapshots = FirebaseFirestore.instance
            .collection("chatsroom")
            .orderBy("time", descending: false)
            .where("users", arrayContains: myUsername.toUpperCase())
            .snapshots();

        snapshots.listen((snapshot) {
          snapshot.docs.forEach((doc) {
            print("Document ID: ${doc.id}");
            print("Data: ${doc.data()}");
          });
        });

        return snapshots;
      } else {
        print("Error: Unable to retrieve current user's username.");
        return Stream.empty();
      }
    } catch (e) {
      print("Error in getChatRooms(): $e");
      return Stream.empty();
    }
  }
  //
  //
  // Future<QuerySnapshot> getUserMovies(String userName) async {
  //   return await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("name", isEqualTo: userName.toUpperCase())
  //       .get();
  // }

}

