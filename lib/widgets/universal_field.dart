import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../theme/neumorphic_theme.dart';

enum FieldType {
  email,
  password,
  name,
  phone,
  text,
}

class UniversalField extends StatefulWidget {
  final FieldType fieldType;
  final TextEditingController controller;
  final String label;
  final bool isLocked;
  final String? Function(String?)? customValidator;
  final VoidCallback? onTap;

  const UniversalField({
    super.key,
    required this.fieldType,
    required this.controller,
    required this.label,
    this.isLocked = false,
    this.customValidator,
    this.onTap,
  });

  @override
  State<UniversalField> createState() => _UniversalFieldState();
}

class _UniversalFieldState extends State<UniversalField> {
  bool _obscureText = true;

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.name:
        return TextInputType.name;
      case FieldType.password:
      case FieldType.text:
        return TextInputType.text;
    }
  }

  String? _validate(String? value) {
    if (widget.customValidator != null) {
      return widget.customValidator!(value);
    }

    if (value == null || value.isEmpty) {
      return 'Please enter ${widget.label.toLowerCase()}';
    }

    switch (widget.fieldType) {
      case FieldType.email:
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email';
        }
        break;
      case FieldType.phone:
        final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case FieldType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;
      case FieldType.name:
        if (value.length < 2) {
          return 'Name must be at least 2 characters';
        }
        break;
      case FieldType.text:
        break;
    }

    return null;
  }

  IconData _getIcon() {
    switch (widget.fieldType) {
      case FieldType.email:
        return Icons.email_outlined;
      case FieldType.password:
        return Icons.lock_outline;
      case FieldType.name:
        return Icons.person_outline;
      case FieldType.phone:
        return Icons.phone_outlined;
      case FieldType.text:
        return Icons.text_fields;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = NeumorphicTheme.isUsingDark(context);
    final baseColor = isDark
        ? NeumorphicAppTheme.darkBase
        : NeumorphicAppTheme.lightBase;

    return Neumorphic(
      style: NeumorphicStyle(
        depth: widget.isLocked ? 0 : -4,
        intensity: 0.65,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: baseColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: _getKeyboardType(),
        obscureText: widget.fieldType == FieldType.password && _obscureText,
        enabled: !widget.isLocked,
        validator: _validate,
        onTap: widget.onTap,
        style: TextStyle(
          color: widget.isLocked
              ? NeumorphicAppTheme.getSecondaryTextColor(context)
              : NeumorphicAppTheme.getTextColor(context),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: NeumorphicAppTheme.getSecondaryTextColor(context),
          ),
          prefixIcon: Icon(
            _getIcon(),
            color: widget.isLocked
                ? NeumorphicAppTheme.getSecondaryTextColor(context)
                : NeumorphicTheme.accentColor(context),
          ),
          suffixIcon: widget.fieldType == FieldType.password
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: NeumorphicAppTheme.getSecondaryTextColor(context),
                  ),
                  onPressed: widget.isLocked
                      ? null
                      : () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                )
              : widget.isLocked
                  ? Icon(
                      Icons.lock,
                      color: NeumorphicAppTheme.getSecondaryTextColor(context),
                      size: 20,
                    )
                  : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
