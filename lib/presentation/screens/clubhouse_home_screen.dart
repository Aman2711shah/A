import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wazeet_app/core/providers/theme_provider.dart';
import 'package:wazeet_app/core/theme/app_colors.dart';
import 'package:wazeet_app/core/theme/app_gradients.dart';
import 'package:wazeet_app/presentation/screens/settings/appearance_settings_screen.dart';

class ClubhouseHomeScreen extends StatefulWidget {
  const ClubhouseHomeScreen({super.key});

  @override
  State<ClubhouseHomeScreen> createState() => _ClubhouseHomeScreenState();
}

class _ClubhouseHomeScreenState extends State<ClubhouseHomeScreen> {
  int _currentPageIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'stay connected\nwith business\nexperts',
      'gradient': AppGradients.orangeGradient,
      'rooms': [
        {
          'type': 'private',
          'title': 'UAE Business Setup',
          'subtitle': 'Expert consultation for\nfreezone selection',
          'participants': [
            {'name': 'Ahmed', 'avatar': '👨‍💼'},
            {'name': 'Sara', 'avatar': '👩‍💼'},
          ]
        }
      ]
    },
    {
      'title': 'explore live\nconsultation\nrooms',
      'gradient': AppGradients.yellowGradient,
      'rooms': [
        {
          'type': 'live',
          'title': 'Monday Night Business',
          'subtitle': 'Trade License Q&A',
          'status': 'speaking now',
          'participants': [
            {'name': 'Expert 1', 'avatar': '🎯'},
            {'name': 'Expert 2', 'avatar': '📋'},
          ]
        },
        {
          'type': 'live',
          'title': '🎪 Meet Business Advisors',
          'subtitle': 'Free consultation',
          'status': 'speaking now',
          'participants': [
            {'name': 'Advisor 1', 'avatar': '👨‍🏫'},
            {'name': 'Advisor 2', 'avatar': '👩‍🏫'},
            {'name': 'Client 1', 'avatar': '🙋‍♂️'},
            {'name': 'Client 2', 'avatar': '🙋‍♀️'},
          ]
        }
      ]
    },
    {
      'title': 'join or just\nlisten in',
      'gradient': AppGradients.lightBlueGradient,
      'rooms': [
        {
          'type': 'meetup',
          'title': 'Dubai Entrepreneurs',
          'subtitle': 'Freezone Meetup - Finding\nYour Next Big Opportunity',
          'participants': [
            {'name': 'Ken', 'avatar': '👨‍💻', 'speaking': true},
            {'name': 'Meghan', 'avatar': '👩‍💼', 'speaking': true},
            {'name': 'Akiko', 'avatar': '👩‍🎨'},
            {'name': 'Carl', 'avatar': '👨‍🔬'},
            {'name': 'Caroline', 'avatar': '👩‍🚀'},
            {'name': 'Catlyn', 'avatar': '👩‍🏫'},
            {'name': 'D.B.', 'avatar': '👨‍🎤'},
            {'name': 'Hannah', 'avatar': '👩‍🎭'},
          ],
          'listeners': [
            {'name': 'Edwin', 'avatar': '👨‍💼'},
            {'name': 'Nadia', 'avatar': '👩‍💻'},
          ]
        }
      ]
    },
    {
      'title': 'host your own\nbusiness room',
      'gradient': AppGradients.purpleGradient,
      'rooms': [
        {
          'type': 'host',
          'title': '🎪 Meet Business Partners',
          'subtitle': 'Public networking room',
          'participants': [
            {'name': 'Naomi', 'avatar': '👩‍💼', 'speaking': true},
            {'name': 'Edwin', 'avatar': '👨‍💼', 'speaking': true},
            {'name': 'Catelyn', 'avatar': '👩‍🏫', 'speaking': true},
            {'name': 'Fumio', 'avatar': '👨‍💻', 'speaking': true},
            {'name': 'Ken', 'avatar': '👨‍🔧'},
            {'name': 'Hannah', 'avatar': '👩‍🎨'},
            {'name': 'Neha', 'avatar': '👩‍🚀'},
            {'name': 'Pilar', 'avatar': '👨‍🎤'},
          ]
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: _pages.length,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final page = _pages[index];
          return Container(
            decoration: BoxDecoration(
              gradient: page['gradient'],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '1:59',
                              style: TextStyle(
                                color: AppColors.black.withValues(alpha: 0.7),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Theme toggle button
                            Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return GestureDetector(
                                  onTap: () => themeProvider.toggleTheme(),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      themeProvider.isDarkMode
                                          ? Icons.light_mode
                                          : Icons.dark_mode,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppearanceSettingsScreen.routeName,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text(
                                'Done',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Main title
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    child: Text(
                      page['title'],
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                height: 1.05,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Room cards
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: page['rooms'].length,
                        itemBuilder: (context, roomIndex) {
                          final room = page['rooms'][roomIndex];
                          return _buildRoomCard(room);
                        },
                      ),
                    ),
                  ),

                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPageIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPageIndex == index
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Floating action button
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: _buildFloatingActionButton(page['type'] ?? 'mic'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          // Dark background card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Card content
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          if (room['type'] == 'private')
                            const Row(
                              children: [
                                Icon(Icons.lock,
                                    size: 16, color: AppColors.textHint),
                                SizedBox(width: 8),
                                Text(
                                  'private',
                                  style: TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          if (room['type'] == 'host')
                            const Row(
                              children: [
                                Icon(Icons.public,
                                    size: 16, color: AppColors.textHint),
                                SizedBox(width: 8),
                                Text(
                                  'public',
                                  style: TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          const Spacer(),
                          if (room['type'] == 'private')
                            const Icon(Icons.more_horiz,
                                color: AppColors.textHint),
                          if (room['type'] == 'private')
                            const SizedBox(width: 8),
                          if (room['type'] == 'private')
                            const Icon(Icons.close, color: AppColors.textHint),
                          if (room['type'] != 'private')
                            const Row(
                              children: [
                                Icon(Icons.more_horiz,
                                    color: AppColors.textHint),
                                SizedBox(width: 8),
                                Text(
                                  '🤚 leave quietly',
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Room title
                      Text(
                        room['title'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                      ),

                      if (room['subtitle'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          room['subtitle'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],

                      if (room['status'] != null) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              room['status'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Participants
                      _buildParticipants(room['participants']),

                      if (room['listeners'] != null) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'followed by the speakers',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildListeners(room['listeners']),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Chat input area (for private rooms)
          if (room['type'] == 'private')
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.textHint),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.borderSubtle,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'Aa',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipants(List<dynamic> participants) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: participants.map((participant) {
        return Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      participant['avatar'],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                if (participant['speaking'] == true)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              participant['name'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildListeners(List<dynamic> listeners) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: listeners.map((listener) {
        return Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  listener['avatar'],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              listener['name'],
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFloatingActionButton(String type) {
    IconData icon = Icons.mic;
    if (type == 'hand') icon = Icons.pan_tool;
    if (type == 'speaking') icon = Icons.mic;

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
