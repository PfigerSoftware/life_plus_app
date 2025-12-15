import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';

class PolicyViewScreen extends StatelessWidget {
  const PolicyViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final policyOptions = [
      {
        'title': 'NB Registry',
        'icon': Icons.app_registration_outlined,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'DUE Premium',
        'icon': Icons.payment_outlined,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Money Back',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Lapse Re',
        'icon': Icons.refresh_outlined,
        'color': const Color(0xFFEF4444),
      },
      {
        'title': 'Birthday Report',
        'icon': Icons.cake_outlined,
        'color': const Color(0xFFEC4899),
      },
      {
        'title': 'Wedding Day Report',
        'icon': Icons.favorite_outlined,
        'color': const Color(0xFFF43F5E),
      },
      {
        'title': 'DAB List',
        'icon': Icons.list_alt_outlined,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'title': 'Premium Calendar',
        'icon': Icons.calendar_month_outlined,
        'color': const Color(0xFF06B6D4),
      },
      {
        'title': 'Comprehensive Chart',
        'icon': Icons.bar_chart_outlined,
        'color': const Color(0xFF14B8A6),
      },
    ];

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Policy View',
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
                'Select Report Type',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose from available policy reports',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // List of Policy Options
              Expanded(
                child: ListView.builder(
                  itemCount: policyOptions.length,
                  itemBuilder: (context, index) {
                    final option = policyOptions[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: NeumorphicCustomCard(
                        onTap: () {
                          _showPlaceholderDialog(
                            context,
                            option['title'] as String,
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: 6,
                                intensity: 0.65,
                                boxShape: const NeumorphicBoxShape.circle(),
                                color: option['color'] as Color,
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                option['icon'] as IconData,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option['title'] as String,
                                style: NeumorphicTheme.currentTheme(context)
                                    .textTheme
                                    .titleMedium,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: NeumorphicAppTheme.getSecondaryTextColor(
                                  context),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
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

  void _showPlaceholderDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeumorphicTheme.baseColor(context),
        title: Text(
          title,
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        content: Text(
          'This feature will display detailed $title information.',
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
