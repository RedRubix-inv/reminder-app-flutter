abstract class OnboardingEvent {}

class OnExampleTap extends OnboardingEvent {}

class OnFinalPage extends OnboardingEvent {}

class OnSetPage extends OnboardingEvent {
  final int page;

  OnSetPage(this.page);
}
