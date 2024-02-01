import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/home/home_page_event.dart';

class HomePageBloc extends Bloc<HomePageEvent, int> {
  final PageController controller;
  static const Duration _duration = Duration(milliseconds: 300);
  static const Curve _curve = Curves.linear;

  void _goTo(int index) {
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
      emit(0);
      _goTo(0);
    });

    on<GoToSearchPageEvent>((_, emit) {
      emit(1);
      _goTo(1);
    });

    on<GoToProfilePageEvent>((_, emit) {
      emit(2);
      _goTo(2);
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
