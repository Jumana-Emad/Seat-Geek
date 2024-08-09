import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../Ticket/models/ticket_model.dart';
import '../../../home.dart';

Future createPaymentIntent(
    {required String name,
    required String address,
    required String pin,
    required String city,
    required String state,
    required String country,
    required String currency,
    required String amount}) async
{

  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  const secretKey =
      "sk_test_51Pjp4d08RvCIZYpdPzZVgQWa7wUbg4L2TumF73gF0JZWnjYRvvL4Q7lC0NjTLEA6bidZHua3UNXVK3rGE9VGxWRf009dtX2dkz";
  final body = {
    'amount': (int.parse(amount) * 100).toString(),
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Buying Movie Ticket",
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': city,
    'shipping[address][state]': state,
    'shipping[address][country]': country
  };

  final response = await http.post(url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  print(body);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    print(response.body);
    print("error in calling payment intent");
    throw Exception("Failed to create payment intent");
  }
}

Future<void> initPaymentSheet(Ticket ticket, BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    // 1. create payment intent on the client side by calling stripe api
    final data = await createPaymentIntent(
      // convert string to double
        amount: (ticket.totalPrice).toString(),
        currency: "USD",
        name: user!.email!,
        address: "Egypt",
        pin: "1234",
        city: "Giza",
        state: "m3ndenash",
        country: "US");

    // 2. initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Set to true for custom flow
        customFlow: false,
        // Main params
        merchantDisplayName: 'Test Merchant',
        paymentIntentClientSecret: data['client_secret'],
        // Customer keys
        customerEphemeralKeySecret: data['ephemeralKey'],
        customerId: data['id'],
        style: ThemeMode.system,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
    rethrow;
  }
}

Future<void> pay(Ticket ticket, BuildContext context) async {
  await initPaymentSheet(ticket, context);

  try {
    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Payment Done",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));

    print("Payment Successful");
    onPaymentSuccess(ticket, context);
  } catch (e) {
    print("payment sheet failed");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Payment Failed",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent,
    ));
  }
}

void onPaymentSuccess(Ticket ticket, BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  String slot = "${ticket.movieId}${ticket.date}${ticket.time}";
  await uploadTicket(ticket);
  await updateSeatStatus(
      slot, ticket.selectedSeats, user!.email!);
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false,
  );
}

Future<void> uploadTicket(Ticket ticket) async {
  final firestore = FirebaseFirestore.instance;

  final ticketsCollection =
      firestore.collection('users').doc(ticket.userId).collection('tickets');

  try {
    await ticketsCollection.add(ticket.toMap());
    print('Ticket uploaded successfully.');
  } catch (e) {
    print('Error uploading ticket: $e');
  }
}

Future<void> updateSeatStatus(String slot,List selectedSeats, String userEmail) async {
  final firestore = FirebaseFirestore.instance;

  final seatsCollection = firestore.collection('movies').doc(slot).collection('Seats');

  for (String seatId in selectedSeats) {
    await seatsCollection.doc(seatId).update({
      'status': 'T',
      'taker': userEmail,
    });
  }
}
