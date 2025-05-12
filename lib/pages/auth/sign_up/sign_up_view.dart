import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/components/app_textfield.dart';
import 'package:reminder_app/components/button.dart';
import 'package:reminder_app/pages/auth/sign_up/sign_up_state.dart';
import 'package:reminder_app/utils/spacing.dart';
import 'package:reminder_app/utils/theme.dart';
import 'package:reminder_app/utils/validators.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView>
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
    final state = context.watch<SignUpState>();

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
                        "Create Account",
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
                        "Sign up to get started",
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
                        hintText: "Full Name",
                        labelText: "Full Name",
                        prefixIcon: const Icon(Icons.person_outline),
                        keyboardType: TextInputType.name,
                        onChanged: state.onFullNameChanged,
                        validator: validateFullName,
                      ),
                    ),
                  ),
                  const VerticalSpace(20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AppTextField(
                        hintText: "Email",
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
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
                        prefixIcon: const Icon(Icons.lock_outline),
                        isPassword: true,
                        onChanged: state.onPasswordChanged,
                        validator: validatePassword,
                      ),
                    ),
                  ),
                  const VerticalSpace(20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: AppTextField(
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        maxLines: 1,
                        prefixIcon: const Icon(Icons.lock_outline),
                        isPassword: true,
                        onChanged: state.onConfirmPasswordChanged,
                        validator:
                            (value) =>
                                validateConfirmPassword(value, state.password),
                      ),
                    ),
                  ),
                  const VerticalSpace(40),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: CustomButton(
                        title: "Sign Up",
                        isLoading: state.isLoading,
                        onPressed:
                            state.isLoading
                                ? null
                                : () => state.handleSignUp(context),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: textColorSecondary,
                              fontFamily: "Sora",
                            ),
                          ),
                          GestureDetector(
                            onTap: () => state.handleLogin(context),
                            child: Text(
                              "Sign In",
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
