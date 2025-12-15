import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';
import 'package:url_launcher/url_launcher.dart';

class OnlineServicesScreen extends StatelessWidget {
  const OnlineServicesScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Premium Calculator\n(Official)',
        'icon': Icons.calculate_outlined,
        'color': const Color(0xFF6366F1),
        'url': 'https://licindia.in/premium-calculator',
      },
      {
        'title': 'Pay Premium\n(Amazon Pay)',
        'icon': Icons.payment_outlined,
        'color': const Color(0xFF10B981),
        'url': 'https://www.amazon.in/gp/browse.html?node=11601614031',
      },
      {
        'title': 'Agent Portal',
        'icon': Icons.person_outline,
        'color': const Color(0xFF8B5CF6),
        'url': 'https://agentportal.licindia.in/',
      },
      {
        'title': 'IC 38 Mock Test',
        'icon': Icons.quiz_outlined,
        'color': const Color(0xFFF59E0B),
        'url': 'https://www.insuranceinstituteofindia.com/',
      },
    ];

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Online Services',
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
                'Quick Access Services',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Access official services and tools',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Grid of Services
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return NeumorphicCustomCard(
                      onTap: () {
                        _launchURL(service['url'] as String);
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
                              color: service['color'] as Color,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Icon(
                              service['icon'] as IconData,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            service['title'] as String,
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Icon(
                            Icons.open_in_new,
                            size: 16,
                            color: NeumorphicAppTheme.getSecondaryTextColor(
                                context),
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
