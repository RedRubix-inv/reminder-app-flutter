import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/utils/theme.dart';

Widget appBarBackButton(BuildContext context, {void Function()? onPressed}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed ?? () => GoRouter.of(context).pop(),
      child: Icon(CupertinoIcons.back, color: textColor, size: 24),
    ),
  );
}
