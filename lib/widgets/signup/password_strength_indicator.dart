import 'package:flutter/material.dart';

enum PasswordStrength { weak, medium, strong }

class PasswordStrengthIndicator extends StatefulWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({
    Key? key,
    required this.strength,
  }) : super(key: key);

  @override
  State<PasswordStrengthIndicator> createState() =>
      _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(PasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.strength != widget.strength) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStrengthBars(isDark),
            const SizedBox(height: 4),
            _buildStrengthText(isDark),
          ],
        );
      },
    );
  }

  Widget _buildStrengthBars(bool isDark) {
    return Row(
      children: List.generate(3, (index) => _buildStrengthBar(index, isDark)),
    );
  }

  Widget _buildStrengthBar(int index, bool isDark) {
    Color getBarColor() {
      if (index >= _getStrengthLevel()) {
        return isDark ? Colors.grey[700]! : Colors.grey[300]!;
      }

      switch (widget.strength) {
        case PasswordStrength.weak:
          return Colors.red[400]!;
        case PasswordStrength.medium:
          return Colors.orange[400]!;
        case PasswordStrength.strong:
          return Colors.green[400]!;
      }
    }

    return Expanded(
      child: Container(
        height: 4,
        margin: EdgeInsets.only(
          right: index < 2 ? 4 : 0,
        ),
        decoration: BoxDecoration(
          color: getBarColor(),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Transform.scale(
          scaleX: index < _getStrengthLevel() ? _animation.value : 1.0,
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(
              color: getBarColor(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStrengthText(bool isDark) {
    String getText() {
      switch (widget.strength) {
        case PasswordStrength.weak:
          return 'Weak password';
        case PasswordStrength.medium:
          return 'Medium strength';
        case PasswordStrength.strong:
          return 'Strong password';
      }
    }

    Color getTextColor() {
      switch (widget.strength) {
        case PasswordStrength.weak:
          return Colors.red[400]!;
        case PasswordStrength.medium:
          return Colors.orange[400]!;
        case PasswordStrength.strong:
          return Colors.green[400]!;
      }
    }

    return Row(
      children: [
        Icon(
          _getStrengthIcon(),
          size: 16,
          color: getTextColor(),
        ),
        const SizedBox(width: 4),
        Text(
          getText(),
          style: TextStyle(
            fontSize: 12,
            color: getTextColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  int _getStrengthLevel() {
    switch (widget.strength) {
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 2;
      case PasswordStrength.strong:
        return 3;
    }
  }

  IconData _getStrengthIcon() {
    switch (widget.strength) {
      case PasswordStrength.weak:
        return Icons.warning_outlined;
      case PasswordStrength.medium:
        return Icons.info_outlined;
      case PasswordStrength.strong:
        return Icons.check_circle_outlined;
    }
  }
}

// Enhanced version with tips
class PasswordStrengthIndicatorWithTips extends StatelessWidget {
  final PasswordStrength strength;
  final String password;

  const PasswordStrengthIndicatorWithTips({
    Key? key,
    required this.strength,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PasswordStrengthIndicator(strength: strength),
        if (strength != PasswordStrength.strong) ...[
          const SizedBox(height: 8),
          _buildPasswordTips(isDark),
        ],
      ],
    );
  }

  Widget _buildPasswordTips(bool isDark) {
    final tips = _getPasswordTips();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[800]?.withOpacity(0.3)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? Colors.grey[700]!
              : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password tips:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  tip.isCompleted ? Icons.check : Icons.circle_outlined,
                  size: 12,
                  color: tip.isCompleted
                      ? Colors.green[400]
                      : (isDark ? Colors.grey[500] : Colors.grey[400]),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    tip.text,
                    style: TextStyle(
                      fontSize: 11,
                      color: tip.isCompleted
                          ? Colors.green[400]
                          : (isDark ? Colors.grey[400] : Colors.grey[600]),
                      decoration: tip.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  List<PasswordTip> _getPasswordTips() {
    return [
      PasswordTip(
        text: 'At least 8 characters',
        isCompleted: password.length >= 8,
      ),
      PasswordTip(
        text: 'Include uppercase letter',
        isCompleted: RegExp(r'[A-Z]').hasMatch(password),
      ),
      PasswordTip(
        text: 'Include lowercase letter',
        isCompleted: RegExp(r'[a-z]').hasMatch(password),
      ),
      PasswordTip(
        text: 'Include number',
        isCompleted: RegExp(r'[0-9]').hasMatch(password),
      ),
      PasswordTip(
        text: 'Include special character',
        isCompleted: RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
      ),
    ];
  }
}

class PasswordTip {
  final String text;
  final bool isCompleted;

  PasswordTip({
    required this.text,
    required this.isCompleted,
  });
}