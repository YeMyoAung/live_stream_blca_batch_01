import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_state.dart';

class LiveViewCubit extends Cubit<LiveViewState> {
  LiveViewCubit() : super(const MinimizedLiveViewState());

  void toggle() {
    emit(
      state is MinimizedLiveViewState
          ? const FullScreenLiveViewState()
          : const MinimizedLiveViewState(),
    );
  }
}
