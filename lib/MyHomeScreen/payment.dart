import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/payment_controller.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _cardController = CardFormEditController();
  String? _customerId;
  String? _last4;
  bool _isSaving = false;
  CardFieldInputDetails? _cardDetails;
  PaymentMethod? _paymentMethod;

  @override
  void initState() {
    super.initState();
    // _loadCustomerData(); // Load stored customer ID
    _loadSavedCard();
  }
  void _loadSavedCard() async {
    // final prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   // _last4 = prefs.getString('last4');
    //   // _customerId = prefs.getString('customerId');
    // });
  }
  Future<void> _saveCard() async {
    print(_cardDetails?.complete);
    if (!(_cardDetails?.complete ?? false)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Incomplete Card'),
          content: Text('Please fill all card details'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 1. Create payment method
      _paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
              paymentMethodData: PaymentMethodData(
                billingDetails: BillingDetails(
                  name: "Zack",
                  phone: '7801234567',
                  email: 'email@gmail.com'
                )
              ),
          ),
      );
      print('Created Payment Method: ${_paymentMethod?.id}');
      print(_paymentMethod?.card.last4);
      // // 2. Send to backend customer table
      // final response = await http.post(
      //   Uri.parse('YOUR_BACKEND_URL/save-card.php'),
      //   body: {
      //     'payment_method_id': paymentMethod.id,
      //     'email': 'customer@example.com', // Get from user input
      //   },
      // );

      // final data = json.decode(response.body);
      // if (response.statusCode == 200) {
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('customerId', data['customerId']);
      //   await prefs.setString('last4', data['last4']);
      //   setState(() {
      //     _customerId = data['customerId'];
      //     _last4 = data['last4'];
      //   });
      // }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Enter your card details:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            CardField(
              onCardChanged: (card) {
                setState(() {
                  _cardDetails = card;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Card',
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              autofocus: true,
              numberHintText: '4242 4242 4242 4242',
              cvcHintText: 'CVC',
              // Country and postal code are not shown by default
              // Don't set `dangerouslyGetFullCardDetails: true` unless necessary
            ),
            const SizedBox(height: 20),
            // if (_last4 != null)
            //   Text('Saved Card: **** **** **** $_last4'),
            // if (_customerId == null) ...[
            //   SizedBox(height: 20),
            //   // ElevatedButton(
            //   //   onPressed: _isSaving ? null : _saveCard,
            //   //   child: Text('Save Card'),
            //   // ),
              ElevatedButton(
                child: Text("Create Payment Method"),
                onPressed: () async {
                    _saveCard();
                },
              )
            // ],
            // if (_customerId != null)
            //   ElevatedButton(
            //     onPressed: () async {
            //       // Trigger charge (example)
            //       final response = await http.post(
            //         Uri.parse('YOUR_BACKEND_URL/charge.php'),
            //         body: {
            //           'customerId': _customerId!,
            //           'amount': '1000', // $10.00
            //         },
            //       );
            //       // Handle response
            //     },
            //     child: Text('Charge Saved Card'),
            //   ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: Column(
    //       children: [
    //         CardField(
    //           onCardChanged: (value) {
    //             card = value;
    //             print('Card Changed: ${value?.complete}');
    //           },
    //         ),
    //         ElevatedButton(
    //           onPressed: () {
    //             print("start to create token");
    //             Map<String, dynamic> add = {
    //               "city": "Edmonton",
    //               "country": "Canada",
    //               "line1": "2733 Kirkland Way SW",
    //               "line2": "Edmonton",
    //               "postalCode": "T6W 3B4",
    //               "state": "AB"
    //             };
    //             Map<String, dynamic> card = {
    //               "number": "5434408354472680",
    //               "expiryYear": 28,
    //               "expiryMonth": 05,
    //               "cvc": "847",
    //               "brand": "Mastercard",
    //               "complete": true,
    //               "last4": "2680",
    //               "validCVC": "valid",
    //               "validNumber": "valid",
    //               "validExpiryDate": "valid",
    //               "name": "joe",
    //               "address": add,
    //               "currency": "cad"
    //             };
    //             Map<String, dynamic> jsonParas = {
    //               "params": card,
    //               "runtimeType": "card"
    //             };
    //             CardTokenParams cardParams = CardTokenParams(
    //               type: TokenType.Card,
    //               name: cardholderName,
    //             );
    //             try {
    //               Stripe.instance.createToken(
    //                   CreateTokenParams.card(params: cardParams),
    //               ).then((value) {
    //                 print(value);
    //               });
    //             } catch (err) {
    //               throw Exception(err);
    //             }
    //           },
    //           child: Text('Save Card Info'),
    //         ),
    //       ],
    //     )
    //   ),
    // );
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Center(
  //       child: TextButton(
  //           onPressed: () async {
  //             await makePayment();
  //           },
  //           child: const Text("Make a payment"),
  //       ),
  //     ),
  //   );
  // }
  // Future<void> makePayment() async {
  //   try {
  //     print("start to make payment");
  //     await createPaymentIntent('1.2', 'cad').then((value) async {
  //       print(value['client_secret']);
  //       await Stripe.instance.initPaymentSheet(
  //           paymentSheetParameters: SetupPaymentSheetParameters(
  //               paymentIntentClientSecret: value['client_secret'],
  //               style: ThemeMode.dark,
  //               merchantDisplayName: 'LULU'
  //           )
  //       ).then((value) {
  //         displayPaymentSheet();
  //       });
  //     });
  //   } catch (err) {
  //     throw Exception(err);
  //   }
  // }
  // displayPaymentSheet() async {
  //   try {
  //     print("start to display");
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       print("start to show dialog");
  //       showDialog(
  //           context: context,
  //           builder: (_) => const AlertDialog(
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(Icons.check_circle, color: Colors.green,size: 100.0,),
  //                 SizedBox(height: 10.0,),
  //                 Text("Payment Successful!"),
  //               ],
  //             ),
  //           )
  //       );
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (err) {
  //     print('Error is : --->$err');
  //     const AlertDialog(
  //       content: Column(
  //         children: [
  //           Row(
  //             children: [
  //               Icon(Icons.cancel, color: Colors.red,),
  //               Text("Payment Failed"),
  //             ],
  //           )
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     print("start to create payment intent");
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };
  //     print("here2");
  //     String encodedBody = Uri(queryParameters: body).query;
  //     print(encodedBody);
  //     var response = await http.post(
  //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //       headers: {
  //         'Authorization': 'Bearer '+AppConstants.STRIPE_SECRET_ID,
  //         'Content-Type': 'application/x-www-form-urlencoded',
  //       },
  //       body: encodedBody,
  //     );
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }
  // calculateAmount(String amount) {
  //   print("start to cal amount");
  //   double calculateAmount = double.parse(amount)*100;
  //   print("here3");
  //   String result = calculateAmount.toInt().toString();
  //   print("result is $result");
  //   return result;
  // }
}
