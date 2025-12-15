import 'dart:io';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lifeplus_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';
import 'csv_viewer_screen.dart';

class LifePlusFilesScreen extends ConsumerStatefulWidget {
  const LifePlusFilesScreen({super.key});

  @override
  ConsumerState<LifePlusFilesScreen> createState() => _LifePlusFilesScreenState();
}

class _LifePlusFilesScreenState extends ConsumerState<LifePlusFilesScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh file list on entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lifePlusProvider.notifier).loadExtractedFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lifePlusState = ref.watch(lifePlusProvider);
    final files = lifePlusState.extractedFiles;

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'LifePlus Data Files',
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
        child: files.isEmpty
            ? Center(
          child: Text(
            'No data files found.\nPlease download data from Settings.',
            textAlign: TextAlign.center,
            style: NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            // Extract filename from path
            final filename = file.path.split(Platform.pathSeparator).last;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: NeumorphicCustomCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CsvViewerScreen(
                        file: file,
                        title: filename,
                      ),
                    ),
                  );
                },
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Neumorphic(
                      style: const NeumorphicStyle(
                        depth: 6,
                        intensity: 0.65,
                        boxShape: NeumorphicBoxShape.circle(),
                        color: Color(0xFF10B981), // Green for CSV
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.table_chart,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        filename,
                        style: NeumorphicTheme.currentTheme(context).textTheme.titleMedium,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: NeumorphicAppTheme.getSecondaryTextColor(context),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
