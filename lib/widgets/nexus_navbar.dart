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
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final u = authState.user;

    return AppBar(
      toolbarHeight: 66,
      elevation: 0,
      backgroundColor: NexusTheme.bgCocoaDark,
      titleSpacing: 12,
      title: InkWell(
        onTap: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/buttercup_logo.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => Image.asset(
                'assets/images/Picture2.png',
                height: 50,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    gradient: NexusTheme.roseGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cake, color: Colors.white, size: 20),
                ),
              ),
            ),
            // const SizedBox(width: 10),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       title,
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w900,
            //         letterSpacing: 1.2,
            //         color: NexusTheme.primaryGold,
            //       ),
            //     ),
            //     const Text(
            //       'Bake • Make • Learn',
            //       style: TextStyle(
            //         fontSize: 9,
            //         fontWeight: FontWeight.w700,
            //         color: NexusTheme.roseLight,
            //         letterSpacing: 0.8,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      actions: [
        // Cart Button with Counter
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_bag_outlined,
                  color: Colors.white, size: 22),
              tooltip: 'Shopping Cart',
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
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: NexusTheme.rosePrimary,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Center(
                    child: Text(
                      '${cartState.totalItemCount}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),

        // Auth Control: Profile Avatar (Logged In) OR Login Button (Logged Out)
        if (authState.isAuthenticated && u != null) ...[
          PopupMenuButton<String>(
            tooltip: 'User Menu',
            offset: const Offset(0, 48),
            color: NexusTheme.bgSurface,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onSelected: (val) async {
              if (val == 'profile') {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const UserProfileModalSheet(),
                );
              } else if (val == 'logout') {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: NexusTheme.bgCocoaDark,
                      content: Text('You have signed out from Buttercup.'),
                    ),
                  );
                }
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(u.avatarUrl),
                      backgroundColor: NexusTheme.rosePrimary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u.fullName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: NexusTheme.textDarkPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            u.subscriptionTier,
                            style: const TextStyle(
                                fontSize: 11,
                                color: NexusTheme.rosePrimary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline,
                        color: NexusTheme.textDarkSecondary, size: 18),
                    SizedBox(width: 10),
                    Text('My Account Profile',
                        style: TextStyle(
                            fontSize: 13, color: NexusTheme.textDarkPrimary)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout,
                        color: NexusTheme.alertRedText, size: 18),
                    SizedBox(width: 10),
                    Text('Sign Out',
                        style: TextStyle(
                            fontSize: 13,
                            color: NexusTheme.alertRedText,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: NexusTheme.bgCocoaDeeper,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: NexusTheme.rosePrimary.withOpacity(0.6)),
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.keyboard_arrow_down,
                      color: NexusTheme.textMuted, size: 14),
                ],
              ),
            ),
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: NexusTheme.rosePrimary,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.person, size: 15),
              label: const Text('LOGIN',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8)),
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
