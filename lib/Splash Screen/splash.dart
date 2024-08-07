import "package:animated_splash_screen/animated_splash_screen.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "Widgets/shaking_text.dart";

import "../../main.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(
        AssetImage(Theme.of(context).brightness == Brightness.dark
            ? "assets/images/login_signup/login dark.jpg"
            : "assets/images/login_signup/login light.jpg"),
        context);

    return AnimatedSplashScreen(
        backgroundColor: Colors.lightBlue.shade700,
        duration: 3000,
        centered: true,
        splashIconSize: 400,
        splash: Stack(alignment: Alignment.bottomCenter, children: [
          Center(
            child: LottieBuilder.asset("assets/images/Splash/blueticket.json"),
          ),
          const ShakeText(
            text: "Seat Geek",
            style: TextStyle(
                color: Colors.white, fontSize: 54, fontFamily: "HarryPotter"),
            duration: Duration(seconds: 1),
          )
        ]),
        nextScreen: const Auth());
  }
}
