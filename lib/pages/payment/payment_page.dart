import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/data.dart';
import 'package:lulu3/base/custom_button.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:square_in_app_payments/models.dart';
// import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:lulu3/data/api/http_client.dart';
import 'package:lulu3/utils/app_constants.dart';
import 'package:uuid/uuid.dart';

// payment_screen.dart
class PaymentPage extends StatefulWidget {
  final int total;
  const PaymentPage({Key? key, required this.total}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? paymentIntent;
  void _makePayment () {
    // InAppPayments.startCardEntryFlow(
    //     onCardNonceRequestSuccess: _onCardNonceRequestSuccess,
    //   // onCardNonceRequestSuccess: (cardDetails) => _onCardNonceRequestSuccess(cardDetails, otherArgument),
    //     onCardEntryCancel: _onCardEntryCancel,
    // );
  }
  void _onCardEntryCancel () {
    print('cancel the card entry');
  }
  // void _onCardNonceRequestSuccess (CardDetails result) async {
  //   print('zack nonce is: '+result.nonce);
  //   var uuid = const Uuid().v1(
  //       config: V1Options(
  //           0x1234,
  //           DateTime.utc(2011, 11, 01).millisecondsSinceEpoch,
  //           5678,
  //           [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
  //           null)
  //   );
  //   print("zack uuid is: "+ uuid);
  //   var body = jsonEncode({
  //     "idempotency_key": uuid,
  //     "source_id": result.nonce, //"cnon:CBASEGZwG4zy-tdroF07RISkGYQ",
  //     "amount_money": {
  //       "amount": 3,
  //       "currency": "CAD"
  //     }
  //   });
  //   var response = await http.post(
  //       Uri.parse('https://connect.squareup.com/v2/payments'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer Add Production Access ID Here',
  //       },
  //       body: body);
  //   if (response.statusCode == 200) {
  //     print("zack try is good");
  //     InAppPayments.completeCardEntry(onCardEntryComplete: () {  });
  //   } else {
  //     print("zack try is bad");
  //     InAppPayments.showCardNonceProcessingError("Charge failed");
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: CustomButton(
          buttonText: 'Submit3',
          onPressed: _makePayment,
        ),
      ),
    );
  }
}