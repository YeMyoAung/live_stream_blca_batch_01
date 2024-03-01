import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_bloc.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/guest/live_stream_guest_bloc.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_cubit.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/agora/impl/agora_guest_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_guest_service.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_host_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';
import 'package:live_stream/views/screens/auth/auth_screen.dart';
import 'package:live_stream/views/screens/home/home_screen.dart';
import 'package:live_stream/views/screens/live_stream/live_stream_screen.dart';
import 'package:live_stream/views/screens/post_create/post_create_screen.dart';
import 'package:live_stream/views/screens/settings/profile_setting_screen.dart';
import 'package:live_stream/views/screens/settings/setting_screen.dart';

LiveStreamHostBloc _findHostBloc() {
  final isRegistered = locator.isRegistered<LiveStreamHostBloc>();
  if (isRegistered) {
    locator.resetLazySingleton<LiveStreamHostBloc>(
      disposingFunction: (bloc) {
        return bloc.close();
      },
    );
  } else {
    locator.registerLazySingleton(
      () => LiveStreamHostBloc(
        LiveStreamHostService(),
        locator<AgoraHostService>(),
      ),
    );
  }

  return locator<LiveStreamHostBloc>();
}

Route<dynamic>? router(RouteSettings settings) {
  final isGuest = locator<AuthService>().currentUser == null;
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
    case RouteNames.profileSetting:
      return _routeBuilder(
        const ProfileSettingScreen(),
        settings,
      );
    case RouteNames.setting:
      return _routeBuilder(
        const SettingScreen(),
        settings,
      );
    case RouteNames.home:
      return _routeBuilder(
        _buildHomePage(),
        settings,
      );
    case RouteNames.postCreate:
      return _routeBuilder(
        BlocProvider.value(
          value: _findHostBloc(),
          child: const PostCreateScreen(),
        ),
        settings,
      );
    case RouteNames.host:
      // final value = settings.arguments;
      // if (value is! LiveStreamHostBloc) {
      //   return _routeBuilder(
      //     const BadRequest(),
      //     settings,
      //   );
      // }

      if (!locator.isRegistered<LiveStreamHostBloc>()) {
        return _routeBuilder(const BadRequest(), settings);
      }
      final value = locator<LiveStreamHostBloc>();
      return _routeBuilder(
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LiveViewCubit()),
            BlocProvider.value(value: value),
          ],
          child: const LiveStreamScreen<LiveStreamHostBloc>(),
        ),
        settings,
      );
    case RouteNames.view:
      final value = settings.arguments;
      if (value is! LivePayload) {
        return _routeBuilder(
          const BadRequest(),
          settings,
        );
      }
      return _routeBuilder(
        MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => LiveViewCubit(),
            ),
            BlocProvider(
              create: (_) => LiveStreamGuestBloc(
                value,
                LiveStreamGuestService(),
                locator<AgoraGuestService>(),
              ),
            )
          ],
          child: const LiveStreamScreen<LiveStreamGuestBloc>(),
        ),
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
      ),
      BlocProvider(
        create: (_) => MyPostBloc(),
      ),
      BlocProvider(
        create: (_) => SearchBloc(locator<SearchPostService>()),
      )
    ],
    child: const HomeScreen(),
  );
}

Route _routeBuilder(Widget screen, RouteSettings settings) {
  return CupertinoPageRoute(builder: (_) => screen, settings: settings);
}

class BadRequest extends StatelessWidget {
  const BadRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Bad Request"),
      ),
    );
  }
}
