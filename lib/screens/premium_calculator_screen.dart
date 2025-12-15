import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';

class PremiumCalculatorScreen extends StatelessWidget {
  const PremiumCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final planCategories = [
      {
        'category': 'Endowment Plans',
        'plans': [
          {'name': 'Plan 714', 'color': const Color(0xFF6366F1)},
          {'name': 'Plan 715', 'color': const Color(0xFF8B5CF6)},
          {'name': 'Plan 733', 'color': const Color(0xFF06B6D4)},
        ],
      },
      {
        'category': 'Mahila Plans',
        'plans': [
          {'name': 'Bima Lakhsmi', 'color': const Color(0xFFEC4899)},
        ],
      },
    ];

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Premium Calculator',
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
                'Select Insurance Plan',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a plan to calculate premium',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Plan Categories
              Expanded(
                child: ListView.builder(
                  itemCount: planCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = planCategories[categoryIndex];
                    final plans = category['plans'] as List;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Title
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            category['category'] as String,
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .headlineMedium,
                          ),
                        ),

                        // Plans Grid
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: plans.map((plan) {
                            return SizedBox(
                              width: (MediaQuery.of(context).size.width - 72) /
                                  2,
                              child: NeumorphicCustomCard(
                                onTap: () {
                                  _showPlanCalculator(
                                    context,
                                    plan['name'] as String,
                                  );
                                },
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Neumorphic(
                                      style: NeumorphicStyle(
                                        depth: 6,
                                        intensity: 0.65,
                                        boxShape:
                                            const NeumorphicBoxShape.circle(),
                                        color: plan['color'] as Color,
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      child: const Icon(
                                        Icons.calculate_outlined,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      plan['name'] as String,
                                      style: NeumorphicTheme.currentTheme(
                                              context)
                                          .textTheme
                                          .titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlanCalculator(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeumorphicTheme.baseColor(context),
        title: Text(
          '$planName Calculator',
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        content: Text(
          'Premium calculator for $planName will be available here. You can input policy details and calculate premiums.',
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
