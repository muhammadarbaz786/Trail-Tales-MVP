// lib/widgets/auth/auth_header.dart
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        _buildIcon(isDark),
        const SizedBox(height: 24),
        _buildTitle(theme, isDark),
        const SizedBox(height: 8),
        _buildSubtitle(theme, isDark),
      ],
    );
  }

  Widget _buildIcon(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.blue[400]!, Colors.blue[600]!]
              : [Colors.blue[300]!, Colors.blue[500]!],
        ),
      ),
      child: Icon(
        icon,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, bool isDark) {
    return Text(
      title,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.grey[800],
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme, bool isDark) {
    return Text(
      subtitle,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: isDark ? Colors.grey[400] : Colors.grey[600],
      ),
      textAlign: TextAlign.center,
    );
  }
}