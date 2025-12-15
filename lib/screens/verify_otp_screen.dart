import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/universal_field.dart';
import '../widgets/neumorphic_button.dart';
import 'home_screen.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String userId;
  final String mobileNo;

  const VerifyOtpScreen({super.key, required this.userId, required this.mobileNo});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).verifyOtp(
        widget.userId,
        _otpController.text,
      );

      if (mounted && ref.read(authProvider).user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isDark = NeumorphicTheme.isUsingDark(context);

    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Verify OTP',
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 8,
                      intensity: 0.65,
                      boxShape: const NeumorphicBoxShape.circle(),
                      color: NeumorphicTheme.baseColor(context),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Icon(
                      Icons.message_outlined,
                      size: 56,
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Enter Verification Code',
                    style: NeumorphicTheme.currentTheme(context)
                        .textTheme
                        .displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'We sent a code to ${widget.mobileNo}',
                    style: NeumorphicTheme.currentTheme(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // OTP Field
                  UniversalField(
                    fieldType: FieldType.text,
                    controller: _otpController,
                    label: 'Enter OTP',
                    customValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      }
                      // Length check might vary, usually 4 or 6. keeping 6 as per previous code
                      if (value.length != 6) {
                        return 'OTP must be 6 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Error Message
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        authState.error!,
                        style: TextStyle(
                          color: isDark ? Colors.red[300] : Colors.red[700],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Verify Button
                  NeumorphicCustomButton(
                    text: 'Verify',
                    onPressed: authState.isLoading ? null : _verifyOtp,
                    isLoading: authState.isLoading,
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
