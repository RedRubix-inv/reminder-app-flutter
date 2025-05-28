import 'package:flutter/material.dart';
import 'package:state_view/state_view.dart';
import 'help_support_view.dart';
import 'help_support_events.dart';
export 'help_support_events.dart';

class HelpSupport extends StateView<HelpSupportState> {
  HelpSupport({Key? key})
      : super(
          key: key,
          stateBuilder: (context) => HelpSupportState(context),
          view: HelpSupportView(),
        );
}

class HelpSupportState extends StateProvider<HelpSupport, HelpSupportEvent> {
  HelpSupportState(super.context);
  @override
  void onEvent(HelpSupportEvent event) {
    return;
  }
}
