import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _type = -1;
  void _handleRadio(Object? e) => setState(() {
    _type = e as int;
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text("Payment Screen"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40,),
                  Container(
                    width: size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "Amazon Pay",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/amazonpay.png",
                              width: 120,
                              height: 22,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(
                    width: size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 2,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "Debit/Credit cards",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/visa.png",
                              width: 120,
                              height: 22,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                  Container(
                    width: size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 3,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "BHIM/Upi",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/bhimupi.png",
                              width: 120,
                              height: 22,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      border: _type == 1
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Radio(
                                    value: 4,
                                    groupValue: _type,
                                    onChanged: _handleRadio,
                                    activeColor: Color(0xFFDB3022),
                                  ),
                                  Text(
                                    "Gpay",
                                    style: _type == 1
                                        ? TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )
                                        : TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/paymentproviders/gpay.png",
                              width: 120,
                              height: 22,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sub-Total",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,),),
                      Text("300",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,))
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("Convinience fee",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,),),
                      Text("20",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.grey,))
                    ],
                  ),
                  Divider(height: 30,color: Colors.black,),

                  Row(                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text("Total Payment",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.grey,),),
                      Text("20",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: Colors.redAccent,))
                    ],
                  ),
                  SizedBox(height: 70,),
                  InkWell(
                    onTap: () {
                      // Handle button press action here
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xFFDB3022), // Red color from the image
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Center(
                        child: Text(
                          "Confirm Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],

              ),
            ),
          ),
        )
    );
  }
}
