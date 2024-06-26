// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onPressed;
  final Widget? action;
  final Widget? leadAction;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.onPressed,
      this.action,
      this.leadAction});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      title: SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              'assets/images/skor_logo.png',
            ),
          )),
      backgroundColor: Theme.of(context).primaryColor,
      actions: action != null ? [action!] : null,
      leading: leadAction,
    );
  }
}
