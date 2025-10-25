import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/theme/app_colors.dart';
import '../data/user_profile.dart';
import '../state/profile_controller.dart';
import 'edit_profile_screen.dart';
import 'profile_card.dart';

class MoreScreenContent extends StatefulWidget {
  const MoreScreenContent({super.key});

  @override
  State<MoreScreenContent> createState() => _MoreScreenContentState();
}

class _MoreScreenContentState extends State<MoreScreenContent> {
  bool _navigatingToLogin = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileController>(
      builder: (context, controller, _) {
        if (!controller.isAuthenticated) {
          _redirectToLogin(context);
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile;

        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            children: [
              ProfileCard(
                profile: profile,
                onEditProfile: () =>
                    _navigateTo(context, const EditProfileScreen()),
                onMyApplications: () => _navigateTo(
                    context, const StubScreen(title: 'My Applications')),
                onSettings: () =>
                    _navigateTo(context, const StubScreen(title: 'Settings')),
                onHelpSupport: () => _navigateTo(
                    context, const StubScreen(title: 'Help & Support')),
                onLogout: () async {
                  await controller.signOut();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out')),
                  );
                },
              ),
              if (profile != null) _buildDetailSection(context, profile),
            ],
          ),
        );
      },
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _buildDetailSection(BuildContext context, UserProfile profile) {
    final rows = <_DetailRow>[
      _DetailRow(label: 'Phone', value: profile.phone),
      _DetailRow(label: 'Designation', value: profile.designation),
      _DetailRow(label: 'Company', value: profile.companyName),
      _DetailRow(label: 'Country', value: profile.country),
    ].where((row) => row.value != null && row.value!.isNotEmpty).toList();

    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your profile',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a phone number, designation, company, and country to personalize your experience.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: rows
              .map(
                (row) => ListTile(
                  title: Text(
                    row.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  subtitle: Text(
                    row.value!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _redirectToLogin(BuildContext context) {
    if (_navigatingToLogin) return;
    _navigatingToLogin = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushNamed('/auth/login');
      _navigatingToLogin = false;
    });
  }
}

class _DetailRow {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String? value;
}

class StubScreen extends StatelessWidget {
  const StubScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title screen coming soon',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
