abstract class HomePageEvent {
  const HomePageEvent();
}

class GoToHomePageEvent extends HomePageEvent {
  const GoToHomePageEvent();
}

class GoToSearchPageEvent extends HomePageEvent {
  const GoToSearchPageEvent();
}

class GoToProfilePageEvent extends HomePageEvent {
  const GoToProfilePageEvent();
}

class OnScrollEvent extends HomePageEvent {
  final int index;

  const OnScrollEvent(this.index);
}
