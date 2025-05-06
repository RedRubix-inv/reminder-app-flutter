// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:provider/provider.dart';
// import 'package:reminder_app/components/button.dart';
// import 'package:reminder_app/utils/theme.dart';

// import '../../components/appbar_backbutton.dart';
// import '../../utils/spacing.dart';
// import 'verification_state.dart';

// class VerificationView extends StatelessWidget {
//   const VerificationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final state = context.watch<VerificationState>();
//     // return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(leading: appBarBackButton(context)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Image.asset("assets/image/verification.png", scale: 4),
//               const VerticalSpace(40),
//               Text(
//                 "Verification",
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
//               ),
//               const VerticalSpace(10),
//               RichText(
//                 text: TextSpan(
//                   style: Theme.of(context).textTheme.bodyMedium,
//                   children: [
//                     const TextSpan(
//                       text: "We have sent a code to ",
//                       style: TextStyle(
//                         color: textColorSecondary,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "+977 ${state.contact}",
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               ),
//               const VerticalSpace(30),
//               OtpTextField(
//                 filled: true,
//                 numberOfFields: 4,
//                 borderRadius: BorderRadius.circular(10),

//                 cursorColor: primaryColor,
//                 focusedBorderColor: primaryColor,

//                 enabledBorderColor: primaryColor,
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: textColor,
//                 ),

//                 keyboardType: TextInputType.number,
//                 showFieldAsBox: true,
//                 onSubmit: (String verificationCode) {
//                   state.onEvent(OnOTPChanged(verificationCode));
//                 }, // end onSubmit
//               ),
//               const VerticalSpace(20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (!state.canResend) ...[
//                     const Text(
//                       'Resend code in ',
//                       style: TextStyle(
//                         color: textColorSecondary,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15,
//                       ),
//                     ),
//                     Text(
//                       '${state.remainingSeconds}s',
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ] else
//                     TextButton(
//                       onPressed: () {
//                         state.resendOTP();
//                       },
//                       child: Text(
//                         'Resend OTP',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//               const VerticalSpace(20),
//               Hero(
//                 tag: "forgotpassword",
//                 child: SizedBox(
//                   width: getScreenWidth(context) * 1,
//                   child: CustomButton(
//                     title: "Verify",
//                     onPressed: () {},
//                     isLoading: false,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     )
//   }
// }
