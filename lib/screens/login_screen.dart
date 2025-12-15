import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/universal_field.dart';
import '../widgets/neumorphic_button.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authProvider.notifier).login(
            _identifierController.text,
            _passwordController.text,
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
                  // Logo/Icon
                  Neumorphic(
                    style: NeumorphicStyle(
                      depth: 8,
                      intensity: 0.65,
                      boxShape: const NeumorphicBoxShape.circle(),
                      color: NeumorphicTheme.baseColor(context),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 64,
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Welcome Back',
                    style: NeumorphicTheme.currentTheme(context)
                        .textTheme
                        .displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: NeumorphicTheme.currentTheme(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email/Mobile Field
                  UniversalField(
                    fieldType: FieldType.text,
                    controller: _identifierController,
                    label: 'Email or Mobile Number',
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  UniversalField(
                    fieldType: FieldType.password,
                    controller: _passwordController,
                    label: 'Password',
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

                  // Login Button
                  NeumorphicCustomButton(
                    text: 'Login',
                    onPressed: authState.isLoading ? null : _login,
                    isLoading: authState.isLoading,
                  ),
                  const SizedBox(height: 32),

                  // Register Link
                  Center(
                    child: NeumorphicButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        );
                      },
                      style: NeumorphicStyle(
                        depth: 0,
                        intensity: 0,
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Don\'t have an account? Register now',
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
