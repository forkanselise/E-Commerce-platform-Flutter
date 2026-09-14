import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/nexus_theme.dart';

class AuthModalSheet extends ConsumerStatefulWidget {
  final String initialTab; // 'login' | 'register'
  const AuthModalSheet({super.key, this.initialTab = 'login'});

  @override
  ConsumerState<AuthModalSheet> createState() => _AuthModalSheetState();
}

class _AuthModalSheetState extends ConsumerState<AuthModalSheet> {
  late String _activeTab;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final authNotifier = ref.read(authProvider.notifier);
    bool success = false;

    if (_activeTab == 'register') {
      success = await authNotifier.register(
        _fullNameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } else {
      success = await authNotifier.login(
        _emailController.text,
        _passwordController.text,
      );
    }

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: NexusTheme.bgCocoaDark,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: NexusTheme.primaryGold, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _activeTab == 'register'
                      ? 'Account created! Welcome to Buttercup.'
                      : 'Signed in successfully! Welcome back.',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Color(0x333D2314),
              blurRadius: 35,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet Handlebar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D2314).withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Close Button & Header
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: NexusTheme.bgBase,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: NexusTheme.textDarkPrimary),
                    ),
                  ),
                ],
              ),

              // Logo & Title Header
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/buttercup_logo.png',
                      height: 58,
                      fit: BoxFit.contain,
                      errorBuilder: (ctx, err, stack) => Image.asset(
                        'assets/images/Picture2.png',
                        height: 58,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            gradient: NexusTheme.roseGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cake, color: Colors.white, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _activeTab == 'login' ? 'Sign In to Buttercup' : 'Create Buttercup Account',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: NexusTheme.textDarkPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _activeTab == 'login'
                          ? 'Enter your credentials to access your account'
                          : 'Fill in your details below to register',
                      style: const TextStyle(
                        fontSize: 13,
                        color: NexusTheme.textDarkSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Tab Switcher (Sign In vs Create Account)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: NexusTheme.bgBase,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NexusTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _activeTab = 'login');
                          ref.read(authProvider.notifier).clearError();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _activeTab == 'login' ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _activeTab == 'login'
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF3D2314).withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: _activeTab == 'login' ? NexusTheme.textDarkPrimary : NexusTheme.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _activeTab = 'register');
                          ref.read(authProvider.notifier).clearError();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _activeTab == 'register' ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _activeTab == 'register'
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF3D2314).withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: _activeTab == 'register' ? NexusTheme.textDarkPrimary : NexusTheme.textMuted,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Error Alert Banner (Matching React web app error alert)
              if (authState.error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: NexusTheme.alertRedBg,
                    border: Border.all(color: NexusTheme.alertRedBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: NexusTheme.alertRedText, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          authState.error!,
                          style: const TextStyle(
                            color: NexusTheme.alertRedText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Form Inputs
              if (_activeTab == 'register') ...[
                const Text(
                  'Full Name *',
                  style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _fullNameController,
                  style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 14),
                  decoration: NexusTheme.authInputDecoration(
                    hintText: 'e.g. Chef Sarah Rahman',
                    prefixIcon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 14),
              ],

              const Text(
                'Email Address *',
                style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 14),
                decoration: NexusTheme.authInputDecoration(
                  hintText: 'baker@smartbakery.com',
                  prefixIcon: Icons.email_outlined,
                ),
              ),
              const SizedBox(height: 14),

              const Text(
                'Password *',
                style: TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: NexusTheme.textDarkPrimary, fontSize: 14),
                decoration: NexusTheme.authInputDecoration(
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: NexusTheme.textMuted,
                      size: 18,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Primary Action Submit Button (Rose Primary matching web platform)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NexusTheme.rosePrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: authState.isLoading ? null : _handleSubmit,
                child: authState.isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _activeTab == 'login' ? 'Signing In...' : 'Registering Account...',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                        ],
                      )
                    : Text(
                        _activeTab == 'login' ? 'Sign In' : 'Create Account',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
              ),

              const SizedBox(height: 16),

              // Tab Switcher Link
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _activeTab = _activeTab == 'login' ? 'register' : 'login';
                    });
                    ref.read(authProvider.notifier).clearError();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: _activeTab == 'login' ? "Don't have an account? " : "Already have an account? ",
                      style: const TextStyle(color: NexusTheme.textDarkSecondary, fontSize: 13),
                      children: [
                        TextSpan(
                          text: _activeTab == 'login' ? 'Sign up now' : 'Log in here',
                          style: const TextStyle(
                            color: NexusTheme.rosePrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

