import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace(this.width, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace(this.height, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class MQWidth extends StatelessWidget {
  final double width;
  const MQWidth({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.width * width);
  }
}

class MQHeight extends StatelessWidget {
  final double height;
  const MQHeight({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * height);
  }
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
