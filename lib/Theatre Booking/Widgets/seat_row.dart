import 'dart:math';

import 'package:flutter/material.dart';
import 'seat.dart';

Widget seatRow(String row, int rowIndex) {
  const double seatSpacing = 10.0;
  const double curveFactor = 40.0; // Adjust this value to control the curve
  const int seatsPerRow = 17; // Total seats including aisles

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: seatSpacing),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(seatsPerRow, (index) {
        if (index == 5 || index == 11) {
          return const SizedBox(width: 25); // Vertical aisles
        }

        if (rowIndex == 5) {
          return SizedBox(
            width: 42,
            height: 22 + sin((index / (seatsPerRow - 3)) * pi) * curveFactor,
          ); // Horizontal aisle
        }

        // double yOffset = sin((index / (seatsPerRow - 3)) * pi) * curveFactor; // Adjust for seats excluding aisles
        return movieSeat("$row${index + 1}");
      }),
    ),
  );
}