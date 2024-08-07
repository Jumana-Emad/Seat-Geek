part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}
class GoogleSignInRequested extends AuthEvent {}
class SignOutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final User? user;

  AuthStatusChanged(this.user);
}
