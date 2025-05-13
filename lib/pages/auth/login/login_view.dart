import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/pages/auth/login/login_state.dart';
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginState>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: state.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VerticalSpace(10),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Text(
                        "Welcome Back",
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
                  const VerticalSpace(10),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
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
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AppTextField(
                        hintText: "Email",
                        labelText: "Email",
                        prefixIcon: const Icon(LucideIcons.mail),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: state.onEmailChanged,
                        validator: validateEmail,
                      ),
                    ),
                  ),
                  const VerticalSpace(20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AppTextField(
                        hintText: "Password",
                        labelText: "Password",
                        maxLines: 1,
                        prefixIcon: const Icon(LucideIcons.lock),
                        isPassword: true,
                        onChanged: state.onPasswordChanged,
                        validator: validatePassword,
                      ),
                    ),
                  ),
                  const VerticalSpace(8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextButton(
                          onPressed: state.isLoading ? null : () {},
                          // : () => state.handleForgotPassword(context),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: textColor,
                              fontFamily: "Sora",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: CustomButton(
                        title: "Sign In",
                        isLoading: state.isLoading,
                        onPressed:
                            state.isLoading
                                ? null
                                : () => state.handleLogin(context),
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
                      child: OutlinedButton.icon(
                        onPressed: state.isLoading ? null : () {},
                        // : () => state.handleGoogleSignIn(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: primaryColor.withOpacity(0.5),
                          ),
                        ),
                        icon: Image.network(
                          'https://www.google.com/favicon.ico',
                          width: 24,
                          height: 24,
                        ),
                        label: Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: textColor,
                            fontFamily: "Sora",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpace(20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
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
                            onTap: () => state.handleSignUp(context),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Sora",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
