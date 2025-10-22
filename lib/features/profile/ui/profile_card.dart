import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/user_profile.dart';

typedef ProfileMenuCallback = void Function();

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
    required this.onEditProfile,
    required this.onMyApplications,
    required this.onSettings,
    required this.onHelpSupport,
    required this.onLogout,
  });

  final UserProfile? profile;
  final ProfileMenuCallback onEditProfile;
  final ProfileMenuCallback onMyApplications;
  final ProfileMenuCallback onSettings;
  final ProfileMenuCallback onHelpSupport;
  final ProfileMenuCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final name = profile?.name?.isNotEmpty == true ? profile!.name! : 'Guest';
    final email = profile?.email ?? 'No email';
    final avatarInitials = name.trim().isEmpty
        ? '?'
        : name
            .trim()
            .split(' ')
            .where((part) => part.isNotEmpty)
            .take(2)
            .map((part) => part[0])
            .join()
            .toUpperCase();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: AppColors.white.withValues(alpha: 0.2),
                backgroundImage: profile?.profileImage != null
                    ? NetworkImage(profile!.profileImage!)
                    : null,
                child: profile?.profileImage != null
                    ? null
                    : Text(
                        avatarInitials,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _ProfileTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal details',
                  onTap: onEditProfile,
                ),
                _ProfileTile(
                  icon: Icons.assignment_outlined,
                  title: 'My Applications',
                  subtitle: 'View your submitted applications',
                  onTap: onMyApplications,
                ),
                _ProfileTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'Configure notifications and preferences',
                  onTap: onSettings,
                ),
                _ProfileTile(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help & Support',
                  subtitle: 'Get assistance from our team',
                  onTap: onHelpSupport,
                ),
                const Divider(height: 0),
                _ProfileTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: onLogout,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.lightGrey,
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDestructive ? colorScheme.error : null,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
