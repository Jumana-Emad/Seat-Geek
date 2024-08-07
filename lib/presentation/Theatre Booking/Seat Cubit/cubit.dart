import 'package:bloc/bloc.dart';

class SeatCubit extends Cubit<Map<String, dynamic>> {
  static const int seatPrice = 10; // Define the price per seat

  SeatCubit(Map<String, String> initialSeats)
      : super({"seats": initialSeats, "totalPrice": 0});

  void initializeSeats(Map<String, dynamic> seats) {
    emit({
      'seats': seats,
      'totalPrice': 0,
    });
    print(seats);
  }
  void selectSeat(String seatId) {
    print("aywa b select");
    final currentState = state;
    final seats = Map<String, dynamic>.from(currentState["seats"] as Map<String, dynamic>);
    int totalPrice = state["totalPrice"];
    if (seats.containsKey(seatId)) {
      final seat = seats[seatId];
      if (seat["status"] == "A") {
        // Only allow selection if the seat is available
        seats[seatId] = {"status": "S", "taker": seat["taker"]};

        totalPrice += seatPrice;

      } else if (seat["status"] == "S") {
        // Toggle back to available if it was selected
        seats[seatId] = {"status": "A", "taker": ""};
        totalPrice -= seatPrice;

      }
      emit({"seats": seats, "totalPrice": totalPrice});
    }
  }
  List getSelectedSeats() {
    final seats = state['seats'] ?? {};
    return seats.entries
        .where((entry) => entry.value['status'] == 'S')
        .map((entry) => entry.key)
        .toList();
  }

}
