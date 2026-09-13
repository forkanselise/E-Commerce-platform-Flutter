import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../theme/nexus_theme.dart';
import 'auth_modal_sheet.dart';
import 'cart_drawer_sheet.dart';
import 'user_profile_modal_sheet.dart';

class NexusNavbar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  const NexusNavbar({super.key, this.title = 'BUTTERCUP'});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final u = authState.user;

    return AppBar(
      toolbarHeight: 64,
      elevation: 2,
      backgroundColor: NexusTheme.bgCocoaDark,
      title: Row(
        children: [
          Image.asset(
            'assets/images/buttercup_logo.png',
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (ctx, err, stack) => Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                gradient: NexusTheme.roseGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cake, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: NexusTheme.primaryGold,
                ),
              ),
              const Text(
                'Bake • Make • Learn',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: NexusTheme.roseLight,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Cart Button with Counter
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const CartDrawerSheet(),
                );
              },
            ),
            if (cartState.totalItemCount > 0)
              Positioned(
                right: 6,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: NexusTheme.rosePrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cartState.totalItemCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),

        // Auth Control: Profile Avatar (Logged In) OR Login Button (Logged Out)
        if (authState.isAuthenticated && u != null) ...[
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => const UserProfileModalSheet(),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NexusTheme.bgCocoaDeeper,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: NexusTheme.rosePrimary.withOpacity(0.6)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(u.avatarUrl),
                    backgroundColor: NexusTheme.rosePrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    u.fullName.split(' ')[0],
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: NexusTheme.rosePrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.person, size: 16),
              label: const Text('LOGIN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const AuthModalSheet(initialTab: 'login'),
                );
              },
            ),
          ),
        ],
        const SizedBox(width: 6),
      ],
    );
  }
}
