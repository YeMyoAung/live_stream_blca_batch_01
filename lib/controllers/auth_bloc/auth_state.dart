abstract class LoginState {
  final String? message;
  const LoginState([this.message]);
}

class LoginInitialState extends LoginState {
  const LoginInitialState();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

class LoginErrorState extends LoginState {
  const LoginErrorState(super.message);
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState();
}
