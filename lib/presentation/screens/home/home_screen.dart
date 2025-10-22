import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/routes/route_names.dart';
import '../../../features/applications/screens/track_application_screen.dart';
import '../../../features/company_setup/screens/company_setup_screen.dart';
import '../../../features/company_setup/screens/company_setup_tab_screen.dart';
import '../../../features/community/providers/community_provider.dart';
import '../../../features/community/models/community_post.dart';
import '../../../features/community/widgets/community_post_card.dart';
import '../../../features/community/widgets/community_post_composer.dart';
import '../../../shared/dialogs/consultation_request_dialog.dart';
import '../../../features/profile/ui/more_screen_extension.dart'; // INSERT: profile management

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeContentScreen(),
          const ServicesScreen(),
          const CommunityScreen(),
          GrowthScreen(onNavigateToServices: () => _changeTab(1)),
          const MoreScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Growth',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'W',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('WAZEET'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.profile);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to WAZEET',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your complete business setup partner',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.9),
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          'Company Setup',
                          Icons.apartment,
                          AppColors.primary,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CompanySetupTabScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          'Trade License',
                          Icons.description,
                          AppColors.secondary,
                          () {
                            Navigator.pushNamed(
                                context, RouteNames.tradeLicense);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          'Visa & Immigration',
                          Icons.flight,
                          AppColors.success,
                          () {
                            Navigator.pushNamed(
                                context, RouteNames.visaApplication);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          'Track Application',
                          Icons.track_changes,
                          AppColors.warning,
                          () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TrackApplicationScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Services Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Our Services',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to services tab
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildServiceCard(
                    context,
                    'Business Consultancy',
                    'Expert guidance for your business',
                    Icons.business_center,
                  ),
                  _buildServiceCard(
                    context,
                    'Digital Marketing',
                    'Grow your online presence',
                    Icons.campaign,
                  ),
                  _buildServiceCard(
                    context,
                    'Accounting & Taxation',
                    'Complete financial solutions',
                    Icons.account_balance,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showConsultationRequestDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.support_agent),
        label: const Text('Book Consultation'),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}

// Placeholder screens for other tabs
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  // Step control
  int _step = 0; // 0: category, 1: type, 2: sub, 3: review

  // Selections
  ServiceCategory? _selectedCategory;
  ServiceType? _selectedType;
  SubService? _selectedSub;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 24),
            _buildProgress(),
            const SizedBox(height: 16),
            // Main content by step
            if (_step == 0) _buildCategoryList(),
            if (_step == 1) _buildTypeList(),
            if (_step == 2) _buildSubList(),
            if (_step == 3) _buildReview(),
            const SizedBox(height: 24),
            _buildNavBar(),
          ],
        ),
      ),
    );
  }

  // =============== UI Sections ===============
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Services',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete business setup solutions in UAE',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    final titles = [
      'Select Category',
      'Select Service',
      'Select Sub-Service',
      'Review'
    ];
    return Row(
      children: List.generate(4, (i) {
        final active = i <= _step;
        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('${i + 1}',
                          style: TextStyle(
                              color: active ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (i < 3)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        color: i < _step
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                titles[i],
                style: TextStyle(
                  fontSize: 12,
                  color: active ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Our Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...serviceCatalog.map(_categoryTile),
      ],
    );
  }

  Widget _categoryTile(ServiceCategory c) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.apps, color: AppColors.primary, size: 20),
        ),
        title: Text(c.name),
        subtitle: Text('${c.types.length} services available'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          setState(() {
            _selectedCategory = c;
            _selectedType = null;
            _selectedSub = null;
            _step = 1;
          });
        },
      ),
    );
  }

  Widget _buildTypeList() {
    final c = _selectedCategory!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _categoryHeader(c),
        const SizedBox(height: 12),
        _overviewCard(c),
        const SizedBox(height: 12),
        const Text('Choose a Service',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...c.types.map(
          (t) => _selectionTile<ServiceType>(
            option: t,
            groupValue: _selectedType,
            onSelect: (value) {
              setState(() {
                _selectedType = value;
                _selectedSub = null;
              });
            },
            title: t.name,
            subtitle: '${t.subServices.length} options',
          ),
        ),
      ],
    );
  }

  Widget _buildSubList() {
    final t = _selectedType!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _categoryHeader(_selectedCategory!),
        const SizedBox(height: 8),
        Text('Service: ${t.name}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        ...t.subServices.map(
          (s) => _selectionTile<SubService>(
            option: s,
            groupValue: _selectedSub,
            onSelect: (value) => setState(() => _selectedSub = value),
            title: s.name,
            subtitle:
                'Premium AED ${s.premiumCost} • ${s.premiumTimeline}',
            trailing: const Icon(Icons.task_alt, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedSub != null) _docsCard(_selectedSub!),
      ],
    );
  }

  Widget _buildReview() {
    final c = _selectedCategory!;
    final s = _selectedSub!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _categoryHeader(c),
        const SizedBox(height: 12),
        _estimateCard(s),
        const SizedBox(height: 12),
        _recommendedCard(),
        const SizedBox(height: 12),
        _ctaCard(s),
      ],
    );
  }

  Widget _selectionTile<T>({
    required T option,
    required T? groupValue,
    required ValueChanged<T> onSelect,
    required String title,
    String? subtitle,
    Widget? trailing,
  }) {
    final isSelected = option == groupValue;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => onSelect(option),
        leading: Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
      ),
    );
  }

  Widget _categoryHeader(ServiceCategory c) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              if (_step == 1) {
                _step = 0;
                _selectedCategory = null;
              } else if (_step == 2) {
                _step = 1;
                _selectedSub = null;
              } else if (_step == 3) {
                _step = 2;
              }
            });
          },
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(c.subtitle,
                  style: const TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        )
      ],
    );
  }

  Widget _overviewCard(ServiceCategory c) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: const [
              Icon(Icons.info_outline),
              SizedBox(width: 8),
              Text('Overview', style: TextStyle(fontWeight: FontWeight.bold))
            ]),
            const SizedBox(height: 8),
            Text(c.overview),
            const SizedBox(height: 12),
            Row(children: const [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 8),
              Text('Key Benefits',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
            const SizedBox(height: 8),
            ...c.benefits.map((b) => Row(children: [
                  const Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Expanded(child: Text(b))
                ])),
            const SizedBox(height: 12),
            Row(children: const [
              Icon(Icons.assignment_outlined, color: Colors.orange),
              SizedBox(width: 8),
              Text('Key Requirements',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ]),
            const SizedBox(height: 8),
            ...c.requirements.map((r) => Row(children: [
                  const Icon(Icons.circle, size: 8, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(child: Text(r))
                ])),
          ],
        ),
      ),
    );
  }

  Widget _estimateCard(SubService s) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Estimated Timeline',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(s.premiumTimeline),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('Estimated Price',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                      'AED ${s.premiumCost} (Premium)\nAED ${s.standardCost} (Standard)')
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _docsCard(s),
      ],
    );
  }

  Widget _docsCard(SubService s) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Document Support',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(s.documents),
          ],
        ),
      ),
    );
  }

  Widget _recommendedCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Recommended Services',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.lightbulb_outline),
              title: Text('Business Consultation'),
              subtitle: Text('Expert guidance needed'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.description_outlined),
              title: Text('Document Support'),
              subtitle: Text('Additional documentation'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaCard(SubService selectedSub) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Ready to Get Started?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
                'Start your application process and get an instant cost estimate',
                textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showConsultationRequestDialog(
                        context,
                        topic:
                            'Quote request for ${selectedSub.name} services',
                      );
                    },
                    child: const Text('Get Quote'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CompanySetupScreen(),
                        ),
                      );
                    },
                    child: const Text('Start Application Process'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    final canNext = (_step == 0 && _selectedCategory != null) ||
        (_step == 1 && _selectedType != null) ||
        (_step == 2 && _selectedSub != null);
    return Row(
      children: [
        if (_step > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  if (_step > 0) _step -= 1;
                });
              },
              child: const Text('Back'),
            ),
          ),
        if (_step > 0) const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: canNext
                ? () {
                    setState(() {
                      if (_step < 3) {
                        _step += 1;
                      }
                    });
                  }
                : null,
            child: Text(_step < 3 ? 'Next' : 'Done'),
          ),
        ),
      ],
    );
  }
}

// ===================== Data Model & Catalog =====================
class ServiceCategory {
  final String name;
  final String subtitle;
  final String overview;
  final List<String> benefits;
  final List<String> requirements;
  final List<ServiceType> types;

  const ServiceCategory({
    required this.name,
    required this.subtitle,
    required this.overview,
    required this.benefits,
    required this.requirements,
    required this.types,
  });
}

class ServiceType {
  final String name;
  final List<SubService> subServices;
  const ServiceType({required this.name, required this.subServices});
}

class SubService {
  final String name;
  final num premiumCost;
  final num standardCost;
  final String premiumTimeline;
  final String standardTimeline;
  final String documents;
  const SubService({
    required this.name,
    required this.premiumCost,
    required this.standardCost,
    required this.premiumTimeline,
    required this.standardTimeline,
    required this.documents,
  });
}

// Seeded catalog (subset from the spreadsheet JSON) — extend as needed.
final List<ServiceCategory> serviceCatalog = [
  ServiceCategory(
    name: 'Visa & Immigration',
    subtitle: 'Complete visa processing and immigration services',
    overview:
        'Handle all your UAE visa and immigration needs with our comprehensive services. From employment and dependent visas to investor and freelance permits, we ensure smooth processing and compliance.',
    benefits: const [
      'Multiple visa type options',
      'Fast track processing available',
      'Family visa facilitation',
      'Long-term residence solutions',
      'Renewal and extension support',
      'Immigration consulting',
    ],
    requirements: const [
      'Valid passport with minimum 6 month validity',
      'Clear passport-size photo',
      'Trade license/offer letter where applicable',
    ],
    types: [
      ServiceType(
        name: 'Employment',
        subServices: const [
          SubService(
            name: 'Issuance',
            premiumCost: 4000,
            standardCost: 3300,
            premiumTimeline: '5-6 days',
            standardTimeline: '6-8 days',
            documents: 'Passport, photo, offer letter, license copy',
          ),
          SubService(
            name: 'Renewal',
            premiumCost: 3500,
            standardCost: 2900,
            premiumTimeline: '4-5 days',
            standardTimeline: '5-6 days',
            documents: 'Passport, visa, Emirates ID',
          ),
          SubService(
            name: 'Cancel',
            premiumCost: 1350,
            standardCost: 1100,
            premiumTimeline: '2 days',
            standardTimeline: '2-3 days',
            documents: 'Passport, visa, cancellation form',
          ),
        ],
      ),
      ServiceType(
        name: 'Dependent',
        subServices: const [
          SubService(
            name: 'Issuance',
            premiumCost: 3500,
            standardCost: 2900,
            premiumTimeline: '4-5 days',
            standardTimeline: '5-7 days',
            documents:
                "Sponsor's passport, visa, birth/marriage certificate, tenancy",
          ),
          SubService(
            name: 'Renewal',
            premiumCost: 3000,
            standardCost: 2500,
            premiumTimeline: '3-4 days',
            standardTimeline: '4-5 days',
            documents: 'Sponsor documents, visa, tenancy',
          ),
          SubService(
            name: 'Cancel',
            premiumCost: 1350,
            standardCost: 1100,
            premiumTimeline: '2 days',
            standardTimeline: '2-3 days',
            documents: 'Passport, visa, cancellation form',
          ),
        ],
      ),
      ServiceType(
        name: 'Investor',
        subServices: const [
          SubService(
            name: 'Issuance',
            premiumCost: 4700,
            standardCost: 4000,
            premiumTimeline: '5-7 days',
            standardTimeline: '7-10 days',
            documents: 'Passport, photo, Emirates ID copy, trade license',
          ),
          SubService(
            name: 'Renewal',
            premiumCost: 3500,
            standardCost: 2900,
            premiumTimeline: '4-5 days',
            standardTimeline: '5-7 days',
            documents: 'Passport, visa, Emirates ID',
          ),
          SubService(
            name: 'Cancel',
            premiumCost: 1350,
            standardCost: 1100,
            premiumTimeline: '2 days',
            standardTimeline: '2-3 days',
            documents: 'Passport, visa, cancellation form',
          ),
        ],
      ),
      ServiceType(
        name: 'Freelance',
        subServices: const [
          SubService(
            name: 'Issuance',
            premiumCost: 8000,
            standardCost: 6500,
            premiumTimeline: '6-8 days',
            standardTimeline: '8-10 days',
            documents: 'Passport, photo, portfolio/NOC, bank statement',
          ),
          SubService(
            name: 'Renewal',
            premiumCost: 7500,
            standardCost: 6000,
            premiumTimeline: '5-6 days',
            standardTimeline: '7-8 days',
            documents: 'Passport, visa, Emirates ID',
          ),
          SubService(
            name: 'Cancel',
            premiumCost: 1350,
            standardCost: 1100,
            premiumTimeline: '2 days',
            standardTimeline: '2-3 days',
            documents: 'Passport, visa, cancellation form',
          ),
        ],
      ),
      ServiceType(
        name: 'Golden Visa',
        subServices: const [
          SubService(
            name: 'Issuance',
            premiumCost: 10000,
            standardCost: 8500,
            premiumTimeline: '10-12 days',
            standardTimeline: '15-20 days',
            documents: 'Passport, Emirates ID, investment proof',
          ),
          SubService(
            name: 'Renewal',
            premiumCost: 9000,
            standardCost: 8000,
            premiumTimeline: '8-10 days',
            standardTimeline: '12-15 days',
            documents: 'Passport, Emirates ID, renewal request',
          ),
        ],
      ),
      ServiceType(
        name: 'Housemaid',
        subServices: const [
          SubService(
            name: 'Issuance',
            premiumCost: 6500,
            standardCost: 5500,
            premiumTimeline: '7-10 days',
            standardTimeline: '10-14 days',
            documents:
                'Sponsor passport/visa, salary proof, maid passport/photo',
          ),
          SubService(
            name: 'Cancel',
            premiumCost: 1350,
            standardCost: 1100,
            premiumTimeline: '2 days',
            standardTimeline: '2-3 days',
            documents: 'Passport, visa, cancellation form',
          ),
        ],
      ),
      ServiceType(
        name: 'Emirates ID Typing',
        subServices: const [
          SubService(
            name: 'Application',
            premiumCost: 780,
            standardCost: 700,
            premiumTimeline: '1 day',
            standardTimeline: '1-2 days',
            documents: 'Passport, visa page, photo',
          ),
        ],
      ),
      ServiceType(
        name: 'Change of Status',
        subServices: const [
          SubService(
            name: 'Processing',
            premiumCost: 1250,
            standardCost: 1100,
            premiumTimeline: '2 days',
            standardTimeline: '2-3 days',
            documents: 'Entry permit, visa, passport',
          ),
        ],
      ),
    ],
  ),
  // --- FTA (subset) ---
  ServiceCategory(
    name: 'Federal Tax Authority',
    subtitle: 'VAT, Corporate Tax, Excise & Certificates',
    overview:
        'End-to-end tax compliance including registration, amendments, return filings and certifications.',
    benefits: const [
      'Compliance first',
      'Experienced tax team',
      'On-time filings'
    ],
    requirements: const [
      'Trade license',
      'Emirates ID/Passport',
      'Basic financials where applicable'
    ],
    types: const [
      ServiceType(
        name: 'Corporate Tax',
        subServices: [
          SubService(
            name: 'Registration',
            premiumCost: 1000,
            standardCost: 500,
            premiumTimeline: '1-2 days',
            standardTimeline: '2-3 working days',
            documents: 'Trade license, ID/Passport, authorization proof',
          ),
          SubService(
            name: 'Return Submission',
            premiumCost: 700,
            standardCost: 500,
            premiumTimeline: '1 day',
            standardTimeline: '2-3 working days',
            documents: 'Audited financial statements, tax calculation data',
          ),
        ],
      ),
      ServiceType(
        name: 'Value Added Tax',
        subServices: [
          SubService(
            name: 'Registration',
            premiumCost: 1000,
            standardCost: 500,
            premiumTimeline: '1 day',
            standardTimeline: '2-3 working days',
            documents:
                'Trade license, Emirates ID, financial records, turnover forecast',
          ),
          SubService(
            name: 'VAT Return Filing',
            premiumCost: 2500,
            standardCost: 500,
            premiumTimeline: '1 day',
            standardTimeline: '2-3 working days',
            documents: 'VAT invoices, reverse charge data, tax ledger',
          ),
        ],
      ),
    ],
  ),
  // --- Accounting (subset) ---
  ServiceCategory(
    name: 'Accounting & Bookkeeping',
    subtitle: 'Complete financial solutions',
    overview:
        'From bookkeeping to VAT and CFO services, we cover all finance ops.',
    benefits: const [
      'Accurate books',
      'On-time compliance',
      'Actionable reports'
    ],
    requirements: const [
      'Bank statements',
      'Invoices',
      'Trial balance (if any)'
    ],
    types: const [
      ServiceType(
        name: 'Bookkeeping',
        subServices: [
          SubService(
            name: 'Basic Monthly',
            premiumCost: 1800,
            standardCost: 1300,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents:
                'Bank statements, sales/purchase invoices, petty cash receipts',
          ),
        ],
      ),
      ServiceType(
        name: 'VAT Return Filing (Quarterly)',
        subServices: [
          SubService(
            name: 'Quarterly Filing',
            premiumCost: 2500,
            standardCost: 2000,
            premiumTimeline: 'Quarterly',
            standardTimeline: 'Quarterly',
            documents: 'VAT certificate, VAT invoices, FTA credentials',
          ),
        ],
      ),
    ],
  ),
  // --- Growth Services ---
  ServiceCategory(
    name: 'Business Expansion Services',
    subtitle: 'Branch setup, activity addition, office upgrades',
    overview:
        'Expand your business with our comprehensive branch setup, license amendments, and facility management services.',
    benefits: const [
      'Fast branch setup',
      'License amendment support',
      'Office upgrade assistance',
      'Business restructuring advisory',
      'Activity addition services',
    ],
    requirements: const [
      'License copy',
      'Shareholder ID',
      'Memorandum of Association (MoA)',
    ],
    types: const [
      ServiceType(
        name: 'Branch Setup',
        subServices: [
          SubService(
            name: 'Mainland/Freezone/International',
            premiumCost: 5000,
            standardCost: 3500,
            premiumTimeline: '2-5 days',
            standardTimeline: '5-10 days',
            documents: 'License copy, shareholder ID, MoA',
          ),
        ],
      ),
      ServiceType(
        name: 'License Amendment',
        subServices: [
          SubService(
            name: 'Additional Activity Addition',
            premiumCost: 1500,
            standardCost: 800,
            premiumTimeline: '1-3 days',
            standardTimeline: '3-5 days',
            documents: 'License, application form',
          ),
          SubService(
            name: 'Trade Name Change',
            premiumCost: 1000,
            standardCost: 500,
            premiumTimeline: '1-2 days',
            standardTimeline: '2-4 days',
            documents: 'Old license, new name',
          ),
        ],
      ),
      ServiceType(
        name: 'Restructuring',
        subServices: [
          SubService(
            name: 'Business Strategy Advisory',
            premiumCost: 3000,
            standardCost: 1800,
            premiumTimeline: '3-5 days',
            standardTimeline: '7-10 days',
            documents: 'Business plan, MoA, shareholder IDs',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'Banking & Finance',
    subtitle: 'Corporate accounts, payment solutions, credit facilities',
    overview:
        'Complete banking and financial services including account opening, payment gateways, and trade finance solutions.',
    benefits: const [
      'Fast account opening',
      'Multiple banking partners',
      'Payment gateway integration',
      'Trade finance solutions',
      'Credit facility assistance',
    ],
    requirements: const [
      'Trade license',
      'Emirates ID',
      'Business plan',
      'Bank statements',
    ],
    types: const [
      ServiceType(
        name: 'Account Opening',
        subServices: [
          SubService(
            name: 'Corporate Bank Account',
            premiumCost: 1200,
            standardCost: 600,
            premiumTimeline: '2-4 days',
            standardTimeline: '5-7 days',
            documents: 'License, Emirates ID, MoA, business plan',
          ),
        ],
      ),
      ServiceType(
        name: 'Payment Solutions',
        subServices: [
          SubService(
            name: 'Payment Gateway Setup',
            premiumCost: 2000,
            standardCost: 1200,
            premiumTimeline: '3-5 days',
            standardTimeline: '7-10 days',
            documents: 'License, website details, bank account',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'Marketing & Sales',
    subtitle: 'Digital marketing, branding, lead generation',
    overview:
        'Boost your business visibility with comprehensive digital marketing, branding, SEO, and content creation services.',
    benefits: const [
      'Increased online presence',
      'Professional branding',
      'SEO optimization',
      'Content marketing',
      'Lead generation',
    ],
    requirements: const [
      'Business details',
      'Target audience information',
      'Brand guidelines (if any)',
    ],
    types: const [
      ServiceType(
        name: 'Digital Marketing',
        subServices: [
          SubService(
            name: 'Social Media Management',
            premiumCost: 3000,
            standardCost: 1500,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents: 'Business info, brand assets, access credentials',
          ),
          SubService(
            name: 'SEO Services',
            premiumCost: 2500,
            standardCost: 1500,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents: 'Website access, keyword list, competitor info',
          ),
        ],
      ),
      ServiceType(
        name: 'Branding',
        subServices: [
          SubService(
            name: 'Brand Identity Design',
            premiumCost: 5000,
            standardCost: 3000,
            premiumTimeline: '7-10 days',
            standardTimeline: '10-14 days',
            documents: 'Business concept, target market, preferences',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'International Trade',
    subtitle: 'Import/export, customs, logistics solutions',
    overview:
        'Comprehensive international trade services including import/export licenses, customs clearance, and shipping logistics.',
    benefits: const [
      'Import/export licensing',
      'Customs clearance',
      'Shipping coordination',
      'Trade compliance',
      'Logistics support',
    ],
    requirements: const [
      'Trade license',
      'Import/export documents',
      'Product details',
    ],
    types: const [
      ServiceType(
        name: 'Trade Licensing',
        subServices: [
          SubService(
            name: 'Import/Export License',
            premiumCost: 2500,
            standardCost: 1500,
            premiumTimeline: '3-5 days',
            standardTimeline: '5-7 days',
            documents: 'Trade license, product list, business plan',
          ),
        ],
      ),
      ServiceType(
        name: 'Customs & Logistics',
        subServices: [
          SubService(
            name: 'Customs Clearance',
            premiumCost: 1500,
            standardCost: 1000,
            premiumTimeline: '1-2 days',
            standardTimeline: '2-3 days',
            documents: 'Invoice, packing list, certificate of origin',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'Tax & Compliance',
    subtitle: 'VAT, corporate tax, audit and financial reporting',
    overview:
        'Complete tax and compliance services including VAT registration, corporate tax filing, and audit services.',
    benefits: const [
      'Tax compliance',
      'Expert tax consultants',
      'Audit support',
      'Financial reporting',
      'Penalty avoidance',
    ],
    requirements: const [
      'Trade license',
      'Financial statements',
      'Tax records',
    ],
    types: const [
      ServiceType(
        name: 'Tax Services',
        subServices: [
          SubService(
            name: 'VAT Registration & Filing',
            premiumCost: 2500,
            standardCost: 1500,
            premiumTimeline: 'Quarterly',
            standardTimeline: 'Quarterly',
            documents: 'License, financials, VAT invoices',
          ),
          SubService(
            name: 'Corporate Tax Filing',
            premiumCost: 3000,
            standardCost: 2000,
            premiumTimeline: 'Annual',
            standardTimeline: 'Annual',
            documents: 'Audited financials, tax calculation',
          ),
        ],
      ),
      ServiceType(
        name: 'Audit Services',
        subServices: [
          SubService(
            name: 'Financial Audit',
            premiumCost: 5000,
            standardCost: 3500,
            premiumTimeline: '10-15 days',
            standardTimeline: '15-20 days',
            documents: 'All financial records, bank statements',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'HR & Talent Acquisition',
    subtitle: 'Recruitment, HR outsourcing, payroll management',
    overview:
        'Complete HR solutions including recruitment, payroll management, HR consulting, and training services.',
    benefits: const [
      'Quality recruitment',
      'Payroll automation',
      'HR compliance',
      'Employee training',
      'HR consulting',
    ],
    requirements: const [
      'Job descriptions',
      'Company policies',
      'Employee data',
    ],
    types: const [
      ServiceType(
        name: 'Recruitment',
        subServices: [
          SubService(
            name: 'Executive Search',
            premiumCost: 5000,
            standardCost: 3000,
            premiumTimeline: '15-30 days',
            standardTimeline: '30-45 days',
            documents: 'Job description, company profile',
          ),
          SubService(
            name: 'Staff Recruitment',
            premiumCost: 2000,
            standardCost: 1200,
            premiumTimeline: '10-15 days',
            standardTimeline: '15-20 days',
            documents: 'Job description, requirements',
          ),
        ],
      ),
      ServiceType(
        name: 'Payroll & HR',
        subServices: [
          SubService(
            name: 'Payroll Management',
            premiumCost: 1500,
            standardCost: 800,
            premiumTimeline: 'Monthly',
            standardTimeline: 'Monthly',
            documents: 'Employee data, salary structure',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'Legal & Compliance',
    subtitle: 'Contracts, IP protection, dispute resolution',
    overview:
        'Expert legal services including contract drafting, trademark registration, and legal advisory for businesses.',
    benefits: const [
      'Contract expertise',
      'IP protection',
      'Legal compliance',
      'Dispute resolution',
      'Corporate governance',
    ],
    requirements: const [
      'Business documents',
      'Legal requirements',
      'Case details',
    ],
    types: const [
      ServiceType(
        name: 'Contract Services',
        subServices: [
          SubService(
            name: 'Contract Drafting',
            premiumCost: 2000,
            standardCost: 1000,
            premiumTimeline: '3-5 days',
            standardTimeline: '5-7 days',
            documents: 'Requirements, terms, parties info',
          ),
        ],
      ),
      ServiceType(
        name: 'IP Protection',
        subServices: [
          SubService(
            name: 'Trademark Registration',
            premiumCost: 3000,
            standardCost: 2000,
            premiumTimeline: '7-10 days',
            standardTimeline: '10-15 days',
            documents: 'Logo, business name, trademark details',
          ),
        ],
      ),
    ],
  ),
  ServiceCategory(
    name: 'Investor Attraction',
    subtitle: 'Funding, pitch decks, investor connections',
    overview:
        'Attract investors with professional pitch decks, investor matchmaking, and due diligence support services.',
    benefits: const [
      'Professional pitch decks',
      'Investor networking',
      'Due diligence support',
      'Funding strategy',
      'Valuation assistance',
    ],
    requirements: const [
      'Business plan',
      'Financial projections',
      'Company information',
    ],
    types: const [
      ServiceType(
        name: 'Investment Services',
        subServices: [
          SubService(
            name: 'Pitch Deck Creation',
            premiumCost: 5000,
            standardCost: 3000,
            premiumTimeline: '5-7 days',
            standardTimeline: '7-10 days',
            documents: 'Business plan, financials, team info',
          ),
          SubService(
            name: 'Investor Matchmaking',
            premiumCost: 10000,
            standardCost: 7000,
            premiumTimeline: '30-60 days',
            standardTimeline: '60-90 days',
            documents: 'Pitch deck, business plan, financials',
          ),
        ],
      ),
      ServiceType(
        name: 'Due Diligence',
        subServices: [
          SubService(
            name: 'Due Diligence Support',
            premiumCost: 8000,
            standardCost: 5000,
            premiumTimeline: '10-15 days',
            standardTimeline: '15-20 days',
            documents: 'All business documents, financials, legal docs',
          ),
        ],
      ),
    ],
  ),
];

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommunityProvider(),
      child: const _CommunityView(),
    );
  }
}

class _CommunityView extends StatefulWidget {
  const _CommunityView();

  @override
  State<_CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<_CommunityView> {
  bool _isPublishing = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CommunityProvider>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                _showComingSoonDialog(context, 'Community search'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () =>
                _showComingSoonDialog(context, 'Community notifications'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCommunityHero(context),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user != null)
                      CommunityPostComposer(
                        isSubmitting: _isPublishing,
                        onSubmit: (content) async {
                          final messenger = ScaffoldMessenger.of(context);
                          setState(() => _isPublishing = true);
                          try {
                            await provider.createPost(content);
                          } catch (e) {
                            messenger.showSnackBar(
                              SnackBar(
                                content:
                                    Text('Unable to post right now: $e'),
                              ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _isPublishing = false);
                            }
                          }
                        },
                      )
                    else
                      _buildSignInPrompt(context),
                    if (provider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (provider.error != null)
                      _buildErrorState(context, provider.error!)
                    else if (provider.posts.isEmpty)
                      _buildEmptyState(context)
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.posts.length,
                        itemBuilder: (context, index) {
                          final post = provider.posts[index];
                          final isLiked = user != null &&
                              post.likes.contains(user.uid);
                          final messenger = ScaffoldMessenger.of(context);
                          return CommunityPostCard(
                            post: post,
                            isLiked: isLiked,
                            onLike: () async {
                              try {
                                await provider.toggleLike(post);
                              } catch (e) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Unable to like post: $e'),
                                  ),
                                );
                              }
                            },
                            onComment: () => _showCommentsSheet(
                              context,
                              provider,
                              post,
                            ),
                            onShare: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Post shared'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Business Community',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect, learn, and grow with fellow entrepreneurs',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildCommunityStats('1,250', 'Members'),
              const SizedBox(width: 24),
              _buildCommunityStats('48', 'Active Discussions'),
              const SizedBox(width: 24),
              _buildCommunityStats('125', 'Events This Month'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityStats(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join the conversation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to share updates, comment, and collaborate with other WAZEET members.',
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.login),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign in to post'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unable to load community updates',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.read<CommunityProvider>().refresh(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.chat_bubble_outline,
              size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          const Text(
            'No posts yet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Be the first to share an update with the WAZEET community.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: FirebaseAuth.instance.currentUser == null
                ? () => Navigator.pushNamed(context, RouteNames.login)
                : () async {
                    final messenger = ScaffoldMessenger.of(context);
                    setState(() => _isPublishing = true);
                    try {
                      await context
                          .read<CommunityProvider>()
                          .createPost('Hello WAZEET community!');
                    } catch (e) {
                      messenger.showSnackBar(
                        SnackBar(content: Text('Unable to post hello: $e')),
                      );
                    } finally {
                      if (mounted) setState(() => _isPublishing = false);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Post now'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCommentsSheet(
    BuildContext context,
    CommunityProvider provider,
    CommunityPost post,
  ) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _CommunityCommentsSheet(
          post: post,
          provider: provider,
        );
      },
    );
  }
}

class _CommunityCommentsSheet extends StatefulWidget {
  const _CommunityCommentsSheet({
    required this.post,
    required this.provider,
  });

  final CommunityPost post;
  final CommunityProvider provider;

  @override
  State<_CommunityCommentsSheet> createState() =>
      __CommunityCommentsSheetState();
}

class __CommunityCommentsSheetState extends State<_CommunityCommentsSheet> {
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsStream = widget.provider.commentsStream(widget.post.id);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Comments',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 280,
            child: StreamBuilder<List<CommunityComment>>(
              stream: commentsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final comments = snapshot.data ?? const [];
                if (comments.isEmpty) {
                  return const Center(
                    child: Text('No comments yet. Start the conversation!'),
                  );
                }
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          comment.authorName.isNotEmpty
                              ? comment.authorName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(comment.authorName),
                      subtitle: Text(comment.text),
                      trailing: Text(
                        DateFormat('MMM d, HH:mm').format(comment.createdAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSubmitting
                  ? null
                  : () async {
                      final text = _commentController.text.trim();
                      if (text.isEmpty) return;
                      setState(() => _isSubmitting = true);
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await widget.provider
                            .addComment(post: widget.post, text: text);
                        _commentController.clear();
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('Failed to comment: $e')),
                        );
                      } finally {
                        if (mounted) {
                          setState(() => _isSubmitting = false);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Post'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
class GrowthScreen extends StatelessWidget {
  final VoidCallback onNavigateToServices;

  const GrowthScreen({super.key, required this.onNavigateToServices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Growth'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () =>
                _showComingSoonDialog(context, 'Growth analytics insights'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Growth Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Scale Your Business',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Expert strategies and tools to accelerate growth',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildGrowthMetric('250%', 'Avg. Growth'),
                      const SizedBox(width: 24),
                      _buildGrowthMetric('500+', 'Success Stories'),
                      const SizedBox(width: 24),
                      _buildGrowthMetric('24/7', 'Support'),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Looking for Growth Services?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'All our growth services including Business Expansion, Banking & Finance, Marketing, International Trade, and more are now available in the Services tab!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: onNavigateToServices,
                          icon: const Icon(Icons.business),
                          label: const Text('Go to Services'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Success Stories
                  const Text(
                    'Success Stories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSuccessStory(
                    'TechStart Solutions',
                    'Increased revenue by 300% in 12 months',
                    'Technology Company',
                    'Through our digital marketing and business consultation services, TechStart achieved remarkable growth.',
                    () {},
                  ),

                  _buildSuccessStory(
                    'Green Energy Co.',
                    'Expanded to 5 new markets across GCC',
                    'Renewable Energy',
                    'Our market expansion strategy helped them become a regional leader in sustainable energy.',
                    () {},
                  ),

                  _buildSuccessStory(
                    'Fashion Forward',
                    'Scaled from 1 to 15 retail locations',
                    'Retail & Fashion',
                    'Strategic planning and funding assistance enabled rapid franchise expansion.',
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // Growth Tools
                  const Text(
                    'Growth Tools & Resources',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildGrowthTool(
                          'Business Calculator',
                          'ROI & Growth Projections',
                          Icons.calculate,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGrowthTool(
                          'Market Reports',
                          'Industry Insights',
                          Icons.assessment,
                          () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildGrowthTool(
                          'Growth Roadmap',
                          'Personalized Plan',
                          Icons.route,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGrowthTool(
                          'Expert Network',
                          'Connect with Advisors',
                          Icons.network_check,
                          () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Growth CTA
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.green, Colors.teal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.rocket_launch,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to Scale?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Book a free consultation with our growth experts and create a customized growth strategy for your business.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => showConsultationRequestDialog(
                            context,
                            topic: 'Growth consultation request',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                          ),
                          child: const Text('Book Free Consultation'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthMetric(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStory(String company, String achievement, String industry,
      String description, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.trending_up,
                      color: Colors.green, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        industry,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              achievement,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onTap,
                child: const Text('Read More'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthTool(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _MoreScreenAppBar(),
      body: MoreScreenContent(), // INSERT: Profile module integration
    );
  }
}

class _MoreScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MoreScreenAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('More'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

void _showComingSoonDialog(BuildContext context, String feature) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Coming Soon'),
      content: Text(
        'The $feature feature is currently in development. Check back soon!',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
