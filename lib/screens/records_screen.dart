import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final recordCategories = [
      {
        'title': 'Policies',
        'icon': Icons.description_outlined,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Insurance',
        'icon': Icons.shield_outlined,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Monthly Bills',
        'icon': Icons.receipt_long_outlined,
        'color': const Color(0xFFF59E0B),
      },
      {
        'title': 'Investments',
        'icon': Icons.trending_up_outlined,
        'color': const Color(0xFF8B5CF6),
      },
      {
        'title': 'Loans',
        'icon': Icons.account_balance_outlined,
        'color': const Color(0xFFEF4444),
      },
      {
        'title': 'Documents',
        'icon': Icons.folder_outlined,
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'My Records',
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
                'Manage Your Records',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Organize all your important documents',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Grid of Record Categories
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: recordCategories.length,
                  itemBuilder: (context, index) {
                    final category = recordCategories[index];
                    return NeumorphicCustomCard(
                      onTap: () {
                        // Navigate to category detail (placeholder)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Opening ${category['title']} records...'),
                            backgroundColor:
                                NeumorphicTheme.accentColor(context),
                          ),
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
                              boxShape: const NeumorphicBoxShape.circle(),
                              color: category['color'] as Color,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              category['icon'] as IconData,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category['title'] as String,
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
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
}
