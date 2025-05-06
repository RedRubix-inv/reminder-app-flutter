// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:reminder_app/components/show_toast.dart';
// import 'package:reminder_app/services/api-service/auth_service.dart';
// import 'package:reminder_app/services/api-service/base_http_service.dart';
// import 'package:state_view/state_view.dart';
// import 'package:toastification/toastification.dart';

// import '../../utils/router.dart';
// import 'reset_password_events.dart';
// import 'reset_password_view.dart';

// export 'reset_password_events.dart';

// class ResetPassword extends StateView<ResetPasswordState> {
//   String contact;

//   ResetPassword({super.key, required this.contact})
//     : super(
//         stateBuilder: (context) => ResetPasswordState(context),
//         view: const ResetPasswordView(),
//       );
// }

// class ResetPasswordState
//     extends StateProvider<ResetPassword, ResetPasswordEvent> {
//   late AuthService _authService;

//   ResetPasswordState(super.context) {
//     _authService = AuthService();
//   }

//   final formKey = GlobalKey<FormState>();

//   String? _password;

//   String? get password => _password;

//   String? _confirmPassword;

//   bool _loading = false;

//   bool get loading => _loading;

//   @override
//   void onEvent(ResetPasswordEvent event) {
//     if (event is OnConfirmPasswordChanged) {
//       _confirmPassword = event.confirmPassword;
//       notifyListeners();
//     }

//     if (event is OnPasswordChanged) {
//       _password = event.password;
//       notifyListeners();
//     }

//     if (event is OnResetPasswordTap) {
//       _handleResetPassword();
//       return;
//     }
//     return;
//   }

//   Future<void> _handleResetPassword() async {
//     if (!formKey.currentState!.validate()) {
//       showToast(
//         context,
//         type: ToastificationType.info,
//         title: "Empty Fields",
//         description: "Please fill all fields",
//       );
//       return;
//     }

//     setLoading(true);
//     final response = await _authService.resetPassword(
//       widget.contact,
//       _password!,
//     );

//     if (response is SuccessResponse && response.statusCode == 201) {
//       showToast(
//         context,
//         title: "Password Reset",
//         description: response.data['message'],
//       );
//       GoRouter.of(context).go(RouteName.login);
//     } else if (response is ErrorResponse) {
//       showToast(
//         context,
//         title: "Password Reset Failed",
//         description: response.data['message'],
//         type: ToastificationType.error,
//       );
//     } else {
//       showToast(
//         context,
//         title: "Something went wrong",
//         description: "Please try again",
//         type: ToastificationType.error,
//       );
//     }
//     setLoading(true);
//   }

//   void setLoading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }
// }
