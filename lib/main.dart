// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:simplife/firebase_options.dart';
// import 'Splash Screen/splash.dart';
// import '/theme.dart';
// import 'Authentication/signup.dart';
// import 'Authentication/login.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(MaterialApp(
//       theme: lightTheme,
//       // Set light theme as default
//       darkTheme: darkTheme,
//       // Set dark theme
//       themeMode: ThemeMode.system,
//       debugShowCheckedModeBanner: false,
//       home: const SplashScreen()));
// }

// class Auth extends StatefulWidget {
//   const Auth({super.key});

//   @override
//   AuthState createState() => AuthState();
// }

// class AuthState extends State<Auth> {
//   bool showSignIn = true;

//   void toggleView() {
//     setState(() => showSignIn = !showSignIn);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (showSignIn) {
//       return LoginPage(
//         toggleView: toggleView,
//       );
//     } else {
//       return SignupPage(toggleView: toggleView);
//     }
//   }
// }
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:simplife/presentation/Authentication/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplife/firebase_options.dart';
import 'package:simplife/presentation/home.dart';
import 'presentation/Authentication/Services/auth_service.dart';
import 'presentation/Splash Screen/splash.dart';
import '/theme.dart';
import 'presentation/Authentication/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Stripe.publishableKey="pk_test_51Pjp4d08RvCIZYpdCZZ73Lsi3UJkdDi981OtgxMftV92sFrqTxBEK38DPh4vyfsjzsY0GKAMnU9GpHJp7AE73I5m00p5wYrGrO";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(AuthService()),
      child: MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const Home();
        }else if (state is AuthUnauthenticated) {
          return LoginPage();
          } 
        else if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('Unexpected state: $state'));
        }
      },
    );
  }
}
