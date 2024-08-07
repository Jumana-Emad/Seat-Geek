import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Seat Cubit/cubit.dart';

Widget movieSeat(String seatId) {
  return BlocBuilder<SeatCubit, Map<String, dynamic>>(
    builder: (context, state) {
      final seats = state["seats"] ?? {};
      final seatStatus = seats[seatId] == null ? "A":seats[seatId]["status"];
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: IconButton(
          onPressed: seatStatus == "T" ? null : () {
            // print(seatId);
            context.read<SeatCubit>().selectSeat(seatId);
          },
          icon: Icon(
            Icons.event_seat,
            size: 42,
            color: seatStatus == "S" ? Colors.amber : seatStatus == "T" ? Colors.black : Colors.grey,
          ),
        ),
      );
    },
  );
}
