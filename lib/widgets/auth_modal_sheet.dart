import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/nexus_theme.dart';
import 'glass_container.dart';

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
          backgroundColor: Colors.green.shade800,
          content: Text(
            _activeTab == 'register' ? 'Account created successfully! Welcome to Buttercup.' : 'Signed in successfully!',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: NexusTheme.surfaceDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(top: BorderSide(color: NexusTheme.primaryGold, width: 1.5)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sheet Handlebar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/buttercup_logo.png',
                        height: 36,
                        fit: BoxFit.contain,
                        errorBuilder: (ctx, err, stack) => Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            gradient: NexusTheme.roseGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.lock, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _activeTab == 'login' ? 'Sign In to Buttercup' : 'Create Account',
                        style: const TextStyle(
                          color: NexusTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: NexusTheme.textMuted),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _activeTab == 'login'
                    ? 'Enter your email & password to access your account.'
                    : 'Fill in your details below to register a new account.',
                style: const TextStyle(color: NexusTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Tab Switcher (Sign In vs Create Account)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: NexusTheme.cardGlass,
                  borderRadius: BorderRadius.circular(16),
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _activeTab == 'login' ? NexusTheme.primaryGold : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: _activeTab == 'login' ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _activeTab == 'register' ? NexusTheme.primaryGold : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: _activeTab == 'register' ? Colors.black : Colors.white,
                                fontWeight: FontWeight.bold,
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
              const SizedBox(height: 20),

              // Error Alert Banner
              if (authState.error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: NexusTheme.accentRed.withOpacity(0.15),
                    border: Border.all(color: NexusTheme.accentRed),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: NexusTheme.accentRed, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          authState.error!,
                          style: const TextStyle(color: NexusTheme.accentRed, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

              // Form Inputs
              if (_activeTab == 'register') ...[
                const Text('Full Name *', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: _fullNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: NexusTheme.primaryGold, size: 20),
                    hintText: 'Chef Sarah Rahman',
                    hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 13),
                    filled: true,
                    fillColor: NexusTheme.cardGlass,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: NexusTheme.cardBorder)),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              const Text('Email Address *', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: NexusTheme.primaryGold, size: 20),
                  hintText: 'baker@smartbakery.com',
                  hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: NexusTheme.cardGlass,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: NexusTheme.cardBorder)),
                ),
              ),
              const SizedBox(height: 14),

              const Text('Password *', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, color: NexusTheme.primaryGold, size: 20),
                  hintText: '••••••••',
                  hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: NexusTheme.cardGlass,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: NexusTheme.cardBorder)),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NexusTheme.accentRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: authState.isLoading ? null : _handleSubmit,
                child: authState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _activeTab == 'login' ? 'SIGN IN' : 'CREATE ACCOUNT',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                      ),
              ),

              const SizedBox(height: 16),
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
                      style: const TextStyle(color: NexusTheme.textSecondary, fontSize: 13),
                      children: [
                        TextSpan(
                          text: _activeTab == 'login' ? 'Sign up now' : 'Log in here',
                          style: const TextStyle(color: NexusTheme.primaryGold, fontWeight: FontWeight.bold),
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
