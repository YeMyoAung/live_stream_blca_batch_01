abstract class LoginEvent {
  const LoginEvent();
}

class LoginWithGoogleEvent extends LoginEvent {
  const LoginWithGoogleEvent();
}

class LoginWithFacebookEvent extends LoginEvent {
  const LoginWithFacebookEvent();
}
