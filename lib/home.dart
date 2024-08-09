import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Search/search_page.dart';
import 'Movies/now_playing_movies.dart';
import 'Search/Search Cubit/cubit.dart';
import 'Search/search_service.dart';
import 'Ticket/ticket.dart';
import 'Authentication/bloc/auth_bloc.dart';
import 'Authentication/login.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tabIndex = 0;
  final tmdbService = TMDBService();

  void _onTabSelected(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const MovieListScreen(), // Replace with your Now Playing Movies page
      BlocProvider(
        create: (context) => MovieSearchCubit(tmdbService),
        child: const SearchPage(),
      ), // Blank page
      const MyTicketsPage(), // Replace with your Ticket page
      const Profile(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items:  [
          BottomNavigationBarItem(
            icon: const Icon(Icons.movie),
            label: "Movies",
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black87,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: "Search",
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black87,
          ),
           BottomNavigationBarItem(
            icon: const Icon(Icons.theaters),
            label: "My Tickets",
             backgroundColor: Theme.of(context).brightness == Brightness.light
                 ? Colors.white
                 : Colors.black87,
          ),
           BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: "Profile",
             backgroundColor: Theme.of(context).brightness == Brightness.light
                 ? Colors.white
                 : Colors.black87,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        currentIndex: _tabIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.blue.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        elevation: 0,
        onTap: _onTabSelected,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white
          : Colors.black87,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: pages[_tabIndex],
      ),
    );
  }
}
