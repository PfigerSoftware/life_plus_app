import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';

class PlanDetailsScreen extends StatelessWidget {
  const PlanDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Plan Details',
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                    depth: 8,
                    intensity: 0.65,
                    boxShape: const NeumorphicBoxShape.circle(),
                    color: NeumorphicTheme.baseColor(context),
                  ),
                  padding: const EdgeInsets.all(32),
                  child: Icon(
                    Icons.description_outlined,
                    size: 80,
                    color: NeumorphicTheme.accentColor(context),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Plan Details',
                  style: NeumorphicTheme.currentTheme(context)
                      .textTheme
                      .displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Access detailed information about insurance plans including features, benefits, and terms.',
                  style:
                      NeumorphicTheme.currentTheme(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
