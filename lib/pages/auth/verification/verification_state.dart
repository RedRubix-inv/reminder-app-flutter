// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:reminder_app/components/show_toast.dart';
// import 'package:reminder_app/utils/router.dart';
// import 'package:state_view/state_view.dart';
// import 'package:toastification/toastification.dart';

// import 'verification_events.dart';
// import 'verification_view.dart';

// export 'verification_events.dart';

// enum PageType { passwordChange, verifyOTP }

// class Verification extends StateView<VerificationState> {
//   String contact;
//   PageType pageType;

//   Verification({
//     super.key,
//     required this.contact,
//     this.pageType = PageType.passwordChange,
//   }) : super(
//          stateBuilder: (context) => VerificationState(context),
//          view: const VerificationView(),
//        );
// }

// class VerificationState extends StateProvider<Verification, VerificationEvent> {
//   late AuthService _authService;

//   VerificationState(super.context) {
//     _contact = widget.contact;
//     startTimer();
//     _authService = AuthService();
//   }

//   late String _contact;

//   String get contact => _contact;

//   String? _otp;

//   Timer? _timer;
//   int _remainingSeconds = 60;
//   bool _canResend = false;

//   int get remainingSeconds => _remainingSeconds;

//   bool get canResend => _canResend;

//   bool _isLoading = false;

//   bool get isLoading => _isLoading;

//   void startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_remainingSeconds > 0) {
//         _remainingSeconds--;
//       } else {
//         _canResend = true;
//         timer.cancel();
//       }
//       notifyListeners();
//     });
//   }

//   void resendOTP() async {
//     _remainingSeconds = 60;
//     _canResend = false;

//     if (widget.pageType == PageType.passwordChange) {
//       await _authService.forgotPassword(_contact);
//       showToast(
//         context,
//         title: "OTP Sent",
//         description: "OTP Sent Successfully",
//         type: ToastificationType.success,
//       );
//     } else {
//       //TODO: Handle Verification Resent OTP
//     }
//     startTimer();
//     notifyListeners();
//     // Add your resend OTP logic here
//   }

//   @override
//   void onEvent(VerificationEvent event) {
//     if (event is OnOTPChanged) {
//       _otp = event.verificationCode;
//       notifyListeners();
//       return;
//     }

//     if (event is OnVerifyTap) {
//       _handleVerify();
//       return;
//     }
//     return;
//   }

//   void setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   Future<void> _handleVerify() async {
//     if (_otp == null || _otp!.isEmpty) {
//       showToast(
//         context,
//         title: "Please enter OTP ",
//         description: "OTP is required",
//         type: ToastificationType.info,
//       );
//       return;
//     }

//     setLoading(true);
//     if (widget.pageType == PageType.passwordChange) {
//       final response = await _authService.verifyOTPForgotPassword(
//         contact,
//         _otp!,
//       );

//       if (response is SuccessResponse && response.statusCode == 201) {
//         showToast(
//           context,
//           title: "OTP Verified",
//           description: "OTP Verified Successfully",
//           type: ToastificationType.success,
//         );

//         GoRouter.of(
//           context,
//         ).pushReplacement(RouteName.resetPassword, extra: contact);
//       } else {
//         showToast(
//           context,
//           title: "OTP Verification Failed",
//           description: "Please enter correct OTP",
//           type: ToastificationType.error,
//         );
//       }
//     } else {
//       final response = await _authService.verifyOTP(_contact, _otp!);

//       if (response is SuccessResponse && response.statusCode == 201) {
//         showToast(
//           context,
//           title: "OTP Verified",
//           description: response.data['message'],
//           type: ToastificationType.success,
//         );

//         GoRouter.of(context).pushReplacement(RouteName.login);
//       } else if (response is ErrorResponse) {
//         showToast(
//           context,
//           title: "OTP Verification Failed",
//           description: response.data['message'],
//           type: ToastificationType.error,
//         );
//       } else {
//         showToast(
//           context,
//           title: "Something went wrong",
//           description: "Please try again later",
//           type: ToastificationType.error,
//         );
//       }
//     }
//     setLoading(false);
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
// }
