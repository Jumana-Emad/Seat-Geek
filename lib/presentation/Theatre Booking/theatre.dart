import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplife/presentation/constants.dart';
import '../Ticket/models/ticket_model.dart';
import 'Services/payment_service.dart';
import 'Seat Cubit/cubit.dart';
import 'Widgets/seat_row.dart';
import 'generator.dart';

class TheatreScreen extends StatefulWidget {
  const TheatreScreen(
      {super.key,
      required this.movieId,
      required this.movieName,
      required this.poster,
      required this.otherImage});

  final int movieId;
  final String movieName;
  final String poster;
  final String otherImage;

  @override
  State<TheatreScreen> createState() => _TheatreScreenState();
}

class _TheatreScreenState extends State<TheatreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMovie();
    });
  }

  Future<void> _initializeMovie() async {
    await createOrUpdateMovie(widget.movieId.toString(), context);
  }

  ScrollController centerPage = ScrollController(initialScrollOffset: 250);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.movieName,
          style: const TextStyle(
              fontFamily: "Times New Roman",
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: centerPage,
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ClipPath(
                        clipper: CurvedClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 5)),
                          height: 200,
                          width: 450,
                          child: Image.network(
                            '${Shared.imageBaseUrl}${widget.poster}',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    // Curved Rows of Seats with Aisles
                    for (var i = 0; i < 10; i++)
                      seatRow(String.fromCharCode(65 + i), i),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 10,
              ),
              Text("Selected"),
              CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 10,
              ),
              Text("Available"),
              CircleAvatar(
                backgroundColor: Colors.black,
                radius: 10,
              ),
              Text("Reserved"),
            ],
          ),
          BlocBuilder<SeatCubit, Map<String, dynamic>>(
            builder: (context, state) {
              final int totalPrice = state["totalPrice"] ?? 0;
              return GestureDetector(
                onTap: () {
                  if (totalPrice > 0) {
                    TicketData ticket = TicketData(
                        movieId: widget.movieId.toString(),
                        movieName: widget.movieName,
                        totalPrice: totalPrice,
                        bookingDate: DateTime.now(),
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        selectedSeats:
                            context.read<SeatCubit>().getSelectedSeats(),
                        movieLogoPath: widget.otherImage);
                    pay(ticket, context);
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) =>
                    //     PaymentPage(
                    //       ticket:ticket
                    //     ),));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                              alignment: Alignment.center,
                              height: 70,
                              width: 170,
                              child: const Text(
                                  "Choose the seats you wish to book first")),
                        );
                      },
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Total Price: \$$totalPrice',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height - 50, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
