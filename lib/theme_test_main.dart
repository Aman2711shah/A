import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_gradients.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ModernThemeTestApp());
}

class ModernThemeTestApp extends StatelessWidget {
  const ModernThemeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAZEET Modern UI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const ModernUIScreen(),
    );
  }
}

class ModernUIScreen extends StatefulWidget {
  const ModernUIScreen({super.key});

  @override
  State<ModernUIScreen> createState() => _ModernUIScreenState();
}

class _ModernUIScreenState extends State<ModernUIScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme =
        isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    return Theme(
      data: effectiveTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'WAZEET Theme Test',
                style: theme.textTheme.titleLarge,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome to WAZEET',
                            style: theme.textTheme.displaySmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your Business Setup Partner in UAE',
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'Modern Theme',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Typography Showcase
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Typography',
                              style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          Text('Display Large',
                              style: theme.textTheme.displayLarge
                                  ?.copyWith(fontSize: 32)),
                          Text('Headline Large',
                              style: theme.textTheme.headlineLarge),
                          Text('Title Large',
                              style: theme.textTheme.titleLarge),
                          Text('Body Large', style: theme.textTheme.bodyLarge),
                          Text('Body Medium',
                              style: theme.textTheme.bodyMedium),
                          Text('Body Small', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons Showcase
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Buttons',
                              style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text('Elevated Button'),
                              ),
                              FilledButton(
                                onPressed: () {},
                                child: const Text('Filled Button'),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Outlined Button'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Text Button'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Colors Showcase
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Colors', style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _ColorTile('Primary', AppColors.primary),
                              _ColorTile('Secondary', AppColors.secondary),
                              _ColorTile('Tertiary', AppColors.tertiary),
                              _ColorTile('Success', AppColors.success),
                              _ColorTile('Warning', AppColors.warning),
                              _ColorTile('Error', AppColors.error),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Input Fields
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Input Fields',
                              style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ColorTile extends StatelessWidget {
  final String name;
  final Color color;

  const _ColorTile(this.name, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);
    final textStyle = theme.textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w600,
    );

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: textStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
