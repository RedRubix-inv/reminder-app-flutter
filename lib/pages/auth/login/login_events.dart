abstract class LoginEvent {}

class OnEmailChanged extends LoginEvent {
  final String email;
  OnEmailChanged(this.email);
}

class OnPasswordChanged extends LoginEvent {
  final String password;
  OnPasswordChanged(this.password);
}

class OnLogin extends LoginEvent {}

class OnGoogleSignIn extends LoginEvent {}

class OnForgotPassword extends LoginEvent {}

class OnSignUp extends LoginEvent {}
