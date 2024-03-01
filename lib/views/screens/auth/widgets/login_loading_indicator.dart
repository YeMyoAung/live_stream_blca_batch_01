import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/auth_bloc/auth_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_state.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LoginLoadingIndicator extends StatelessWidget {
  const LoginLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = context.height;
    return BlocConsumer<AuthBloc, LoginState>(
      listener: (_, state) {
        if (state is! LoginSuccessState && state is! LoginErrorState) {
          return;
        }
        if (state is LoginErrorState) {
          Fluttertoast.showToast(msg: state.message ?? "Unknown");
          return;
        }
        StarlightUtils.pushReplacementNamed(RouteNames.home);
      },
      builder: (_, state) {
        if (state is LoginLoadingState) {
          return Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color.fromARGB(20, 29, 27, 27),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
