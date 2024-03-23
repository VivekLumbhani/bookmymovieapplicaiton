import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nookmyseatapplication/pages/serv.dart';

import 'choose.dart';
import 'detail_screen.dart';

class explore extends StatefulWidget {
  const explore({Key? key}) : super(key: key);

  @override
  State<explore> createState() => _GenresListState();
}

class _GenresListState extends State<explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('buscollections').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            var itemList = snapshot.data!.docs;

            if (itemList.isEmpty) {
              return Center(child: Text('No data available'));
            }

            return SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true, // Add this line
                physics: NeverScrollableScrollPhysics(), // Add this line
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.7, // Adjust as needed
                ),

                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  var doc = itemList[index];
                  var moviedet = doc.data() as Map<String, dynamic>;
                  String imgname = moviedet['imgname'] ?? 'Unknown seats';
                  String movieName = moviedet['movieName'] ?? 'Unknown Bus';
                  String movieid=doc.id;
                  double rating = double.tryParse(moviedet['rating'] ?? '0.0') ?? 0.0;
                  String movieexpdate = moviedet['expiryDate'];
                  String releaseDate=moviedet['date']??'';

                  DateTime expdate = DateTime.parse(movieexpdate);
                  DateTime relDate=DateTime.parse(releaseDate);
                  DateTime currentDate = DateTime.now();

                  return FutureBuilder<String>(
                    future: serv().downloadurl(imgname),
                    builder: (BuildContext context, AsyncSnapshot<String> imageSnapshot) {
                      if (imageSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (imageSnapshot.hasError) {
                        return Text('Error: ${imageSnapshot.error}');
                      } else if (!imageSnapshot.hasData) {
                        return Text('No image data available');
                      } else {
                      if (currentDate.isBefore(expdate) && !relDate.isAfter(currentDate)) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(movieename: movieid)),

                                );

                              },
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Image.network(
                                  imageSnapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "$movieName \t",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis, // or TextOverflow.fade depending on your preference
                                    maxLines: 2, // adjust as necessary
                                  ),
                                ),
                                Text("4.5",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                              ],
                            ),

                          ],
                        );

                      }else{
                        return Container();
                      }
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
