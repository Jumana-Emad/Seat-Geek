class Ticket {
  final String movieId;
  final String movieName;
  final String movieLogoPath;
  final List selectedSeats;
  // final DateTime bookingDate;
  final String date;
  final String time;
  final String screenNumber;
  final String rating;
  final int totalPrice;
  final String userId;

  Ticket({
    required this.movieId,
    required this.movieName,
    required this.movieLogoPath,
    required this.selectedSeats,
    required this.date,
    required this.time,
    required this.screenNumber,
    required this.rating,
    // required this.bookingDate,
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
      'date': date,
      'time':time,
      'screenNumber': screenNumber,
      'rating': rating,
      // 'bookingDate': bookingDate.toIso8601String(),
      'totalPrice': totalPrice,
      'userId': userId,
    };
  }

  // Create a Ticket object from a map object
  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      movieId: map['movieId'],
      movieName: map['movieName'],
      movieLogoPath: map['movieLogoPath'],
      selectedSeats: List<String>.from(map['selectedSeats']),
      // bookingDate: DateTime.parse(map['bookingDate']),
      totalPrice: map['totalPrice'],
      userId: map['userId'],
      date: map['date'],
      time: map['time'],
      screenNumber:map['screenNumber'],
      rating: map['rating'],
    );
  }

}
