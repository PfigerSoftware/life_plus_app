import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/neumorphic_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    return NeumorphicApp(
      title: 'Life Plus',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: NeumorphicAppTheme.lightTheme,
      darkTheme: NeumorphicAppTheme.darkTheme,
      home: authState.user != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}
