import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Services/auth_service.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<EmailVerificationRequested>(_onEmailVerificationRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);

    _authService.userChanges.listen((user) {
      add(AuthStatusChanged(user));
    });
  }

  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signUpWithEmail(event.email, event.password);
      if (user != null) {
        add(EmailVerificationRequested());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authService.signInWithEmail(event.email, event.password);
      if (user != null) {
        if (user.emailVerified) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Email is not verified. Please verify your email before signing in."));
        }
      } else {
        emit(AuthError("Sign-in failed. Please try again."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    try {
      final user = await _authService.handleGoogleSignIn();
      if (user != null && user.emailVerified) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError("Google sign-in successful, but email is not verified. Please verify your email."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    await _authService.signOut();
    emit(AuthUnauthenticated());
  }

  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.user != null && event.user!.emailVerified) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onEmailVerificationRequested(EmailVerificationRequested event, Emitter<AuthState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        emit(AuthVerificationEmailSent());
      } else {
        emit(AuthError("Unable to send verification email."));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    try {
      await _authService.sendPasswordResetEmail(event.email);
      emit(AuthPasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}