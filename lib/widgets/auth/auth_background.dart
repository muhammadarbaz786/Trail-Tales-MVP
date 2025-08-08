// lib/widgets/auth/auth_background.dart
import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const AuthBackground({
    Key? key,
    required this.isDark,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
            Colors.black,
            Colors.grey[900]!,
            Colors.black,
          ]
              : [
            Colors.blue[50]!,
            Colors.white,
            Colors.blue[100]!,
          ],
        ),
      ),
      child: child,
    );
  }
}