import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicCustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double depth;
  final double borderRadius;

  const NeumorphicCustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.depth = 8,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = NeumorphicTheme.baseColor(context);
    final effectivePadding = padding ?? const EdgeInsets.all(16);

    return Container(
      margin: margin,
      child: NeumorphicButton(
        onPressed: onTap,
        style: NeumorphicStyle(
          depth: depth,
          intensity: 0.65,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(borderRadius),
          ),
          color: baseColor,
        ),
        padding: effectivePadding is EdgeInsets 
            ? effectivePadding 
            : EdgeInsets.only(
                left: effectivePadding.resolve(TextDirection.ltr).left,
                top: effectivePadding.resolve(TextDirection.ltr).top,
                right: effectivePadding.resolve(TextDirection.ltr).right,
                bottom: effectivePadding.resolve(TextDirection.ltr).bottom,
              ),
        child: child,
      ),
    );
  }
}
