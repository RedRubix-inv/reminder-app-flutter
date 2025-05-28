import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/services/app_state_service.dart';
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
    if (event is OnSetPage) {
      pageController.animateToPage(
        event.page,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (event is OnFinalPage) {
      // Mark first launch complete and navigate to login
      AppStateService.setFirstLaunchComplete().then((_) {
        context.go(RouteName.signUp);
      });
    }
  }
}
