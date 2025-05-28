import 'package:flutter/material.dart';
import 'package:state_view/state_view.dart';
import 'security_view.dart';
import 'security_events.dart';
export 'security_events.dart';

class Security extends StateView<SecurityState> {
  Security({Key? key})
      : super(
          key: key,
          stateBuilder: (context) => SecurityState(context),
          view: SecurityView(),
        );
}

class SecurityState extends StateProvider<Security, SecurityEvent> {
  SecurityState(super.context);
  @override
  void onEvent(SecurityEvent event) {
    return;
  }
}
