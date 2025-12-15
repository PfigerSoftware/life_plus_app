import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/universal_field.dart';
import '../widgets/neumorphic_button.dart';
import 'home_screen.dart';
import 'verify_otp_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userId = await ref.read(authProvider.notifier).register(
          name: _nameController.text,
          password: _passwordController.text,
          mobile: _mobileController.text,
          email: _emailController.text,
          productId: 1, // Default productId
        );

        if (mounted) {
          // Navigate to OTP verification screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => VerifyOtpScreen(
                  userId: userId.toString(),
                  mobileNo: _mobileController.text
              ),
            ),
          );
        }
      } catch (e) {
        // Error is handled by provider
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
          'Create Account',
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
                      Icons.person_add_outlined,
                      size: 56,
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Subtitle
                  Text(
                    'Fill in your details to get started',
                    style: NeumorphicTheme.currentTheme(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Name Field (Required)
                  UniversalField(
                    fieldType: FieldType.name,
                    controller: _nameController,
                    label: 'Full Name *',
                  ),
                  const SizedBox(height: 20),

                  // Mobile Number Field (Required)
                  UniversalField(
                    fieldType: FieldType.phone,
                    controller: _mobileController,
                    label: 'Mobile Number *',
                  ),
                  const SizedBox(height: 20),

                  // Email Field (Required now)
                  UniversalField(
                    fieldType: FieldType.email,
                    controller: _emailController,
                    label: 'Email *',
                  ),
                  const SizedBox(height: 20),

                  // Password Field (Required)
                  UniversalField(
                    fieldType: FieldType.password,
                    controller: _passwordController,
                    label: 'Password *',
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

                  // Register Button
                  NeumorphicCustomButton(
                    text: 'Register',
                    onPressed: authState.isLoading ? null : _register,
                    isLoading: authState.isLoading,
                    icon: Icons.person_add,
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Center(
                    child: NeumorphicButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: NeumorphicStyle(
                        depth: 0,
                        intensity: 0,
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: NeumorphicTheme.accentColor(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
