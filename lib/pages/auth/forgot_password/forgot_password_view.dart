// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:reminder_app/components/button.dart';
// import 'package:reminder_app/utils/theme.dart';
// import 'package:reminder_app/utils/validators.dart';

// import '../../components/app_textfield.dart';
// import '../../components/appbar_backbutton.dart';
// import '../../utils/spacing.dart';
// import 'forgot_password_state.dart';

// class ForgotPasswordView extends StatelessWidget {
//   const ForgotPasswordView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.read<ForgotPasswordState>();
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(leading: appBarBackButton(context)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: state.formKey,
//             child: Column(
//               children: [
//                 Image.asset("assets/image/forgot_password.png", scale: 4),
//                 const VerticalSpace(30),
//                 const Text(
//                   "Forgot Password?",
//                   style: TextStyle(
//                     color: textColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const VerticalSpace(5),
//                 const Text(
//                   "No worries, enter your registered number we'll send you the code for reset",
//                   style: TextStyle(
//                     color: textColorSecondary,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const VerticalSpace(30),
//                 AppTextField(
//                   initialValue: state.contact,
//                   labelText: "Contact",
//                   hintText: "Enter your contact",
//                   onChanged: (value) {
//                     state.onEvent(OnContactChanged(value));
//                   },
//                   keyboardType: TextInputType.phone,
//                   prefixIcon: const Icon(CupertinoIcons.phone),
//                   validator: validateContact,
//                 ),
//                 const VerticalSpace(40),
//                 Hero(
//                   tag: "forgotpassword",
//                   child: SizedBox(
//                     width: getScreenWidth(context) * 1,
//                     child: CustomButton(
//                       title: "Send OTP",
//                       onPressed: () {},
//                       isLoading: false,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
