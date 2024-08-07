import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home.dart';
import '../Ticket/models/ticket_model.dart';
import '../Theatre Booking/Services/payment_service.dart';
import 'models/credit.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.ticket});

  final TicketData ticket;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<Credit> cards = [];
  bool _show = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  CardEditController test = CardEditController();

  @override
  void initState() {
    super.initState();
    _loadSavedCards();
  }

  Future<void> _loadSavedCards() async {
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['cards'] != null) {
          setState(() {
            cards = (data['cards'] as List)
                .map((card) => Credit.fromMap(card))
                .toList();
          });
        }
      }
    }
  }

  Future<void> _saveCard(Credit card) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.update({
          'cards': FieldValue.arrayUnion([card.toMap()])
        });
      } else {
        await docRef.set({
          'cards': [card.toMap()]
        });
      }
    }
  }

  void _addCard() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final newCard = Credit(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
      );
      setState(() {
        cards.add(newCard);
        _show = false;
      });
      _saveCard(newCard);
    }
  }

  Future<void> initPaymentSheet(Credit cardData) async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
          // convert string to double
          amount: (widget.ticket.totalPrice).toString(),
          currency: "USD",
          name: cardData.cardHolderName,
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

  Future<void> _pay(Credit card) async {
    // // Show a dialog to prompt for CVV
    // String? cvvCode = await showDialog(
    //   context: context,
    //   builder: (context) {
    //     String cvv = '';
    //     return AlertDialog(
    //       title: const Text('Enter CVV'),
    //       content: TextField(
    //         onChanged: (value) {
    //           cvv = value;
    //         },
    //         keyboardType: TextInputType.number,
    //         maxLength: 3,
    //         decoration: const InputDecoration(
    //           labelText: 'CVV',
    //           hintText: 'XXX',
    //         ),
    //       ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop(cvv);
    //           },
    //           child: const Text('Submit'),
    //         ),
    //       ],
    //     );
    //   },
    // );
    //
    // if (cvvCode == null || cvvCode.isEmpty) {
    //   return; // User canceled the CVV prompt
    // }
    // Implement Stripe payment logic here using the `flutter_stripe` package
    await initPaymentSheet(card);

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
      onPaymentSuccess(widget.ticket);
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

  void onPaymentSuccess(TicketData ticket) async {
    await uploadTicket(ticket);
    await updateSeatStatus(
        ticket.movieId, ticket.selectedSeats, user!.email!);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Pick your Card"),
              cards.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      children: cards
                          .map(
                            (card) => GestureDetector(
                              onTap: () => _pay(card),
                              child: CreditCardWidget(
                                isHolderNameVisible: true,
                                cardType: CardType.visa,
                                glassmorphismConfig: Glassmorphism.defaultConfig(),
                                cardNumber: card.cardNumber,
                                expiryDate: card.expiryDate,
                                cardHolderName: card.cardHolderName,
                                cvvCode: '***',
                                // Hide CVV
                                showBackView: false,
                                isSwipeGestureEnabled: false,
                                onCreditCardWidgetChange: (p0) {},
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox(width: 1),
              _show
                  ? CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      onCreditCardModelChange: (CreditCardModel data) {
                        setState(() {
                          cardNumber = data.cardNumber;
                          expiryDate = data.expiryDate;
                          cardHolderName = data.cardHolderName;
                          cvvCode = data.cvvCode;
                          isCvvFocused = data.isCvvFocused;
                        });
                      },
                    )
                  : const SizedBox(height: 1),
              ElevatedButton.icon(
                onPressed: () {
                  if (_show) {
                    _addCard();
                  } else {
                    setState(() {
                      _show = true;
                    });
                  }
                },
                label: Text(_show ? "Save Card" : "Add Card"),
                icon: Icon(_show ? Icons.save : Icons.add_card),
              ),
            ],
          ),
        ),
      ),
    );
  }
}