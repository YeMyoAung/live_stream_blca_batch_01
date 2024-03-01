import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_event.dart';
import 'package:live_stream/controllers/auth_bloc/auth_state.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:logger/logger.dart';

class AuthBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService = locator<AuthService>();

  static final Logger _logger = Logger();

  AuthBloc() : super(const LoginInitialState()) {
    // Login With Google
    on<LoginWithGoogleEvent>(_loginWithGoogleEventHandler);

    // Login With Facebook
    on<LoginWithFacebookEvent>(_loginWithFacebookEventHandler);
  }

  Future<void> _loginWithGoogleEventHandler(
    LoginWithGoogleEvent _,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginLoadingState) return;
    emit(const LoginLoadingState());

    final result = await _authService.loginWithGoogle();

    if (result.hasError) {
      _logger.e(result.error?.stackTrace);
      emit(LoginErrorState(result.error?.message));
      return;
    }

    emit(const LoginSuccessState());
  }

  Future<void> _loginWithFacebookEventHandler(
    LoginWithFacebookEvent _,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginLoadingState) return;
    emit(const LoginLoadingState());

    final result = await _authService.loginWithFacebook();
    if (result.hasError) {
      _logger.e(result.error?.stackTrace);
      emit(LoginErrorState(result.error?.message));
      return;
    }

    emit(const LoginSuccessState());
  }
}
