import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'security_state.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SecurityState>();
    return Scaffold(
      body: Center(
        child: const Placeholder(),
      ),
    );
  }
}
