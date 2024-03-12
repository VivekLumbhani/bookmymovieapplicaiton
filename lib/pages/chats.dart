import 'package:flutter/material.dart';
import 'package:nookmyseatapplication/pages/messages.dart';

class chatsScreen extends StatefulWidget {
  const chatsScreen({Key? key}) : super(key: key);

  @override
  State<chatsScreen> createState() => _chatsScreenState();
}

class _chatsScreenState extends State<chatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 50,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Chats Screen",style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),)
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.15,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset("images/profile.png",height: 70,width:70 ,),

                      ),
                      SizedBox(width: 20,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  messagesScreen(),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            SizedBox(height: 10,),

                            Text("sahil",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                            Text("Hello can we exchange the seats",style: TextStyle(color: Colors.black45,fontSize: 15,fontWeight: FontWeight.w500),)
                        ]
                        ),
                      ),
                      Spacer(),

                      Text("4:30 PM",style: TextStyle(color: Colors.black45,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset("images/profile.png",height: 70,width:70 ,),

                      ),
                      SizedBox(width: 20,),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            SizedBox(height: 10,),

                            Text("Tanvi",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                            Text("Yes we can exchange the seats",style: TextStyle(color: Colors.black45,fontSize: 15,fontWeight: FontWeight.w500),)
                          ]
                      ),          Spacer(),

                      Text("4:30 PM",style: TextStyle(color: Colors.black45,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                  SizedBox(height: 30,),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset("images/profile.png",height: 70,width:70 ,),

                      ),
                      SizedBox(width: 20,),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            SizedBox(height: 10,),

                            Text("Hemant",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                            Text("Yes we can exchange the seats",style: TextStyle(color: Colors.black45,fontSize: 15,fontWeight: FontWeight.w500),)
                          ]
                      ),          Spacer(),

                      Text("4:30 PM",style: TextStyle(color: Colors.black45,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
