import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/lifeplus_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  
  Future<void> _downloadData() async {
    try {
      await ref.read(lifePlusProvider.notifier).downloadZipData();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data downloaded and database created successfully!'),
            backgroundColor: NeumorphicTheme.accentColor(context),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportDatabase() async {
    try {
      final file = await ref.read(lifePlusProvider.notifier).exportDatabase();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Database exported to: ${file.path}'),
            backgroundColor: NeumorphicTheme.accentColor(context),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final lifePlusState = ref.watch(lifePlusProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Settings',
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        leading: NeumorphicButton(
          onPressed: () => Navigator.of(context).pop(),
          style: const NeumorphicStyle(
            depth: 4,
            intensity: 0.65,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.arrow_back,
            color: NeumorphicAppTheme.getTextColor(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App Settings',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Customize your app experience',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Theme Setting
              NeumorphicCustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 6,
                        intensity: 0.65,
                        boxShape: const NeumorphicBoxShape.circle(),
                        color: const Color(0xFF6366F1),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dark Mode',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isDark ? 'Enabled' : 'Disabled',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    NeumorphicSwitch(
                      value: isDark,
                      onChanged: (value) {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // LifePlus Data Download
              NeumorphicCustomCard(
                padding: const EdgeInsets.all(20),
                onTap: lifePlusState.isLoading ? null : _downloadData,
                child: Row(
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 6,
                        intensity: 0.65,
                        boxShape: const NeumorphicBoxShape.circle(),
                        color: const Color(0xFFF59E0B),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: lifePlusState.isLoading 
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                            Icons.download,
                            size: 24,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Download Data',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lifePlusState.isLoading ? 'Downloading...' : 'Get latest LifePlus data',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    if (!lifePlusState.isLoading)
                      Icon(
                        Icons.touch_app,
                        color: NeumorphicAppTheme.getSecondaryTextColor(context),
                        size: 20,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Export Database (only show if database is created)
              if (lifePlusState.isDatabaseCreated)
                NeumorphicCustomCard(
                  padding: const EdgeInsets.all(20),
                  onTap: lifePlusState.isExportingDatabase ? null : _exportDatabase,
                  child: Row(
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                          depth: 6,
                          intensity: 0.65,
                          boxShape: const NeumorphicBoxShape.circle(),
                          color: const Color(0xFF06B6D4),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: lifePlusState.isExportingDatabase
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.file_download,
                                size: 24,
                                color: Colors.white,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Export Database',
                              style: NeumorphicTheme.currentTheme(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lifePlusState.isExportingDatabase
                                  ? 'Exporting...'
                                  : 'Download DB to Downloads folder',
                              style: NeumorphicTheme.currentTheme(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      if (!lifePlusState.isExportingDatabase)
                        Icon(
                          Icons.touch_app,
                          color: NeumorphicAppTheme.getSecondaryTextColor(context),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              if (lifePlusState.isDatabaseCreated)
                const SizedBox(height: 16),

              // Notifications Setting (Placeholder)
              NeumorphicCustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 6,
                        intensity: 0.65,
                        boxShape: const NeumorphicBoxShape.circle(),
                        color: const Color(0xFF10B981),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.notifications_outlined,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage notification preferences',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color:
                          NeumorphicAppTheme.getSecondaryTextColor(context),
                      size: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // About Setting (Placeholder)
              NeumorphicCustomCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: 6,
                        intensity: 0.65,
                        boxShape: const NeumorphicBoxShape.circle(),
                        color: const Color(0xFF8B5CF6),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.info_outline,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Version 1.0.0',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .bodyMedium,
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
      ),
    );
  }
}
