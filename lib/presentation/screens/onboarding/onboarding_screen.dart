import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../config/routes/route_names.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/theme/app_gradients.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _dontShowAgain = false;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      title: 'Welcome to WAZEET',
      description: 'Your complete business setup partner',
      icon: Icons.business_center,
    ),
    _OnboardingPage(
      title: 'Easy Company Formation',
      description: 'Set up your business in the UAE with a few guided steps',
      icon: Icons.apartment,
    ),
    _OnboardingPage(
      title: 'Track Everything in Real-Time',
      description:
          'Stay updated with notifications, document status tracking, and direct access to experts along the way.',
      icon: Icons.trending_up,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            if (_currentPage < _pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skipToEnd,
                  child: Text(
                    'Skip',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) =>
                    _buildPage(_pages[index], colorScheme, textTheme),
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: WormEffect(
                dotColor: colorScheme.outlineVariant,
                activeDotColor: colorScheme.primary,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (_currentPage > 0) const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _currentPage < _pages.length - 1
                          ? _nextPage
                          : _getStarted,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Next'
                            : 'Get Started',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_currentPage == _pages.length - 1)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _dontShowAgain,
                      onChanged: (value) {
                        setState(() {
                          _dontShowAgain = value ?? false;
                        });
                      },
                      activeColor: colorScheme.primary,
                    ),
                    Text(
                      "Don't show this again",
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
    _OnboardingPage page,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              gradient: AppGradients.lightBlueGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 108,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: textTheme.displayMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  void _skipToEnd() {
    _pageController.jumpToPage(_pages.length - 1);
  }

  Future<void> _getStarted() async {
    final storage = LocalStorage();
    await storage.setOnboardingComplete(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, RouteNames.login);
    }
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}
