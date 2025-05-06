import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reminder_app/utils/theme.dart';

Widget appBarBackButton(BuildContext context, {void Function()? onPressed}) {
  return Container(
    margin: const EdgeInsets.all(10),
    child: IconButton(
      icon: const Icon(CupertinoIcons.back),
      color: textColor,
      onPressed:
          onPressed ??
          () {
            GoRouter.of(context).pop();
          },
    ),
  );
}
