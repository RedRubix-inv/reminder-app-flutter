// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:reminder_app/components/show_toast.dart';
// import 'package:reminder_app/pages/verification/verification_state.dart';
// import 'package:reminder_app/services/api-service/auth_service.dart';
// import 'package:reminder_app/services/api-service/base_http_service.dart';
// import 'package:reminder_app/utils/router.dart';
// import 'package:state_view/state_view.dart';
// import 'package:toastification/toastification.dart';

// import 'sign_up_events.dart';
// import 'sign_up_view.dart';

// export 'sign_up_events.dart';

// class SignUp extends StateView<SignUpState> {
//   SignUp({super.key})
//     : super(
//         stateBuilder: (context) => SignUpState(context),
//         view: const SignUpView(),
//       );
// }

// class SignUpState extends StateProvider<SignUp, SignUpEvent> {
//   late AuthService _authService;

//   SignUpState(super.context) {
//     _authService = AuthService();
//   }

//   final formKey = GlobalKey<FormState>();

//   String? _email;

//   String? get email => _email;

//   String? _fullName;

//   String? get fullName => _fullName;

//   String? _contact;

//   String? get contact => _contact;

//   String? _address;

//   String? get address => _address;

//   String? _confirmPassword;

//   String? get confirmPassword => _confirmPassword;

//   String? _password;

//   String? get password => _password;

//   bool registerLoading = false;

//   bool get isLoading => registerLoading;

//   @override
//   void onEvent(SignUpEvent event) {
//     if (event is OnEmailChanged) {
//       _email = event.email;
//       notifyListeners();
//       return;
//     }

//     if (event is OnFullNameChanged) {
//       _fullName = event.fullName;
//       notifyListeners();
//       return;
//     }

//     if (event is OnContactChanged) {
//       _contact = event.contact;
//       notifyListeners();
//       return;
//     }

//     if (event is OnAddressChanged) {
//       _address = event.address;
//       notifyListeners();
//       return;
//     }

//     if (event is OnPasswordChanged) {
//       _password = event.password;
//       notifyListeners();
//       return;
//     }

//     if (event is OnConfirmPasswordChanged) {
//       _confirmPassword = event.confirmPassword;
//       notifyListeners();
//       return;
//     }

//     if (event is OnSignUp) {
//       _handleSignUp();
//       return;
//     }

//     if (event is OnLogin) {
//       GoRouter.of(context).pop();
//     }

//     return;
//   }

//   void setRegisterLoading(bool value) {
//     registerLoading = value;
//     notifyListeners();
//   }

//   Future<void> _handleSignUp() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }

//     setRegisterLoading(true);

//     final result = await _authService.register(
//       name: _fullName!,
//       email: _email ?? "",
//       password: _password!,
//       phone: _contact!,
//       address: _address!,
//     );

//     setRegisterLoading(false);

//     if (result is SuccessResponse && result.statusCode == 201) {
//       //TODO: Navigate to verification Page
//       showToast(
//         context,
//         title: "Success",
//         description: result.data["message"],
//         type: ToastificationType.success,
//       );

//       GoRouter.of(context).pushReplacement(
//         RouteName.verification,
//         extra: {"contact": _contact, "pageType": PageType.verifyOTP},
//       );
//     } else {
//       showToast(
//         context,
//         title: "Oops!!",
//         description: result.data["message"] ?? "Something went wrong",
//         type: ToastificationType.error,
//       );
//     }
//   }
// }
