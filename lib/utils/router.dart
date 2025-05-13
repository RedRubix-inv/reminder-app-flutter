import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/models/team.dart';
// import 'package:reminder_app/pages/auth/forgot_password_page.dart';
import 'package:reminder_app/pages/auth/login/login_state.dart';
import 'package:reminder_app/pages/auth/login/login_view.dart';
import 'package:reminder_app/pages/auth/sign_up/sign_up_state.dart';
import 'package:reminder_app/pages/auth/sign_up/sign_up_view.dart';
import 'package:reminder_app/pages/calendar/calendar_view.dart';
import 'package:reminder_app/pages/home/components/meeting/create_meeting_view.dart';
import 'package:reminder_app/pages/home/components/reminder/create_reminder_view.dart';
import 'package:reminder_app/pages/home/home_view.dart';
import 'package:reminder_app/pages/notification/notification_view.dart';
import 'package:reminder_app/pages/profile/profile_view.dart';
import 'package:reminder_app/pages/tasks/tasks_view.dart';
import 'package:reminder_app/pages/teams/components/team_management.dart';
import 'package:reminder_app/pages/teams/teams_view.dart';
import 'package:reminder_app/pages/test/test_view.dart';
import 'package:reminder_app/services/app_state_service.dart';
import 'package:reminder_app/services/auth_service.dart';
import 'package:reminder_app/utils/theme.dart';

import '../pages/onboarding/onboarding_state.dart';

class RouteName {
  static const String splashScreen = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String onBoarding = '/onboarding';
  static const String home = '/home';
  static const String tasks = '/tasks';
  static const String teams = '/teams';
  static const String calendar = '/calendar';
  static const String profile = '/profile';
  static const String createMeeting = '/create-meeting';
  static const String createReminder = '/create-reminder';
  static const String teamManagement = '/team-management';
  static const String notifications = '/notifications';
  static const String test = '/test';
}

final router = GoRouter(
  initialLocation: RouteName.login,
  redirect: (context, state) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = authService.currentUser != null;
    final isAuthRoute =
        state.matchedLocation == RouteName.login ||
        state.matchedLocation == RouteName.signUp ||
        state.matchedLocation == RouteName.forgotPassword;
    final isOnboardingRoute = state.matchedLocation == RouteName.onBoarding;

    // Check if it's first launch
    final isFirstLaunch = await AppStateService.isFirstLaunch();

    debugPrint(
      'Router redirect - isLoggedIn: $isLoggedIn, isAuthRoute: $isAuthRoute, path: ${state.matchedLocation}, isFirstLaunch: $isFirstLaunch',
    );

    // Show onboarding for first launch
    if (isFirstLaunch && !isOnboardingRoute) {
      debugPrint('Redirecting to onboarding - first launch');
      return RouteName.onBoarding;
    }

    if (!isLoggedIn && !isAuthRoute && !isOnboardingRoute) {
      debugPrint('Redirecting to login - user not authenticated');
      return RouteName.login;
    }

    if (isLoggedIn && isAuthRoute) {
      debugPrint('Redirecting to home - user already authenticated');
      return RouteName.home;
    }

    debugPrint('No redirect needed');
    return null;
  },
  routes: [
    GoRoute(
      path: RouteName.login,
      builder:
          (context, state) => ChangeNotifierProvider(
            create:
                (context) => LoginState(
                  Provider.of<AuthService>(context, listen: false),
                ),
            child: const LoginView(),
          ),
    ),
    GoRoute(
      path: RouteName.signUp,
      builder:
          (context, state) => ChangeNotifierProvider(
            create:
                (context) => SignUpState(
                  Provider.of<AuthService>(context, listen: false),
                ),
            child: const SignUpView(),
          ),
    ),
    // GoRoute(
    //   path: RouteName.forgotPassword,
    //   builder: (context, state) => const ForgotPasswordPage(),
    // ),
    GoRoute(
      path: RouteName.onBoarding,
      builder: (context, state) => Onboarding(),
    ),
    GoRoute(
      path: RouteName.createMeeting,
      builder: (context, state) => const CreateMeetingView(),
    ),
    GoRoute(
      path: RouteName.teamManagement,
      builder: (context, state) {
        final team = state.extra as Team;
        return TeamManagementView(team: team);
      },
    ),
    GoRoute(
      path: RouteName.notifications,
      builder: (context, state) => const NotificationView(),
    ),
    GoRoute(
      path: RouteName.createReminder,
      builder: (context, state) => const CreateReminderView(),
    ),
    GoRoute(
      path: RouteName.test,
      builder: (context, state) => const TestView(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: secondaryColor.withOpacity(0.8),
            buttonBackgroundColor: secondaryColor.withOpacity(0.8),
            height: 60,
            animationDuration: const Duration(milliseconds: 500),
            animationCurve: Curves.easeInOutCubicEmphasized,
            index: _calculateSelectedIndex(state),
            items: const [
              Icon(LucideIcons.clipboardList, size: 28, color: Colors.white),
              Icon(LucideIcons.users2, size: 28, color: Colors.white),
              Icon(LucideIcons.bellPlus, size: 28, color: Colors.white),
              Icon(LucideIcons.calendar, size: 28, color: Colors.white),
              Icon(LucideIcons.user2, size: 28, color: Colors.white),
            ],
            onTap: (index) {
              _onItemTapped(index, context);
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: RouteName.home,
          builder: (context, state) => const HomeView(),
        ),
        GoRoute(
          path: RouteName.tasks,
          builder: (context, state) => const TasksView(),
        ),
        GoRoute(
          path: RouteName.teams,
          builder: (context, state) => const TeamsView(),
        ),
        GoRoute(
          path: RouteName.calendar,
          builder: (context, state) => const CalendarView(),
        ),
        GoRoute(
          path: RouteName.profile,
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
);

int _calculateSelectedIndex(GoRouterState state) {
  final String location = state.uri.path;
  if (location.startsWith(RouteName.tasks)) return 0;
  if (location.startsWith(RouteName.teams)) return 1;
  if (location.startsWith(RouteName.home)) return 2;
  if (location.startsWith(RouteName.calendar)) return 3;
  if (location.startsWith(RouteName.profile)) return 4;
  return 2;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go(RouteName.tasks);
      break;
    case 1:
      context.go(RouteName.teams);
      break;
    case 2:
      context.go(RouteName.home);
      break;
    case 3:
      context.go(RouteName.calendar);
      break;
    case 4:
      context.go(RouteName.profile);
      break;
  }
}
