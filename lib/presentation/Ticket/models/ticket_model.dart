class TicketData {
  final String movieId;
  final String movieName;
  final String movieLogoPath;
  final List selectedSeats;
  final DateTime bookingDate;
  final int totalPrice;
  final String userId;

  TicketData({
    required this.movieId,
    required this.movieName,
    required this.movieLogoPath,
    required this.selectedSeats,
    required this.bookingDate,
    required this.totalPrice,
    required this.userId,
  });

  // Convert a Ticket object into a map object
  Map<String, dynamic> toMap() {
    return {
      'movieId': movieId,
      'movieName': movieName,
      'movieLogoPath': movieLogoPath,
      'selectedSeats': selectedSeats,
      'bookingDate': bookingDate.toIso8601String(),
      'totalPrice': totalPrice,
      'userId': userId,
    };
  }

  // Create a Ticket object from a map object
  factory TicketData.fromMap(Map<String, dynamic> map) {
    return TicketData(
      movieId: map['movieId'],
      movieName: map['movieName'],
      movieLogoPath: map['movieLogoPath'],
      selectedSeats: List<String>.from(map['selectedSeats']),
      bookingDate: DateTime.parse(map['bookingDate']),
      totalPrice: map['totalPrice'],
      userId: map['userId'],
    );
  }
}
