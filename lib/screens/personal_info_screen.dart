import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../providers/auth_provider.dart';
import '../widgets/components/app_buttons.dart';
import '../widgets/components/app_navigation.dart';
import '../widgets/components/app_input_field.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).userModel;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('First Name and Last Name are required')),
      );
      return;
    }

    try {
      await Provider.of<AuthProvider>(context, listen: false).updatePersonalInfo(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personal Information updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Personal Information',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            AppInputField(
              controller: _firstNameController,
              label: 'First Name',
              hintText: 'Elena',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInputField(
              controller: _lastNameController,
              label: 'Last Name',
              hintText: 'Rodriguez',
            ),
            const SizedBox(height: AppSpacing.lg),
            AppInputField(
              controller: _phoneController,
              label: 'Phone Number',
              hintText: '+94 77 123 4567',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                if (auth.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return AppButton(
                  label: 'Save Changes',
                  onTap: _save,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
