// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:reminder_app/components/app_textfield.dart';
// import 'package:reminder_app/components/appbar_backbutton.dart';
// import 'package:reminder_app/components/button.dart';

// import '../../utils/spacing.dart';
// import 'reset_password_state.dart';

// class ResetPasswordView extends StatelessWidget {
//   const ResetPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.read<ResetPasswordState>();
//     return Scaffold(
//       appBar: AppBar(leading: appBarBackButton(context)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Center(
//             child: Form(
//               key: state.formKey,
//               child: Column(
//                 children: [
//                   Image.asset("assets/image/reset_password.png", scale: 4),
//                   const VerticalSpace(40),
//                   Text(
//                     "Set a new password",
//                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const VerticalSpace(10),
//                   const Text("Password must be at least 8 characters"),
//                   const VerticalSpace(20),
//                   AppTextField(
//                     labelText: "Password",
//                     hintText: "Enter password",
//                     prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
//                     onChanged: (p0) {
//                       state.onEvent(OnPasswordChanged(p0));
//                     },
//                     isPassword: true,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Password cannot be empty";
//                       }
//                       return null;
//                     },
//                   ),
//                   const VerticalSpace(20),
//                   AppTextField(
//                     labelText: "Confirm Password",
//                     hintText: "Reenter your password",
//                     prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
//                     onChanged: (p0) {
//                       state.onEvent(OnConfirmPasswordChanged(p0));
//                     },
//                     isPassword: true,
//                     validator: (value) {
//                       if (value!.isEmpty) {
//                         return "Password cannot be empty";
//                       }
//                       if (state.password != null && value != state.password) {
//                         return "Password does not match";
//                       }
//                       return null;
//                     },
//                   ),
//                   const VerticalSpace(40),
//                   Hero(
//                     tag: "forgotpassword",
//                     child: SizedBox(
//                       width: getScreenWidth(context) * 1,
//                       child: reminder_appButton(
//                         title: "Change Password",
//                         isLoading: state.loading,
//                         onPressed: () {
//                           state.onEvent(OnResetPasswordTap());
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
