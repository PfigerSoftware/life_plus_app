import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final IconData? icon;

  const NeumorphicCustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = NeumorphicTheme.isUsingDark(context);
    final accentColor = NeumorphicTheme.accentColor(context);

    return NeumorphicButton(
      onPressed: isLoading ? null : onPressed,
      style: NeumorphicStyle(
        depth: 8,
        intensity: 0.65,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: accentColor,
      ),
      padding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white : Colors.white,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
