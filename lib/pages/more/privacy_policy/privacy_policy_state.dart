import 'package:flutter/material.dart';
import 'package:state_view/state_view.dart';
import 'privacy_policy_view.dart';
import 'privacy_policy_events.dart';
export 'privacy_policy_events.dart';

class PrivacyPolicy extends StateView<PrivacyPolicyState> {
  PrivacyPolicy({Key? key})
      : super(
          key: key,
          stateBuilder: (context) => PrivacyPolicyState(context),
          view: PrivacyPolicyView(),
        );
}

class PrivacyPolicyState extends StateProvider<PrivacyPolicy, PrivacyPolicyEvent> {
  PrivacyPolicyState(super.context);
  @override
  void onEvent(PrivacyPolicyEvent event) {
    return;
  }
}
