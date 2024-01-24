import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

void main() {
  Stripe.publishableKey =
  "pk_test_51ORHrsSDM4yUUHmfajN3B2FDixie1l0c9rfgVrBRq9NiaUIoeTFwlJ15rPkZV2YlzBN8UUF8kGgidelFmGZuCzqb00t60OkeFG";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage  extends StatefulWidget{
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentIntent;

  void makePayment () async {
       try {
       paymentIntent = await createPaymentIntent();

       var gPay= const PaymentSheetGooglePay(
        merchantCountryCode: "US",
        currencyCode: "USD",
        testEnv: true,
       );
       await Stripe.instance.initPaymentSheet (
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent! ["client_secret"],
          style: ThemeMode.dark,
          merchantDisplayName: "Pratham",
          googlePay: gPay
        ));
        displayPaymentSheet();
       } catch (e) {}
  }

  void displayPaymentSheet () async {
       try {
       await Stripe.instance.presentPaymentSheet();
       } catch (e) {}
  }

   createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount" : "1000",
        "currency" : "USD",
      };

      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization" : 
          "Bearer sk_test_51ORHrsSDM4yUUHmfajN3B2FDixie1l0c9rfgVrBRq9NiaUIoeTFwlJ15rPkZV2YlzBN8UUF8kGgidelFmGZuCzqb00t60OkeFG",
          "Content-type": "application/x-www-form-urlencoded",
        });
        return json.decode(response.body);
    } catch(e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Example"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () {
          makePayment();
        }, 
        child: const Text("Pay Me!")),
      ),
    );
  }
}

// pk_test_51ORHrsSDM4yUUHmfajN3B2FDixie1l0c9rfgVrBRq9NiaUIoeTFwlJ15rPkZV2YlzBN8UUF8kGgidelFmGZuCzqb00t60OkeFG