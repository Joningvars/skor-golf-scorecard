import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onPressed;
  final Widget? action;
  final Widget? leadAction;

  const CustomAppBar(
      {Key? key,
      required this.title,
      this.onPressed,
      this.action,
      this.leadAction})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Color(0XFF3270A2),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      actions: action != null ? [action!] : null,
      leading: leadAction != null ? leadAction : null,
    );
  }
}
