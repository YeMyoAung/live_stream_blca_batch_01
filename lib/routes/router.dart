import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_bloc.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/views/screens/auth/auth_screen.dart';
import 'package:live_stream/views/screens/home/home_screen.dart';

Route<dynamic>? router(RouteSettings settings) {
  final isGuest = Locator<AuthService>().currentUser == null;

  if (isGuest) {
    return _routeBuilder(
      BlocProvider(
        create: (_) => AuthBloc(),
        child: const AuthScreen(),
      ),
      settings,
    );
  }

  switch (settings.name) {
    case RouteNames.home:
      return _routeBuilder(
        _buildHomePage(),
        settings,
      );
    default:
      return _routeBuilder(
        _buildHomePage(),
        // LiveStreamScreen(service: Locator<AgoraHostService>()),
        RouteSettings(name: RouteNames.home, arguments: settings.name),
      );
  }
}

Widget _buildHomePage() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => HomePageBloc(),
      ),
      BlocProvider(
        create: (_) => PostBloc(),
      )
    ],
    child: const HomeScreen(),
  );
}

Route _routeBuilder(Widget screen, RouteSettings settings) {
  return CupertinoPageRoute(builder: (_) => screen, settings: settings);
}
