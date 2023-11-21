import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazePay extends StatefulWidget {
  const RazePay({super.key});

  @override
  State<RazePay> createState() => _RazePayState();
}

class _RazePayState extends State<RazePay> {
  var _razorpay = Razorpay();
  var amountController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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

    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("RazorPay"),
      ),
      body: Container(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: TextField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      hintText: "Enter Your Amount",
                    )),
              ),
              CupertinoButton(
                  color: Colors.grey,
                  child: Text("Pay Now"),
                  onPressed: () {
                    var options = {
                      'key': "rzp_test_kJknC6fdavJgMJ",
                      'amount':
                          (int.parse(amountController.text) * 100).toString(),
                      'name': 'Goverment',
                      'description': 'Demo Toll',
                      'timeout': 300,
                      'prefill': {
                        'contact': '8888888888',
                        'email': 'test@razorpay.com'
                      }
                    };
                    _razorpay.open(options);
                  })
            ],
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
}
