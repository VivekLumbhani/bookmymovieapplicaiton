import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseGetUserApi {
  final CollectionReference _collection =
  FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser;

  Future<Map<String, String>> getUserDetails() async {
    try {
      if (user != null) {
        QuerySnapshot querySnapshot = await _collection
            .where('email', isEqualTo: user!.email.toString())
            .get();

        // Check if there is any matching document
        if (querySnapshot.docs.isNotEmpty) {
          // Access the first document (assuming there's only one match)
          var userData = querySnapshot.docs[0].data() as Map<String, dynamic>?;

          // Use null-aware operators to safely access fields
          String? name = userData?['name'] as String?;
          String? phoneNumber = userData?['phonenumber'] as String?;

          if (name != null && phoneNumber != null) {
            var jsonResp = {
              "name": name,
              "phoneNumber": phoneNumber,
              "email": user!.email.toString(),
            };
            return jsonResp;
          } else {
            print('User details incomplete');
          }
        } else {
          print('No matching user found');
        }
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }

    // Return a default value in case of an error or incomplete user details
    return {
      "name": "Unknown",
      "phoneNumber": "Unknown",
      "email": user?.email.toString() ?? "Unknown",
    };
  }
}
