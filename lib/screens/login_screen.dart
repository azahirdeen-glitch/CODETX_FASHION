import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_input_field.dart';
import '../providers/auth_provider.dart';
import 'registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isDesktop = constraints.maxWidth >= 900;

          if (isDesktop) {
            return Row(
              children: [
                // Left Side: Brand Visual
                Expanded(
                  flex: 7,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.section),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1539109132381-31a5b2a09be9',
                        ),
                        fit: BoxFit.cover,
                        opacity: 0.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.checkroom,
                              color: AppColors.onPrimary,
                              size: 40,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'ClosetX',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: AppTypography.extrabold,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discover your style\nthrough the lens.',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: AppTypography.bold,
                                    height: 1.1,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Join the world\'s most vibrant community of fashion enthusiasts, creators, and trendsetters.',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.primaryFixedDim,
                                    fontWeight: AppTypography.medium,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _statCard(context, '500k+', 'Daily Snaps'),
                            const SizedBox(width: AppSpacing.md),
                            _statCard(context, '12k', 'Verified Designers'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Side: Form
                Expanded(
                  flex: 5,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: const LoginForm(),
                    ),
                  ),
                ),
              ],
            );
          }

          // Mobile Layout
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.section),
                  Row(
                    children: [
                      const Icon(
                        Icons.checkroom,
                        color: AppColors.primary,
                        size: 32,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'ClosetX',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              color: AppColors.primary,
                              fontWeight: AppTypography.extrabold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.section),
                  const LoginForm(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.onPrimary,
              fontWeight: AppTypography.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.primaryFixedDim),
          ),
        ],
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).login(email, password);
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(e.toString().replaceAll(RegExp(r'\[.*?\]'), '').trim()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome Back',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: AppTypography.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Access your personalized runway and latest trends.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'OR CONTINUE WITH EMAIL',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.outline,
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppInputField(
          controller: _emailController,
          label: 'Email Address',
          hintText: 'name@company.com',
          prefixIcon: const Icon(Icons.mail_outline),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppInputField(
          controller: _passwordController,
          label: 'Password',
          hintText: '••••••••',
          prefixIcon: const Icon(Icons.lock_outline),
          obscureText: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: true,
                onChanged: (_) {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Remember this device for 30 days',
              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot?',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Consumer<AuthProvider>(
          builder: (context, auth, _) {
            if (auth.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return AppButton(
              label: 'Log In',
              onTap: _submit,
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Sign up for free',
                  style: TextStyle(fontWeight: AppTypography.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
