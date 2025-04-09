import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lulu3/base/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:lulu3/controllers/payment_controller.dart';
import 'package:lulu3/controllers/user_controller.dart';
import 'package:lulu3/utils/colors.dart';
import 'package:lulu3/widgets/big_text.dart';

// payment_screen.dart
class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  CardFieldInputDetails? _cardDetails;
  PaymentMethod? _paymentMethod;

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
    // setState(() => _isSaving = true);

    try {
      // 1. Create payment method

      _paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(
                  name: Get.find<UserController>().userModel?.name,
                  phone: Get.find<UserController>().userModel?.phone,
                  email: Get.find<UserController>().userModel?.email
              )
          ),
        ),
      );
      print('Created Payment Method: ${_paymentMethod?.id}');
      print(_paymentMethod?.card.last4);
      // 2. Send to backend customer table
      try {
        // update memory
        Get.find<UserController>().userModel!.payment_method_id = _paymentMethod!.id;
        Get.find<UserController>().userModel!.last4 = _paymentMethod!.card.last4!;
        await Get.find<UserController>().saveUserAccount(Get.find<UserController>().userModel!);
        print("new user model after update paymentId, last4");
        print(Get.find<UserController>().userModel!.payment_method_id);
        // update database
        final response = await Get.find<UserController>().updatePayment(Get.find<UserController>().userModel!.email, _paymentMethod!.id, _paymentMethod!.card.last4!);
        if (response.isSuccess) {
          // update stripe
          final response2 = await Get.find<PaymentController>().attachPaymentMethodToCustomer(Get.find<UserController>().userModel!.customer_id, _paymentMethod!.id);
          if (response2.isSuccess) {

          }
        }
      } catch (err) {
        throw Exception(err);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      // setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BigText(text: "Add/Change Card", color: Colors.white,),
        centerTitle: true,
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios)),
      ),
      // AppBar(title: Text('Add/Change Card')),
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
            ),
            const SizedBox(height: 20),
            CustomButton(
              buttonText: "Using This Card",
              onPressed: () {
                _saveCard().then((_) {
                  Get.back();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}