import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:wazeet_app/core/theme/app_colors.dart';

import '../providers/dashboard_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/service_card.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../../../shared/widgets/notification_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false)
          .loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Consumer2<DashboardProvider, AuthProvider>(
        builder: (context, dashboardProvider, authProvider, _) {
          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Welcome back, ${authProvider.userData?['firstName'] ?? 'User'}!',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      // Navigate to notifications
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.account_circle_outlined,
                      color: colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      context.go('/profile');
                    },
                  ),
                ],
              ),

              // Dashboard Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Quick Stats
                    _buildQuickStats(dashboardProvider),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActions(),

                    const SizedBox(height: 24),

                    // Recent Applications
                    _buildRecentApplications(dashboardProvider),

                    const SizedBox(height: 24),

                    // Services
                    _buildServices(),

                    const SizedBox(height: 24),

                    // Notifications
                    _buildNotifications(dashboardProvider),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              context.go('/company-formation');
              break;
            case 2:
              context.go('/trade-license');
              break;
            case 3:
              context.go('/visa-processing');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Company',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'License',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Visa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(DashboardProvider provider) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Business Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Active Applications',
                    '${provider.activeApplications}',
                    Icons.pending_actions,
                    AppColors.info,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    '${provider.completedApplications}',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Documents',
                    '${provider.pendingDocuments}',
                    Icons.description,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'New Company',
                subtitle: 'Start your business',
                icon: Icons.business,
                color: AppColors.primary,
                onTap: () => context.go('/company-formation'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: 'Trade License',
                subtitle: 'Apply for license',
                icon: Icons.description,
                color: AppColors.success,
                onTap: () => context.go('/trade-license'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                title: 'Visa Processing',
                subtitle: 'Employee visas',
                icon: Icons.work,
                color: AppColors.warning,
                onTap: () => context.go('/visa-processing'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                title: 'Documents',
                subtitle: 'Upload files',
                icon: Icons.upload_file,
                color: AppColors.tertiary,
                onTap: () {
                  // Navigate to documents
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentApplications(DashboardProvider provider) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Applications',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all applications
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...provider.recentApplications.map(
          (application) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(application['status'])
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getStatusIcon(application['status']),
                  color: _getStatusColor(application['status']),
                  size: 20,
                ),
              ),
              title: Text(application['title']),
              subtitle: Text(application['subtitle']),
              trailing: Text(
                application['status'],
                style: TextStyle(
                  color: _getStatusColor(application['status']),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServices() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Services',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            ServiceCard(
              title: 'Company Formation',
              subtitle: 'LLC, Free Zone, Mainland',
              icon: Icons.business,
              color: AppColors.primary,
              onTap: () => context.go('/company-formation'),
            ),
            ServiceCard(
              title: 'Trade License',
              subtitle: 'Business License Application',
              icon: Icons.description,
              color: AppColors.success,
              onTap: () => context.go('/trade-license'),
            ),
            ServiceCard(
              title: 'Visa Services',
              subtitle: 'Employee & Investor Visas',
              icon: Icons.work,
              color: AppColors.warning,
              onTap: () => context.go('/visa-processing'),
            ),
            ServiceCard(
              title: 'Banking',
              subtitle: 'Business Bank Account',
              icon: Icons.account_balance,
              color: AppColors.tertiary,
              onTap: () {
                // Navigate to banking services
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotifications(DashboardProvider provider) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Notifications',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...provider.notifications.map(
          (notification) => NotificationCard(
            title: notification['title'],
            message: notification['message'],
            time: notification['time'],
            isRead: notification['isRead'],
            onTap: () {
              // Handle notification tap
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.warning;
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'in review':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'in review':
        return Icons.visibility;
      default:
        return Icons.help;
    }
  }
}
