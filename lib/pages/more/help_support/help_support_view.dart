import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'help_support_state.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final state = context.watch<HelpSupportState>();
    return Scaffold(
      body: Center(
        child: const Placeholder(),
      ),
    );
  }
}
