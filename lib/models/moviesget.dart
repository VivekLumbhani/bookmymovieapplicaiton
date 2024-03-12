import 'package:cloud_firestore/cloud_firestore.dart';

class Firebaseapitest {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('buscollections');

  Future<List<Map<String, dynamic>>> getData() async {
    QuerySnapshot querySnapshot = await _collection.get();
    DateTime currentDate = DateTime.now();

    List<Map<String, dynamic>> filteredData = querySnapshot.docs.where((doc) {
      var moviedet = doc.data() as Map<String, dynamic>;
      String movieexpdate = moviedet['expiryDate'];
      DateTime expdate = DateTime.parse(movieexpdate);

      return currentDate.isBefore(expdate) ||
          currentDate.isAtSameMomentAs(expdate);
    }).map((doc) {
      var moviedet = doc.data() as Map<String, dynamic>;
      moviedet['documentID'] = doc.id;
      return moviedet;
    }).toList();

    return filteredData;
  }
}
