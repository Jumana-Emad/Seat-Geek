import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Face Detection/detection_screen.dart';
import 'signup.dart';
import '../home.dart';
import 'bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Theme.of(context).brightness == Brightness.dark
                  ? "assets/images/login_signup/login dark.jpg"
                  : "assets/images/login_signup/login light.jpg",
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthAuthenticated) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 60.0),
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Enter your credentials to login",
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _inputField(context),
                    Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          context.read<AuthBloc>().add(
                            SignInRequested(
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.2),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.75),
                          ),
                        ),
                      ),
                    ),
                    _forgotPassword(context),
                    const Center(child: Text("Or",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),)),
                    Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(GoogleSignInRequested());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.2),
                        ),
            
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 25.0,
                              width: 25.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/images/login_signup/google.png",
                              ),
                            ),
                            const SizedBox(width: 18),
                            Text(
                              "Sign In with Google",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Center(child: Text("Or",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),)),
                    _loginByFace(context),
                    _signup(context),
                    const SizedBox(height: 100,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _inputField(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.email)),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
              hintText: "Password",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withOpacity(0.1),
              filled: true,
              prefixIcon: const Icon(Icons.password)),
          obscureText: true,
        ),
      ],
    );
  }

  _loginByFace(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3, left: 3),
      child: ElevatedButton(
        onPressed: () {
          print("Login using face detection");
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FaceRecognition(),));
        },
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Theme.of(context)
              .colorScheme
              .secondary
              .withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 25.0,
              width: 25.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.face_retouching_natural_rounded),
            ),
            const SizedBox(width: 18),
            Text(
              "Login using your Face",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _forgotPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        context.read<AuthBloc>().add(ForgotPasswordRequested(_emailController.text));
      },
      child: Text(
        "Forgot password?",
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignupPage()),
            );
          },
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
