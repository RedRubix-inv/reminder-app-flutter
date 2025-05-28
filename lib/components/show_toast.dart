import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

ToastificationItem showToast(
  BuildContext context, {
  ToastificationType type = ToastificationType.success,
  String title = "Title",
  String description = "Description",
  Duration? duration,
}) {
  return toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.flat,
    title: Text(title),
    description: Text(description),
    alignment: Alignment.topCenter,
    autoCloseDuration: duration ?? const Duration(seconds: 6),
    borderRadius: BorderRadius.circular(10),
    showProgressBar: true,
    dragToClose: true,
    pauseOnHover: false,
  );
}
