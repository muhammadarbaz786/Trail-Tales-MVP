import 'package:flutter/material.dart';
import 'package:trailtales/widgets/auth/auth_button.dart';
import 'package:trailtales/widgets/auth/auth_text_field.dart';
import 'password_strength_indicator.dart';

class SignUpForm extends StatefulWidget {
  final Function(String fullName, String email, String password) onSignUp;
  final VoidCallback onNavigateToSignIn;

  const SignUpForm({
    Key? key,
    required this.onSignUp,
    required this.onNavigateToSignIn,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _acceptTerms = false;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength() {
    setState(() {
      _passwordStrength = _calculatePasswordStrength(_passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🔹 Minimal horizontal padding so fields almost touch screen edges
    final fieldPadding = screenWidth * 0.03; // 3% of screen width

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthTextField(
              controller: _fullNameController,
              labelText: 'Full Name',
              prefixIcon: Icons.person_outline,
              keyboardType: TextInputType.name,
              validator: _validateFullName,
              textInputAction: TextInputAction.next,
              autocorrect: true,
            ),
          ),
          const SizedBox(height: 18),

          // Email
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthTextField(
              controller: _emailController,
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              textInputAction: TextInputAction.next,
              autocorrect: false,
            ),
          ),
          const SizedBox(height: 18),

          // Password
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthTextField(
              controller: _passwordController,
              labelText: 'Password (min 6 chars)',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: _validatePassword,
              textInputAction: TextInputAction.next,
              autocorrect: false,
            ),
          ),
          const SizedBox(height: 8),

          // Password Strength
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: PasswordStrengthIndicator(strength: _passwordStrength),
          ),
          const SizedBox(height: 18),

          // Confirm Password
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: _validateConfirmPassword,
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
          ),
          const SizedBox(height: 18),

          // Terms Checkbox
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: _buildTermsCheckbox(isDark),
          ),
          const SizedBox(height: 28),

          // Sign Up Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthButton(
              text: 'Sign Up',
              onPressed: (_isLoading || !_acceptTerms) ? null : _handleSignUp,
              isLoading: _isLoading,
              isPrimary: true,
            ),
          ),
          const SizedBox(height: 24),

          // Sign In Link
          _buildSignInLink(isDark),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: isDark ? Colors.blue[400] : Colors.blue[600],
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  children: [
                    const TextSpan(text: 'I agree to the '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: isDark ? Colors.blue[300] : Colors.blue[600],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: isDark ? Colors.blue[300] : Colors.blue[600],
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInLink(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: widget.onNavigateToSignIn,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: isDark ? Colors.blue[300] : Colors.blue[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return 'Name must be at least 2 characters';
    }
    final nameRegExp = RegExp(r"^[a-zA-Z]+([ '-][a-zA-Z]+)*$");
    if (!nameRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid name (letters, spaces, apostrophes, hyphens only)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the terms and conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.onSignUp(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
