import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool showCreateAccount;
  final VoidCallback? onCreateAccountTap;

  const AuthHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.showCreateAccount = false,
    this.onCreateAccountTap,
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
    return Column(
      children: [
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        if (showCreateAccount) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: onCreateAccountTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.blue[600]?.withOpacity(0.2)
                    : Colors.blue[100]?.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.blue[400]! : Colors.blue[300]!,
                  width: 1,
                ),
              ),
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.blue[300] : Colors.blue[700],
                ),
              ),
            ),
          ),
        ],
      ],
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
