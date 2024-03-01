class EBloc {
  void on(Function(dynamic, void Function(dynamic)) call) {
    call(1, emit);
  }

  void emit(state) {}
}

class T extends EBloc {
  void a() {
    emit(1);
  }
}
