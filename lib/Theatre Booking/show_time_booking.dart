import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seatGeek/Theatre%20Booking/theatre.dart';
import 'package:seatGeek/constants.dart';

import 'Seat Cubit/cubit.dart';

class MovieShowtimePage extends StatefulWidget {
  const MovieShowtimePage(
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
  MovieShowtimePageState createState() => MovieShowtimePageState();
}

class MovieShowtimePageState extends State<MovieShowtimePage> {
  int _selectedDayIndex = 0;
  int _selectedTimeIndex = -1;

  final List<String> _days = [
    "Aug 10",
    "Aug 11",
    "Aug 12",
    "Aug 13",
  ];

  final List<List<String>> _times = [
    ["10:00 AM", "1:00 PM", "4:00 PM", "7:00 PM", "10:00 PM"],
    ["11:00 AM", "2:00 PM", "5:00 PM", "8:00 PM", "10:00 PM"],
    ["12:00 PM", "3:00 PM", "6:00 PM", "9:00 PM"],
    ["9:00 AM", "12:00 PM", "3:00 PM", "6:00 PM", "9:00 PM"]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Showtime"),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "${Shared.imageBaseUrl}${widget.poster}",
                height: MediaQuery.of(context).size.height / 4,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  widget.movieName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Select a Day",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(_days[index]),
                        selected: _selectedDayIndex == index,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDayIndex = index;
                            _selectedTimeIndex = -1;
                          });
                        },
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.7),
                        backgroundColor: Colors.grey[300],
                        labelStyle: TextStyle(
                          color: _selectedDayIndex == index
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select a Time",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _times[_selectedDayIndex]
                    .map((time) => ChoiceChip(
                          label: Text(time),
                          selected: _selectedTimeIndex ==
                              _times[_selectedDayIndex].indexOf(time),
                          onSelected: (selected) {
                            setState(() {
                              _selectedTimeIndex =
                                  _times[_selectedDayIndex].indexOf(time);
                            });
                          },
                          selectedColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.7),
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(
                            color: _selectedTimeIndex ==
                                    _times[_selectedDayIndex].indexOf(time)
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: _selectedTimeIndex == -1
                    ? null
                    : () {
                        // Navigate to the next page or perform any action
                        // with the selected date and time.
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                        create: (_) => SeatCubit({}),
                                        child: TheatreScreen(
                                  movieId: widget.movieId,
                                  movieName: widget.movieName,
                                  poster: widget.poster,
                                  otherImage: widget.otherImage,
                                  date: _days[_selectedDayIndex],
                                  time: _times[_selectedDayIndex][_selectedTimeIndex]),
                            )));
                        // print("Selected Day: ${_days[_selectedDayIndex]}");
                        // print(
                        //     "Selected Time: ${_times[_selectedDayIndex][_selectedTimeIndex]}");
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
