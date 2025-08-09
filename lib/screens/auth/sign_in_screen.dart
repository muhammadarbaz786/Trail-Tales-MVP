import 'package:flutter/material.dart';
import 'package:trailtales/routes/app_routes.dart';
import '../../widgets/auth/sign_in_form.dart';
import '../../widgets/auth/auth_header.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero, // removed horizontal padding
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildSignInContainer(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInContainer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth; // full width

        return Container(
          width: containerWidth,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16), // minimal padding
          color: Colors.white, // full background
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(
                title: 'Welcome Back',
                subtitle: 'Sign in to continue your story journey',
                icon: Icons.book_outlined,
              ),
              const SizedBox(height: 32),
              SignInForm(
                onSignIn: _handleSignIn,
                onGuestLogin: _handleGuestLogin,
                onNavigateToSignUp: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
                onForgotPassword: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSignIn(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  void _handleGuestLogin() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Guest login failed: ${e.toString()}'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }
}
