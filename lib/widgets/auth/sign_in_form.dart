import 'package:flutter/material.dart';
import 'auth_text_field.dart';
import 'auth_button.dart';

class SignInForm extends StatefulWidget {
  final Function(String email, String password) onSignIn;
  final VoidCallback onGuestLogin;
  final VoidCallback onNavigateToSignUp;
  final VoidCallback onForgotPassword;

  const SignInForm({
    Key? key,
    required this.onSignIn,
    required this.onGuestLogin,
    required this.onNavigateToSignUp,
    required this.onForgotPassword,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final fieldPadding = screenWidth * 0.05; // slightly wider padding

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthTextField(
              controller: _emailController,
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
          ),
          const SizedBox(height: 18),

          // Password
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthTextField(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: _validatePassword,
            ),
          ),
          const SizedBox(height: 12),

          // Forgot password
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontSize: 15,
                    color: _isLoading
                        ? Colors.grey
                        : (isDark ? Colors.blue[300] : Colors.blue[600]),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Sign In button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: AuthButton(
                key: ValueKey(_isLoading),
                text: 'Sign  In',
                onPressed: _isLoading ? null : _handleSignIn,
                isLoading: _isLoading,
                isPrimary: true,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Guest Login button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: fieldPadding),
            child: AuthButton(
              text: 'Continue as Guest',
              onPressed: _isLoading ? null : _handleGuestLogin,
              isLoading: false,
              isPrimary: false,
              icon: Icons.person_outline,
            ),
          ),
          const SizedBox(height: 28),

          // Sign Up link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              TextButton(
                onPressed: widget.onNavigateToSignUp,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.blue[300] : Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.onSignIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGuestLogin() {
    setState(() => _isLoading = true);
    widget.onGuestLogin();
    if (mounted) setState(() => _isLoading = false);
  }
}
