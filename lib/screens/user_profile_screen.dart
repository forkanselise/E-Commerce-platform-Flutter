import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/nexus_theme.dart';
import '../widgets/auth_modal_sheet.dart';
import '../widgets/glass_container.dart';
import '../widgets/user_profile_modal_sheet.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final u = authState.user;

    if (!authState.isAuthenticated || u == null) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: NexusTheme.bgCocoaDark,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: NexusTheme.rosePrimary.withOpacity(0.35)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Prominent Buttercup Logo
                  Image.asset(
                    'assets/images/buttercup_logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => Image.asset(
                      'assets/images/Picture2.png',
                      height: 80,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: NexusTheme.roseGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cake, color: Colors.white, size: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Welcome to Buttercup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in or create an account to access order tracking, redeem loyalty rewards, join artisan masterclasses, and customize your profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: NexusTheme.textLightSecondary, fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: NexusTheme.rosePrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.login, size: 18),
                    label: const Text('SIGN IN TO YOUR ACCOUNT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => const AuthModalSheet(initialTab: 'login'),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: NexusTheme.roseLight,
                      side: const BorderSide(color: NexusTheme.rosePrimary, width: 1.2),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.person_add_alt_1, size: 18),
                    label: const Text('CREATE BUTTERCUP ACCOUNT', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => const AuthModalSheet(initialTab: 'register'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: NexusTheme.bgCocoaDark,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: NexusTheme.rosePrimary.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(u.avatarUrl),
                  backgroundColor: NexusTheme.rosePrimary,
                ),
                const SizedBox(height: 12),
                Text(u.fullName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(u.email, style: const TextStyle(color: NexusTheme.textLightSecondary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(u.phone, style: const TextStyle(color: NexusTheme.textMuted, fontSize: 12)),
                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: NexusTheme.primaryGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: NexusTheme.primaryGold.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.stars, color: NexusTheme.primaryGold, size: 16),
                          const SizedBox(width: 6),
                          Text('${u.loyaltyPoints} PTS', style: const TextStyle(color: NexusTheme.primaryGold, fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: NexusTheme.rosePrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: NexusTheme.rosePrimary.withOpacity(0.5)),
                      ),
                      child: Text(u.subscriptionTier, style: const TextStyle(color: NexusTheme.roseLight, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: NexusTheme.rosePrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('EDIT PROFILE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) => const UserProfileModalSheet(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: NexusTheme.alertRedText,
                        backgroundColor: NexusTheme.alertRedBg,
                        side: const BorderSide(color: NexusTheme.alertRedBorder),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.logout, size: 16),
                      label: const Text('SIGN OUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      onPressed: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: NexusTheme.bgCocoaDark,
                              content: Text('You have been signed out.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Account Details Section
          const Text('ACCOUNT DETAILS', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildProfileDetailRow(Icons.email_outlined, 'Email Address', u.email),
                const Divider(color: NexusTheme.cardBorder),
                _buildProfileDetailRow(Icons.phone_outlined, 'Phone Number', u.phone),
                const Divider(color: NexusTheme.cardBorder),
                _buildProfileDetailRow(Icons.location_on_outlined, 'Delivery Address', u.address),
                const Divider(color: NexusTheme.cardBorder),
                _buildProfileDetailRow(Icons.security_outlined, 'Account Role', u.role),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Recent Orders Header
          const Text('RECENT ORDERS', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          GlassContainer(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: NexusTheme.rosePrimary.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.receipt_long, color: NexusTheme.roseLight, size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #SMART-842019', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Callebaut Chocolate & Anchor Cream', style: TextStyle(color: NexusTheme.textLightSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Delivered', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: NexusTheme.primaryGold, size: 18),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: NexusTheme.textLightSecondary, fontSize: 13)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}

