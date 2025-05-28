import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'privacy_policy_state.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<PrivacyPolicyState>();
    return Scaffold(body: Center(child: const Text('Privacy Policy')));
  }
}
