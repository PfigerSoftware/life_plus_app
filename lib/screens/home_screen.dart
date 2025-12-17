import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';
import 'profile_screen.dart';
import 'policy_records_screen.dart';
import 'online_services_screen.dart';
import 'premium_calculator_screen.dart';
import 'plan_presentation_screen.dart';
import 'plan_details_screen.dart';
import 'settings_screen.dart';
import 'contact_us_screen.dart';
import 'login_screen.dart';
import 'lifeplus_files_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    final sections = [
      {
        'title': 'Life Plus\nPolicy Records',
        'icon': Icons.folder_special_outlined,
        'color': const Color(0xFF6366F1),
        'screen': const PolicyRecordsScreen(),
      },
      {
        'title': 'Online\nServices',
        'icon': Icons.cloud_outlined,
        'color': const Color(0xFF10B981),
        'screen': const OnlineServicesScreen(),
      },
      {
        'title': 'Premium\nCalculator',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFF8B5CF6),
        'screen': const PremiumCalculatorScreen(),
      },
      {
        'title': 'Plan\nPresentation',
        'icon': Icons.slideshow_outlined,
        'color': const Color(0xFFF59E0B),
        'screen': const PlanPresentationScreen(),
      },
      {
        'title': 'Plan\nDetails',
        'icon': Icons.description_outlined,
        'color': const Color(0xFF06B6D4),
        'screen': const PlanDetailsScreen(),
      },
      {
        'title': 'View LifePlus\nData',
        'icon': Icons.table_view_outlined,
        'color': const Color(0xFFEC4899),
        'screen': const LifePlusFilesScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with Profile and Theme Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Title
                  Text(
                    'Dashboard',
                    style: NeumorphicTheme.currentTheme(context)
                        .textTheme
                        .displaySmall,
                  ),

                  // Profile and Theme Toggle
                  Row(
                    children: [
                      // Theme Toggle
                      NeumorphicButton(
                        onPressed: () {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                        style: const NeumorphicStyle(
                          depth: 4,
                          intensity: 0.65,
                          boxShape: NeumorphicBoxShape.circle(),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          NeumorphicTheme.isUsingDark(context)
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          color: NeumorphicTheme.accentColor(context),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Profile Button
                      NeumorphicButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfileScreen(),
                            ),
                          );
                        },
                        style: const NeumorphicStyle(
                          depth: 4,
                          intensity: 0.65,
                          boxShape: NeumorphicBoxShape.circle(),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.person,
                          color: NeumorphicTheme.accentColor(context),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Welcome Message
              Text(
                'Welcome, ${user?.name ?? 'User'}!',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your policies and services',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Main Content - Grid of Sections
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: sections.length + 2, // +2 for Settings and Contact Us
                  itemBuilder: (context, index) {
                    if (index < sections.length) {
                      final section = sections[index];
                      return _buildSectionCard(
                        context,
                        title: section['title'] as String,
                        icon: section['icon'] as IconData,
                        color: section['color'] as Color,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => section['screen'] as Widget,
                            ),
                          );
                        },
                      );
                    } else if (index == sections.length) {
                      // Settings
                      return _buildSectionCard(
                        context,
                        title: 'Settings',
                        icon: Icons.settings_outlined,
                        color: const Color(0xFF64748B),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          );
                        },
                      );
                    } else {
                      // Contact Us
                      return _buildSectionCard(
                        context,
                        title: 'Contact Us',
                        icon: Icons.contact_support_outlined,
                        color: const Color(0xFFEF4444),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ContactUsScreen(),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              NeumorphicButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: NeumorphicStyle(
                  depth: 4,
                  intensity: 0.65,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(12),
                  ),
                  color: NeumorphicTheme.baseColor(context),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: NeumorphicAppTheme.getSecondaryTextColor(context),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color:
                            NeumorphicAppTheme.getSecondaryTextColor(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return NeumorphicCustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Neumorphic(
            style: NeumorphicStyle(
              depth: 6,
              intensity: 0.65,
              boxShape: const NeumorphicBoxShape.circle(),
              color: color,
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: NeumorphicTheme.currentTheme(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
