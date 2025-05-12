import 'package:flutter/material.dart';
import 'package:state_view/state_view.dart';
import 'test_view.dart';
import 'test_events.dart';
export 'test_events.dart';

class Test extends StateView<TestState> {
  Test({Key? key})
      : super(
          key: key,
          stateBuilder: (context) => TestState(context),
          view: TestView(),
        );
}

class TestState extends StateProvider<Test, TestEvent> {
  TestState(super.context);
  @override
  void onEvent(TestEvent event) {
    return;
  }
}
