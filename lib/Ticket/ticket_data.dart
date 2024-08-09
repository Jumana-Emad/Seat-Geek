import 'package:flutter/material.dart';
import 'models/ticket_model.dart';

class TicketData extends StatelessWidget {
  final Ticket ticket;

  const TicketData({
    required this.ticket,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 60.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.red),
              ),
              child: const Center(
                child: Text(
                  'Live',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            ticket.movieName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 55),
          child: ticketDetailsWidget(
            'Date',
            ticket.date,
            'Time',
            ticket.time,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 55, left: 12),
          child: ticketDetailsWidget(
            'Screen NO:',
            ticket.screenNumber,
            'PG Rating',
            ticket.rating,
          ),
        ),
        const SizedBox(height: 5),
        const Center(
          child: Text(
            '@Seat Geek',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
