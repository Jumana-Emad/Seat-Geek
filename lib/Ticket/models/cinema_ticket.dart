class CinemaTicket {
  final String movieName;
  final String movieLogoPath;
  final List<String> selectedSeats;
  final String date;
  final String time;
  final String screenNumber;
  final String rating;

  CinemaTicket({
    required this.movieName,
    required this.movieLogoPath,
    required this.selectedSeats,
    required this.date,
    required this.time,
    required this.screenNumber,
    required this.rating,
  });

  factory CinemaTicket.fromJson(Map<String, dynamic> json) {
    return CinemaTicket(
      movieName: json['movieName'],
      movieLogoPath: json['movieLogoPath'],
      selectedSeats: List.from(json['selectedSeats']),
      date: (json['bookingDate']).toString().substring(0, 10),
      time: json['time'] ?? "10:30 AM",
      screenNumber: json['screenNumber'] ?? "Screen 3",
      rating: json['rating'] ?? "pg-13",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movieName': movieName,
      'movieLogoPath': movieLogoPath,
      'selectedSeats': selectedSeats,
      'date': date,
      'time': time,
      'screenNumber': screenNumber,
      'rating': rating,
    };
  }
}
