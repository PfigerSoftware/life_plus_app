import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';
import 'policy_view_screen.dart';

class PolicyRecordsScreen extends StatelessWidget {
  const PolicyRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Life Plus Policy Records',
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Policy Management',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your policy entries and view records',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Policy Entry Card
              Expanded(
                child: NeumorphicCustomCard(
                  onTap: () {
                    _showComingSoonDialog(context);
                  },
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                          depth: 6,
                          intensity: 0.65,
                          boxShape: const NeumorphicBoxShape.circle(),
                          color: const Color(0xFF10B981),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: const Icon(
                          Icons.add_circle_outline,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Policy Entry',
                        style: NeumorphicTheme.currentTheme(context)
                            .textTheme
                            .headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add new policy records',
                        style: NeumorphicTheme.currentTheme(context)
                            .textTheme
                            .bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Policy View Card
              Expanded(
                child: NeumorphicCustomCard(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PolicyViewScreen(),
                      ),
                    );
                  },
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                          depth: 6,
                          intensity: 0.65,
                          boxShape: const NeumorphicBoxShape.circle(),
                          color: const Color(0xFF6366F1),
                        ),
                        padding: const EdgeInsets.all(24),
                        child: const Icon(
                          Icons.visibility_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Policy View',
                        style: NeumorphicTheme.currentTheme(context)
                            .textTheme
                            .headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'View and manage existing policies',
                        style: NeumorphicTheme.currentTheme(context)
                            .textTheme
                            .bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeumorphicTheme.baseColor(context),
        title: Text(
          'Coming Soon',
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        content: Text(
          'Policy Entry feature is under development and will be available soon.',
          style: NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: NeumorphicTheme.accentColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
