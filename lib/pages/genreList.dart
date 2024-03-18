import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nookmyseatapplication/pages/serv.dart';

import 'choose.dart';
import 'detail_screen.dart';

class GenresList extends StatefulWidget {
  final String? categoryof;

  const GenresList({Key? key, this.categoryof}) : super(key: key);

  @override
  State<GenresList> createState() => _GenresListState();
}

class _GenresListState extends State<GenresList> {
  @override
  Widget build(BuildContext context) {
    String catofuser = widget.categoryof!.toLowerCase().trim(); // Trim and convert to lowercase
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
            print("Selected Category: $catofuser");
            var filteredMovies = itemList.where((doc) {
              var moviedet = doc.data() as Map<String, dynamic>;
              List<String>? categories = moviedet['categories']?.map((cat) => cat.toLowerCase().trim()).cast<String>().toList();
              print("Categories from DB: $categories and cat types ${categories.runtimeType}");


              if (categories != null && categories.length >= 4) {
                print("Fourth category: ${categories[3]}");
              } else {
                print("Less than 4 categories");
              }

              return categories != null && categories.contains(catofuser);
            }).toList();


            print("Filtered Movies: $filteredMovies");

            if (filteredMovies.isEmpty) {
              return Center(child: Text('No movies available in this category'));
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
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) {
                  var doc = filteredMovies[index];
                  var moviedet = doc.data() as Map<String, dynamic>;
                  String imgname = moviedet['imgname'] ?? 'Unknown seats';
                  String movieName = moviedet['movieName'] ?? 'Unknown Bus';
                  String movieid=doc.id;
                  double rating = moviedet['rating'] ?? 0.0;

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
