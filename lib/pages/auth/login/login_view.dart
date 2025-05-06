import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/utils/router.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:reminder_app/utils/validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      _controller.reset();
      _controller.forward();
    });
  }

  void handleAuth() {
    // TODO: Implement authentication logic
    print('Email: $email, Password: $password');
    GoRouter.of(context).push(RouteName.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VerticalSpace(40),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: "Sora",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const VerticalSpace(40),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "Sign in to continue",

                      style: TextStyle(
                        fontSize: 18,
                        color: textColorSecondary,
                        fontFamily: "Sora",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const VerticalSpace(40),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: AppTextField(
                      hintText: "Email",
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                      validator: validateEmail,
                    ),
                  ),
                ),
                const VerticalSpace(20),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: AppTextField(
                      hintText: "Password",
                      labelText: "Password",
                      maxLines: 1,
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      validator: validatePassword,
                    ),
                  ),
                ),

                const VerticalSpace(40),

                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: CustomButton(
                      title: "Sign In",
                      onPressed: () {
                        handleAuth();
                      },
                    ),
                  ),
                ),

                const VerticalSpace(20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: textColorSecondary.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            "or",
                            style: TextStyle(
                              color: textColorSecondary,
                              fontFamily: "Sora",
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: textColorSecondary.withOpacity(0.3),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: OutlinedButton(
                      onPressed: () {
                        print('Continue with Google pressed');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: textColorSecondary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google_logo.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Sora",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const VerticalSpace(20),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",

                          style: TextStyle(
                            color: textColorSecondary,
                            fontFamily: "Sora",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).push(RouteName.signUp);
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Sora",
                            ),
                          ),
                        ),
                        // CustomButton(
                        //   title: "Sign Up",
                        //   onPressed: () {
                        //     GoRouter.of(context).push(RouteName.signUp);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
