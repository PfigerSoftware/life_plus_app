import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/neumorphic_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@example.com',
      query: 'subject=Support Request',
    );
    if (!await launchUrl(emailUri)) {
      debugPrint('Could not launch email');
    }
  }

  Future<void> _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+911234567890');
    if (!await launchUrl(phoneUri)) {
      debugPrint('Could not launch phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Contact Us',
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
                'Get in Touch',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'We\'re here to help you',
                style:
                    NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Email Contact
              NeumorphicCustomCard(
                onTap: _launchEmail,
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
                      child: const Icon(
                        Icons.email_outlined,
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
                            'Email',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'support@example.com',
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

              // Phone Contact
              NeumorphicCustomCard(
                onTap: _launchPhone,
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
                        Icons.phone_outlined,
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
                            'Phone',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+91 123 456 7890',
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

              // Website Contact
              NeumorphicCustomCard(
                onTap: () => _launchURL('https://www.example.com'),
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
                        Icons.language_outlined,
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
                            'Website',
                            style: NeumorphicTheme.currentTheme(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'www.example.com',
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
              const SizedBox(height: 32),

              // Office Address
              Neumorphic(
                style: NeumorphicStyle(
                  depth: -4,
                  intensity: 0.65,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(16),
                  ),
                  color: NeumorphicTheme.baseColor(context),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: NeumorphicTheme.accentColor(context),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Office Address',
                          style: NeumorphicTheme.currentTheme(context)
                              .textTheme
                              .titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '123 Insurance Street\nCity, State - 123456\nIndia',
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
      ),
    );
  }
}
