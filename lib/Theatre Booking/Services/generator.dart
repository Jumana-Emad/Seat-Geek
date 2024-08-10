import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Seat Cubit/cubit.dart';

Future<void> createOrUpdateMovie(String movieId, BuildContext context) async {
  final isInitialized = await isMovieInitialized(movieId);
  if (!isInitialized) {
    await initializeSeats(movieId); // Initialize seats if not already done
  } else {
    print('Movie with ID $movieId is already initialized.');
    // Fetch and initialize seats in the cubit
    final seats = await _getSeatsFromFirestore(movieId);
    BlocProvider.of<SeatCubit>(context).initializeSeats(seats);
  }
}

Future<bool> isMovieInitialized(String movieId) async {
  final firestore = FirebaseFirestore.instance;
  final seatsCollection = firestore.collection('movies').doc(movieId).collection('Seats');

  // Query the seats sub-collection
  final seatsSnapshot = await seatsCollection.limit(1).get();

  // If there is at least one seat document, the movie is initialized
  return seatsSnapshot.docs.isNotEmpty;
}

Future<void> initializeSeats(String movieId) async {
  final firestore = FirebaseFirestore.instance;
  final seatsCollection = firestore.collection('movies').doc(movieId).collection('Seats');

  // Define rows and seats
  const int rows = 10;
  const int seatsPerRow = 17;

  // Generate seat data
  Map<String, Map<String, dynamic>> seatData = {};

  for (int row = 0; row < rows; row++) {
    for (int seat = 0; seat < seatsPerRow; seat++) {
      String seatId = "${String.fromCharCode(65 + row)}${seat + 1}"; // E.g., A1, A2, B1, etc.
      seatData[seatId] = {
        'status': 'A', // Available
        'taker': '',   // Empty initially
      };
    }
  }

  // Add seat data to Firestore
  WriteBatch batch = firestore.batch();
  seatData.forEach((seatId, data) {
    batch.set(seatsCollection.doc(seatId), data);
  });

  await batch.commit();
}

Future<Map<String, dynamic>> _getSeatsFromFirestore(String movieId) async {
  final firestore = FirebaseFirestore.instance;
  final seatsCollection = firestore.collection('movies').doc(movieId).collection('Seats');
  final seatsSnapshot = await seatsCollection.get();

  Map<String, dynamic> seats = {};
  for (var doc in seatsSnapshot.docs) {
    seats[doc.id] = doc.data();
  }
  return seats;
}
