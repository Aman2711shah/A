import 'package:flutter/material.dart';
import 'package:wazeet_app/core/theme/app_colors.dart';
import 'package:wazeet_app/core/theme/app_gradients.dart';

class ModernHomeScreen extends StatefulWidget {
  const ModernHomeScreen({super.key});

  @override
  State<ModernHomeScreen> createState() => _ModernHomeScreenState();
}

class _ModernHomeScreenState extends State<ModernHomeScreen> {
  int _currentBannerIndex = 0;

  final List<Map<String, dynamic>> _quickServices = [
    {
      'title': 'Trade License',
      'icon': Icons.business_center,
      'gradient': AppGradients.tradeLicenseGradient,
    },
    {
      'title': 'Visa Services',
      'icon': Icons.card_travel,
      'gradient': AppGradients.visaGradient,
    },
    {
      'title': 'Company Setup',
      'icon': Icons.corporate_fare,
      'gradient': AppGradients.companySetupGradient,
    },
    {
      'title': 'Bank Account',
      'icon': Icons.account_balance,
      'gradient': AppGradients.bankAccountGradient,
    },
    {
      'title': 'Office Space',
      'icon': Icons.meeting_room,
      'gradient': AppGradients.officeSpaceGradient,
    },
    {
      'title': 'Consulting',
      'icon': Icons.groups,
      'gradient': AppGradients.consultingGradient,
    },
  ];

  final List<Map<String, String>> _promotionalBanners = [
    {
      'title': 'Start Your Business',
      'subtitle': 'Free zones from AED 8,000/year',
      'badge': 'SPECIAL OFFER',
    },
    {
      'title': 'Visa Processing',
      'subtitle': 'Get your residence visa in 7 days',
      'badge': 'FAST TRACK',
    },
    {
      'title': 'Company Formation',
      'subtitle': '100% foreign ownership',
      'badge': 'NEW',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.sunsetGradient,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              _buildTopBar(context, colorScheme, textTheme),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _buildSearchBar(context, colorScheme, textTheme),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _buildBannerCarousel(context, colorScheme, textTheme),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Services',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildQuickServicesGrid(context, colorScheme, textTheme),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended for you',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              _buildFreezoneCards(context, colorScheme, textTheme),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, colorScheme),
    );
  }

  SliverToBoxAdapter _buildTopBar(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.business,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'wazeet',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: Badge(
                  backgroundColor: colorScheme.primary,
                  label: Text(
                    '2',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        style: textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search freezones, services...',
          hintStyle: textTheme.bodyMedium?.copyWith(
            color: AppColors.textMuted,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppGradients.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final gradients = [
      AppGradients.goldCardGradient,
      AppGradients.premiumCardGradient,
      AppGradients.accentGradient,
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: _promotionalBanners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _promotionalBanners[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: gradients[index % gradients.length],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -28,
                      right: -20,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surface.withValues(alpha: 0.14),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: -40,
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surface.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  colorScheme.surface.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              banner['badge']!,
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            banner['title']!,
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            banner['subtitle']!,
                            style: textTheme.bodyMedium?.copyWith(
                              color:
                                  colorScheme.onPrimary.withValues(alpha: 0.95),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              backgroundColor:
                                  colorScheme.surface.withValues(alpha: 0.96),
                              foregroundColor: colorScheme.onSurface,
                              textStyle: textTheme.labelLarge?.copyWith(
                                letterSpacing: 1.1,
                              ),
                            ),
                            child: Text(
                              'APPLY NOW',
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _promotionalBanners.length,
            (index) {
              final isActive = index == _currentBannerIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: isActive ? 24 : 10,
                decoration: BoxDecoration(
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickServicesGrid(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: _quickServices.length,
      itemBuilder: (context, index) {
        final service = _quickServices[index];
        final gradient = service['gradient'] as LinearGradient;

        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    service['icon'] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    service['title'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  SliverList _buildFreezoneCards(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final freezones = [
      {
        'name': 'Dubai Multi Commodities Centre',
        'shortName': 'DMCC',
        'price': '15,000',
        'rating': '4.8',
        'reviews': '1,234',
        'badge': 'Best Seller',
        'activities': '1,000+',
      },
      {
        'name': 'Dubai Silicon Oasis',
        'shortName': 'DSO',
        'price': '12,500',
        'rating': '4.7',
        'reviews': '892',
        'badge': 'Popular',
        'activities': '500+',
      },
      {
        'name': 'Sharjah Media City',
        'shortName': 'SHAMS',
        'price': '8,000',
        'rating': '4.6',
        'reviews': '654',
        'badge': 'Budget Friendly',
        'activities': '300+',
      },
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final freezone = freezones[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: index == 0
                        ? AppGradients.oceanGradient
                        : index == 1
                            ? AppGradients.mintGradient
                            : AppGradients.lavenderGradient,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                freezone['badge'] as String,
                                style: textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        freezone['name'] as String,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        freezone['shortName'] as String,
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${freezone['rating']} ',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '(${freezone['reviews']} reviews)',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${freezone['activities']} activities',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Text(
                            'From ',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'AED ${freezone['price']}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '/year',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'Apply',
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: freezones.length,
      ),
    );
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 26,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home, 'Home', true),
              _buildNavItem(
                  context, Icons.category_outlined, 'Services', false),
              _buildNavItem(
                context,
                Icons.description_outlined,
                'Applications',
                false,
              ),
              _buildNavItem(context, Icons.person_outline, 'Account', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: isActive ? AppGradients.primaryGradient : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: isActive ? colorScheme.onPrimary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
