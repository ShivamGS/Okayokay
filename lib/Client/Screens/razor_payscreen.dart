import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../Auth/provider/provider.dart';

class RazePay extends StatefulWidget {
  const RazePay({super.key});

  @override
  State<RazePay> createState() => _RazePayState();
}

class _RazePayState extends State<RazePay> {
  var _razorpay = Razorpay();
  var amountController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  int _currentIndex = 0;
  PageController _pageController = PageController();

  razorpay(String amount) {
    var options = {
      'key': "rzp_test_kJknC6fdavJgMJ",
      'amount': (amount).toString(),
      'name': 'Goverment',
      'description': 'Demo Toll',
      'timeout': 300,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
    };
    _razorpay.open(options);
  }

  void markPaid(String userId, String documentId) async {
    await _firestore
        .collection('Users')
        .doc(userId)
        .collection('challan')
        .doc(documentId)
        .update({
      'paid': true,
    }).then((value) {
      print('Document marked as paid: $documentId');
    }).catchError((error) {
      print('Error marking document as paid: $error');
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds

    print("Payment Done");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        flexibleSpace: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: 'To Pay',
            ),
          ],
        ),
      ),
      body: Container(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            // First Page (History)
            Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userProvider.user!.uid)
                    .collection('challan')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No data available'),
                    );
                  }

                  // Extract and display the 'price' field from each document in the collection
                  List<Widget> priceWidgets = snapshot.data!.docs
                      .where((document) => document['paid'] == true)
                      .map((document) {
                    Timestamp timestamp = document['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDateTime =
                        "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Icon(
                              Icons.currency_rupee_outlined,
                              size: 64,
                            ),
                            Column(
                              children: [
                                Text('Time  :  $formattedDateTime'),
                                Text('Toll Name ${document['name']}'),
                                Text('Amount :  ${document['price']}'),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList();

                  return ListView(
                    children: priceWidgets,
                  );
                },
              ),
            ),

            // Second Page (To Pay)
            Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userProvider.user!.uid)
                    .collection('challan')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No data available'),
                    );
                  }

                  // Extract and display the 'price' field from each document in the collection
                  List<Widget> priceWidgets = snapshot.data!.docs
                      .where((document) => document['paid'] == false)
                      .map((document) {
                    Timestamp timestamp = document['timestamp'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDateTime =
                        "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.currency_rupee_outlined,
                              size: 64,
                            ),
                            Column(
                              children: [
                                Text('Time  :  $formattedDateTime'),
                                Text('Toll Name ${document['name']}'),
                                Text('Amount :  ${document['price']}'),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                markPaid(userProvider.user!.uid, document.id);
                                razorpay((double.parse(
                                            document['price'].toString()) *
                                        100)
                                    .toString());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(color: Colors.blue),
                                child: Text("Pay"),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList();

                  return ListView(
                    children: priceWidgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar:
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
}

// Container(
//           height: size.height,
//           width: size.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//                 child: TextField(
//                     controller: amountController,
//                     decoration: const InputDecoration(
//                       hintText: "Enter Your Amount",
//                     )),
//               ),
//               CupertinoButton(
//                   color: Colors.grey,
//                   child: Text("Pay Now"),
//                   onPressed: razorpay)
//             ],
//           )),
