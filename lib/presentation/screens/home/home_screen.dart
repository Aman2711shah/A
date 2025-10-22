import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/routes/route_names.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContentScreen(),
    const ServicesScreen(),
    const CommunityScreen(),
    const GrowthScreen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
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
                          color: AppColors.white.withOpacity(0.9),
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
                            Navigator.pushNamed(
                                context, RouteNames.companySetup);
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
                            Navigator.pushNamed(
                                context, RouteNames.trackApplication);
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
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.bookConsultation);
        },
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
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
            color: Colors.black.withOpacity(0.05),
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
              color: AppColors.primary.withOpacity(0.1),
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
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

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
            // Hero Section
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Business Setup Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Complete business setup solutions in UAE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Get Started'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Services Categories
            const Text(
              'Our Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Company Formation Services
            _buildServiceCategory(
              'Company Formation',
              'Set up your business in UAE',
              Icons.business,
              Colors.blue,
              [
                _buildServiceItem(
                    'LLC Formation',
                    'Limited Liability Company setup',
                    Icons.corporate_fare,
                    () {}),
                _buildServiceItem('Free Zone Setup', '100% foreign ownership',
                    Icons.location_city, () {}),
                _buildServiceItem('Offshore Company',
                    'International business structure', Icons.public, () {}),
                _buildServiceItem('Branch Office',
                    'Extension of foreign company', Icons.account_tree, () {}),
              ],
            ),

            const SizedBox(height: 24),

            // Licensing Services
            _buildServiceCategory(
              'Business Licensing',
              'Get the right license for your business',
              Icons.description,
              Colors.green,
              [
                _buildServiceItem('Trade License',
                    'Commercial business license', Icons.store, () {}),
                _buildServiceItem('Professional License',
                    'Service-based businesses', Icons.work, () {}),
                _buildServiceItem('Industrial License',
                    'Manufacturing businesses', Icons.factory, () {}),
                _buildServiceItem('Tourism License', 'Tourism and hospitality',
                    Icons.flight, () {}),
              ],
            ),

            const SizedBox(height: 24),

            // Visa Services
            _buildServiceCategory(
              'Visa & Immigration',
              'Employee and investor visa services',
              Icons.card_membership,
              Colors.orange,
              [
                _buildServiceItem('Employment Visa',
                    'Work permits for employees', Icons.badge, () {}),
                _buildServiceItem('Investor Visa', 'Golden visa for investors',
                    Icons.star, () {}),
                _buildServiceItem('Family Visa', 'Dependent visas',
                    Icons.family_restroom, () {}),
                _buildServiceItem('Visit Visa', 'Short-term business visits',
                    Icons.flight_takeoff, () {}),
              ],
            ),

            const SizedBox(height: 24),

            // Additional Services
            _buildServiceCategory(
              'Additional Services',
              'Complete business support',
              Icons.support,
              Colors.purple,
              [
                _buildServiceItem(
                    'Bank Account Opening',
                    'Corporate banking solutions',
                    Icons.account_balance,
                    () {}),
                _buildServiceItem('Accounting & Bookkeeping',
                    'Financial management', Icons.calculate, () {}),
                _buildServiceItem(
                    'VAT Registration', 'Tax compliance', Icons.receipt, () {}),
                _buildServiceItem('Office Setup', 'Physical office solutions',
                    Icons.business_center, () {}),
              ],
            ),

            const SizedBox(height: 32),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.headset_mic,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Need Help Choosing?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Our experts are here to help you choose the right services for your business.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Contact Expert'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategory(String title, String subtitle, IconData icon,
      Color color, List<Widget> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...services,
      ],
    );
  }

  Widget _buildServiceItem(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Community Hero Section
            Container(
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
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          'New Post',
                          Icons.add_circle,
                          AppColors.primary,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          'Join Event',
                          Icons.event,
                          AppColors.secondary,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          'Find Mentor',
                          Icons.person_search,
                          Colors.orange,
                          () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Community Features
                  const Text(
                    'Community Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildCommunityFeature(
                    'Discussion Forums',
                    'Join conversations about business topics',
                    Icons.forum,
                    Colors.blue,
                    '24 active topics',
                    () {},
                  ),

                  _buildCommunityFeature(
                    'Networking Events',
                    'Attend virtual and in-person networking events',
                    Icons.event,
                    Colors.green,
                    'Next event: Tomorrow 6 PM',
                    () {},
                  ),

                  _buildCommunityFeature(
                    'Mentorship Program',
                    'Get guidance from experienced entrepreneurs',
                    Icons.school,
                    Colors.orange,
                    '15 mentors available',
                    () {},
                  ),

                  _buildCommunityFeature(
                    'Business Partnerships',
                    'Find potential business partners',
                    Icons.handshake,
                    Colors.purple,
                    '8 partnership requests',
                    () {},
                  ),

                  _buildCommunityFeature(
                    'Success Stories',
                    'Read inspiring entrepreneur journeys',
                    Icons.star,
                    Colors.amber,
                    '12 new stories this week',
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // Recent Activity
                  const Text(
                    'Recent Community Activity',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildActivityItem(
                    'Ahmed Al-Rashid',
                    'Shared insights about UAE business regulations',
                    '2 hours ago',
                    Icons.share,
                    () {},
                  ),

                  _buildActivityItem(
                    'Sarah Johnson',
                    'Posted in "Free Zone Discussion"',
                    '4 hours ago',
                    Icons.comment,
                    () {},
                  ),

                  _buildActivityItem(
                    'Tech Entrepreneurs Meetup',
                    'New event scheduled for next week',
                    '6 hours ago',
                    Icons.event,
                    () {},
                  ),

                  _buildActivityItem(
                    'Mohammad Hassan',
                    'Became a verified mentor',
                    '1 day ago',
                    Icons.verified,
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // Join Community CTA
                  Container(
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
                    child: Column(
                      children: [
                        const Icon(
                          Icons.group_add,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ready to Connect?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Join our premium community for exclusive access to events, mentors, and networking opportunities.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text('Upgrade to Premium'),
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

  Widget _buildCommunityStats(String value, String label) {
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

  Widget _buildQuickAction(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityFeature(String title, String subtitle, IconData icon,
      Color color, String meta, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              meta,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildActivityItem(String user, String activity, String time,
      IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(user),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(activity),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class GrowthScreen extends StatelessWidget {
  const GrowthScreen({super.key});

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
            onPressed: () {},
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
                  // Quick Growth Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildGrowthAction(
                          'Business Analysis',
                          Icons.analytics,
                          Colors.blue,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGrowthAction(
                          'Market Research',
                          Icons.trending_up,
                          Colors.green,
                          () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGrowthAction(
                          'Consultation',
                          Icons.support_agent,
                          Colors.orange,
                          () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Growth Services
                  const Text(
                    'Growth Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildGrowthService(
                    'Digital Marketing',
                    'Boost your online presence and reach',
                    'SEO, Social Media, PPC Advertising',
                    Icons.campaign,
                    Colors.purple,
                    'Starting from AED 2,500/month',
                    () {},
                  ),

                  _buildGrowthService(
                    'Business Consultation',
                    'Strategic planning and business optimization',
                    'Strategy, Operations, Financial Planning',
                    Icons.business_center,
                    Colors.blue,
                    'Starting from AED 1,500/session',
                    () {},
                  ),

                  _buildGrowthService(
                    'Market Expansion',
                    'Enter new markets and scale operations',
                    'Market Research, Expansion Strategy',
                    Icons.public,
                    Colors.green,
                    'Starting from AED 5,000',
                    () {},
                  ),

                  _buildGrowthService(
                    'Technology Solutions',
                    'Digital transformation and automation',
                    'Software Development, CRM, ERP',
                    Icons.computer,
                    Colors.indigo,
                    'Custom pricing',
                    () {},
                  ),

                  _buildGrowthService(
                    'Investment & Funding',
                    'Secure funding for business growth',
                    'Investor Connections, Pitch Deck',
                    Icons.monetization_on,
                    Colors.amber,
                    'Success-based fees',
                    () {},
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
                          onPressed: () {},
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

  Widget _buildGrowthAction(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthService(String title, String subtitle, String features,
      IconData icon, Color color, String pricing, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            Text(
              features,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              pricing,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
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
                    color: Colors.green.withOpacity(0.1),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: AppColors.darkGrey,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary,
                    child: const Text(
                      'JD',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'john.doe@email.com',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileStat('3', 'Active\nApplications'),
                      _buildProfileStat('12', 'Completed\nServices'),
                      _buildProfileStat('Premium', 'Account\nType'),
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
                  // Account Section
                  const Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    'Edit Profile',
                    'Update your personal information',
                    Icons.person_outline,
                    () {},
                  ),

                  _buildMenuItem(
                    'Account Settings',
                    'Manage your account preferences',
                    Icons.settings_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Security',
                    'Password and security settings',
                    Icons.security_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Notifications',
                    'Manage notification preferences',
                    Icons.notifications_outlined,
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // Business Section
                  const Text(
                    'Business',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    'My Applications',
                    'Track your service applications',
                    Icons.assignment_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Documents',
                    'Manage your business documents',
                    Icons.folder_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Payment History',
                    'View payment history and invoices',
                    Icons.payment_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Business Profile',
                    'Manage your business information',
                    Icons.business_outlined,
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // Support Section
                  const Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    'Help Center',
                    'FAQs and troubleshooting',
                    Icons.help_outline,
                    () {},
                  ),

                  _buildMenuItem(
                    'Contact Support',
                    'Get help from our support team',
                    Icons.support_agent_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Live Chat',
                    'Chat with our support team',
                    Icons.chat_outlined,
                    () {},
                    badge: 'Online',
                  ),

                  _buildMenuItem(
                    'Book Appointment',
                    'Schedule a consultation',
                    Icons.calendar_today_outlined,
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // App Section
                  const Text(
                    'App',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildMenuItem(
                    'Language',
                    'Choose your preferred language',
                    Icons.language_outlined,
                    () {},
                    trailing: 'English',
                  ),

                  _buildMenuItem(
                    'Theme',
                    'App appearance settings',
                    Icons.palette_outlined,
                    () {},
                    trailing: 'System',
                  ),

                  _buildMenuItem(
                    'About',
                    'App version and information',
                    Icons.info_outline,
                    () {},
                    trailing: 'v1.0.0',
                  ),

                  _buildMenuItem(
                    'Privacy Policy',
                    'Read our privacy policy',
                    Icons.privacy_tip_outlined,
                    () {},
                  ),

                  _buildMenuItem(
                    'Terms of Service',
                    'Read our terms of service',
                    Icons.description_outlined,
                    () {},
                  ),

                  const SizedBox(height: 24),

                  // Premium Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Upgrade to Premium',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Get priority support, exclusive features, and faster processing',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.amber,
                          ),
                          child: const Text('Upgrade Now'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    String? trailing,
    String? badge,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Row(
          children: [
            Expanded(child: Text(title)),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(subtitle),
        trailing: trailing != null
            ? Text(
                trailing,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
