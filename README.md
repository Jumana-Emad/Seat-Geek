# Movie_Ticket_Booking_App

## Overview

Movie_Ticket_Booking_App is a Flutter application designed to provide users with a seamless experience to browse, search, and book movie tickets. The app leverages Firebase for backend services and the TMDB API for movie data. It includes features such as authentication, movie seat selection, and genre-based search functionality.

## Features

- **User Authentication**: Sign up, log in, and Google Sign-In functionality using Firebase Authentication.
- **Home Page**: Displays now playing movies with navigation to detailed movie information.
- **Search Functionality**: Search movies by title or genre with support for multiple genre selections.
- **Movie Details**: View detailed information about movies, including title, rating, overview, actors, director, and trailer.
- **Seat Selection**: Interactive seat selection for booking movie tickets.
- **Ticket Management**: Save and manage booked tickets.
- **Profile Management**: User profile with sign-out functionality.

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/Movie_Ticket_Booking_App.git
   cd Movie_Ticket_Booking_App
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**:
   - Follow the official Firebase documentation to add Firebase to your Flutter project.
   - Configure Firebase Authentication, Firestore, and other necessary services.
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files to the respective directories.

4. **Run the App**:
   ```bash
   flutter run
   ```

## Project Structure

```plaintext
lib
├── main.dart                # Main entry point of the application
├── authentication           # Authentication related code
│   ├── login_page.dart
│   └── signup_page.dart
├── home                     # Home screen and related widgets
│   └── home_page.dart
├── Movies                   # Movie-related screens and models
│   ├── models
│   │   └── movie_details.dart
│   ├── movie_details.dart
│   └── movie_search_cubit.dart
├── search                   # Search functionality
│   ├── search_page.dart
│   └── search_cubit.dart
├── seat_selection           # Seat selection screen
│   ├── seat_selection_page.dart
│   └── seat_cubit.dart
├── tickets                  # Ticket management
│   ├── ticket_page.dart
│   └── ticket_widget.dart
└── profile                  # User profile screen
    └── profile_page.dart
```

## Firebase Integration

### Authentication

The app uses Firebase Authentication for managing user sign-ins and sign-ups. Google Sign-In is also supported.

### Firestore

Firestore is used for storing movie seat data to ensure that multiple users cannot reserve the same seats.

## TMDB API Integration

The app fetches movie data from the TMDB API, including now playing movies, movie details, and movie search results based on genres and queries.

### TMDB Service

The `TMDBService` class handles API requests to the TMDB API. Update your API key in the `TMDBService` class.

## BLoC Pattern

The app uses the BLoC (Business Logic Component) pattern to manage state, making the app scalable and maintainable.

### Major BLoCs/Cubits

- **MovieSearchCubit**: Manages movie search functionality.
- **TheatreCubit**: Manages seat selection and seat data fetching.
- **ProfileCubit**: Manages user profile actions.

## How to Contribute

1. **Fork the Repository**: Click on the "Fork" button on the top right of the repository page.
2. **Clone the Repository**: 
   ```bash
   git clone https://github.com/yourusername/Movie_Ticket_Booking_App.git
   cd cinema_app
   ```
3. **Create a Branch**: 
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Commit Your Changes**: 
   ```bash
   git commit -m 'Add some feature'
   ```
5. **Push to the Branch**: 
   ```bash
   git push origin feature/your-feature-name
   ```
6. **Open a Pull Request**: Go to the repository on GitHub and click on "New Pull Request".

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details.

---

Feel free to customize this README to better suit your project's specifics.
