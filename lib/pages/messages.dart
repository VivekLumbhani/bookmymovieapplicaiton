import 'package:flutter/material.dart';

class messagesScreen extends StatefulWidget {
  const messagesScreen({Key? key}) : super(key: key);

  @override
  State<messagesScreen> createState() => _messagesScreenState();
}

class _messagesScreenState extends State<messagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  Text(
                    "Sahil",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 40),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 3),
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 234, 236, 240),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Text(
                      "Hello can we exchange the seats",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 3),
                    alignment: Alignment.bottomRight,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 220, 243),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: Text(
                      "Yeah sure,we can obviiously do that",
                      style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.only(left: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                  hintStyle: TextStyle(color: Colors.black45)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                            Icons.send,
                            color: Colors.grey,
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
