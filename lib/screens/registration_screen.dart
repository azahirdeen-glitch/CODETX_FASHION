import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_input_field.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

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
                          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
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
                              'Join the style\nrevolution.',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: AppTypography.bold,
                                    height: 1.1,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Create your profile to start discovering and sharing the latest trends.',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.primaryFixedDim,
                                    fontWeight: AppTypography.medium,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40), // Spacing for layout
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
                      child: const RegistrationForm(),
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
                  const RegistrationForm(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Failed'),
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
          'Create Account',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: AppTypography.bold),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Join the community and elevate your style.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: AppInputField(
                controller: _firstNameController,
                label: 'First Name',
                hintText: 'Jane',
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppInputField(
                controller: _lastNameController,
                label: 'Last Name',
                hintText: 'Doe',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
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
              label: 'Create Account',
              onTap: _submit,
            );
          },
        ),
        const SizedBox(height: AppSpacing.xxl),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
              TextButton(
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                child: const Text(
                  'Log In',
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
