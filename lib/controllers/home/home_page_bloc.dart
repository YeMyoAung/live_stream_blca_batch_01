import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/home/home_page_event.dart';

class HomePageBloc extends Bloc<HomePageEvent, int> {
  final PageController controller;
  static const Duration _duration = Duration(milliseconds: 300);
  static const Curve _curve = Curves.linear;

  void _goTo(int index, Emitter<int> emit) {
    emit(index);
    controller.animateToPage(
      index,
      duration: _duration,
      curve: _curve,
    );
  }

  HomePageBloc()
      : controller = PageController(),
        super(0) {
    on<GoToHomePageEvent>((_, emit) {
      _goTo(0, emit);
    });

    on<GoToSearchPageEvent>((_, emit) {
      _goTo(1, emit);
    });

    on<GoToProfilePageEvent>((_, emit) {
      _goTo(2, emit);
    });

    on<OnScrollEvent>((event, emit) {
      _goTo(event.index, emit);
    });
  }

  HomePageEvent active(int value) {
    switch (value) {
      case 0:
        return const GoToHomePageEvent();
      case 1:
        return const GoToSearchPageEvent();
      default:
        return const GoToProfilePageEvent();
    }
  }

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
