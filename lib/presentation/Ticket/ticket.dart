import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simplife/presentation/constants.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/cinema_ticket.dart';
import 'QR_cubit/qr_cubit.dart';
import 'ticket_data.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black87,
      appBar: AppBar(
        title: const Text('Your Tickets'),
      ),
      body: BlocProvider(
        create: (context) => QrCubit(),
        child: FutureBuilder<List<CinemaTicket>>(
          future: _fetchUserTickets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tickets found'));
            }

            final tickets = snapshot.data!;

            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return BlocBuilder<QrCubit, QrState>(
                  builder: (context, state) {
                    bool showQrCode = false;
                    if (state is QrCodeVisible && state.index == index) {
                      showQrCode = true;
                    }

                    return TicketWidget(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 500,
                      isCornerRounded: true,
                      child: InkWell(
                        onLongPress: () {
                          if (showQrCode) {
                            context.read<QrCubit>().hideQrCode();
                          } else {
                            context.read<QrCubit>().showQrCode(index);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${Shared.imageBaseUrl}${ticket.movieLogoPath}',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue.shade700,
                              ),
                              child: showQrCode
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: QrImageView(
                                        size: 170,
                                        data:
                                            "Bought By: ${FirebaseAuth.instance.currentUser!.email}\n"
                                            "Movie:${ticket.movieName} \n"
                                            "Seats: ${ticket.selectedSeats}\n"
                                            "Date: ${ticket.date}\n"
                                            "Time: ${ticket.time}\n"
                                            "Screen no: ${ticket.screenNumber}\n"
                                            "PG-Rating: ${ticket.rating}",
                                      ),
                                    )
                                  : TicketData(ticket: ticket),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      alignment: Alignment.center,
                                      icon: const Icon(Icons.theaters),
                                      title: const Text("Seat Numbers"),
                                      contentTextStyle:
                                          const TextStyle(fontSize: 32),
                                      content: Wrap(
                                        spacing: 8,
                                        children: ticket.selectedSeats
                                            .map((seat) => Text(
                                                  seat.toString(),
                                                ))
                                            .toList(),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      ticket.selectedSeats.length.toString(),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<CinemaTicket>> _fetchUserTickets() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tickets')
        .get();

    return snapshot.docs
        .map((doc) => CinemaTicket.fromJson(doc.data()))
        .toList();
  }
}
