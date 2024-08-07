import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ticket_model.dart';

Future<List<TicketData>> getUserTickets() async {
  final firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null) {
    // Handle the case when the user is not logged in
    print('User not logged in');
    return [];
  }

  final snapshot = await firestore.collection('users').doc(userId).collection('tickets').get();

  // Convert the documents to Ticket instances
  return snapshot.docs.map((doc) => TicketData.fromMap(doc.data())).toList();
}
