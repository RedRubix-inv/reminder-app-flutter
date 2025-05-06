import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:state_view/state_view.dart';

import '../../utils/router.dart';
import 'onboarding_events.dart';
import 'onboarding_view.dart';

export 'onboarding_events.dart';

class Onboarding extends StateView<OnboardingState> {
  Onboarding({super.key})
    : super(
        stateBuilder: (context) => OnboardingState(context),
        view: OnboardingView(),
      );
}

class OnboardingState extends StateProvider<Onboarding, OnboardingEvent> {
  OnboardingState(super.context);

  final PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void onEvent(OnboardingEvent event) {
    if (event is OnFinalPage) {
      GoRouter.of(context).pushReplacement(RouteName.login);
      return;
    }

    if (event is OnSetPage) {
      pageController.animateToPage(
        event.page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      notifyListeners();
    }
    return;
  }
}
