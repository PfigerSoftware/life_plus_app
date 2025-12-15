import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/neumorphic_theme.dart';
import '../widgets/universal_field.dart';
import '../widgets/neumorphic_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isEditing = false;
  String? _originalEmail;
  String? _originalMobile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = ref.read(authProvider).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _mobileController.text = user.mobile??'';
      _passwordController.text = '••••••••'; // Masked password
      _originalEmail = user.email;
      _originalMobile = user.mobile;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Cancel editing - reload original data
        _loadUserData();
      }
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Check if email changed
      if (_emailController.text != _originalEmail) {
        _showVerificationDialog('Email', 'verification email');
        return;
      }

      // Check if mobile changed
      if (_mobileController.text != _originalMobile) {
        _showVerificationDialog('Mobile', 'OTP');
        return;
      }

      // Save changes (in real app, call API)
      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: NeumorphicTheme.accentColor(context),
        ),
      );
    }
  }

  void _showVerificationDialog(String field, String verificationType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeumorphicTheme.baseColor(context),
        title: Text(
          '$field Verification Required',
          style: NeumorphicTheme.currentTheme(context).textTheme.titleLarge,
        ),
        content: Text(
          'A $verificationType has been sent to verify your new $field. Please check and confirm.',
          style: NeumorphicTheme.currentTheme(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: NeumorphicTheme.accentColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'My Profile',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Icon
                Center(
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      depth: 8,
                      intensity: 0.65,
                      boxShape: const NeumorphicBoxShape.circle(),
                      color: NeumorphicTheme.baseColor(context),
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: NeumorphicTheme.accentColor(context),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Name Field
                UniversalField(
                  fieldType: FieldType.name,
                  controller: _nameController,
                  label: 'Full Name',
                  isLocked: !_isEditing,
                ),
                const SizedBox(height: 20),

                // Email Field
                UniversalField(
                  fieldType: FieldType.email,
                  controller: _emailController,
                  label: 'Email',
                  isLocked: !_isEditing,
                ),
                const SizedBox(height: 20),

                // Mobile Field
                UniversalField(
                  fieldType: FieldType.phone,
                  controller: _mobileController,
                  label: 'Mobile Number',
                  isLocked: !_isEditing,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Optional
                    }
                    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field
                UniversalField(
                  fieldType: FieldType.password,
                  controller: _passwordController,
                  label: 'Password',
                  isLocked: !_isEditing,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                if (!_isEditing)
                  NeumorphicCustomButton(
                    text: 'Change Details',
                    onPressed: _toggleEditing,
                    icon: Icons.edit,
                  )
                else
                  Column(
                    children: [
                      NeumorphicCustomButton(
                        text: 'Save Changes',
                        onPressed: _saveChanges,
                        icon: Icons.save,
                      ),
                      const SizedBox(height: 16),
                      NeumorphicButton(
                        onPressed: _toggleEditing,
                        style: NeumorphicStyle(
                          depth: 4,
                          intensity: 0.65,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12),
                          ),
                          color: NeumorphicTheme.baseColor(context),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel,
                              color: NeumorphicAppTheme.getSecondaryTextColor(
                                  context),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                color: NeumorphicAppTheme.getSecondaryTextColor(
                                    context),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
