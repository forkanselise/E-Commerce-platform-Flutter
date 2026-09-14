import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_provider.dart';
import '../providers/mobile_phone_provider.dart';
import '../providers/navigation_provider.dart';
import '../theme/nexus_theme.dart';
import '../widgets/glass_container.dart';
import '../widgets/product_card.dart';
import '../widgets/mobile_phone_card.dart';
import '../widgets/cart_drawer_sheet.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogProvider);
    final catalogNotifier = ref.read(catalogProvider.notifier);
    final categories = ref.watch(categoriesProvider);
    final phoneState = ref.watch(mobilePhoneProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Glass Banner
          GlassContainer(
            padding: const EdgeInsets.all(20),
            color: NexusTheme.surfaceDark.withOpacity(0.9),
            border: Border.all(color: NexusTheme.primaryGold.withOpacity(0.4), width: 1.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: NexusTheme.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('BUTTERCUP • ARTISAN BAKERY & TECH HUB', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Everything You Need to Bake, Learn & Indulge',
                  style: TextStyle(color: NexusTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 16),

                // Top Action Buttons Bar
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NexusTheme.rosePrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: const Icon(Icons.shopping_bag, size: 16),
                      label: const Text('ORDER NOW', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const CartDrawerSheet(),
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: NexusTheme.surfaceDark,
                        foregroundColor: NexusTheme.primaryGold,
                        side: const BorderSide(color: NexusTheme.primaryGold, width: 1),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      icon: const Icon(Icons.school, size: 16),
                      label: const Text('JOIN CLASS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        ref.read(navigationIndexProvider.notifier).state = 3; // Academy tab
                      },
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: NexusTheme.accentCyan,
                        side: const BorderSide(color: NexusTheme.accentCyan, width: 1),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.smart_toy, size: 16),
                      label: const Text('Ask Mr. Butter AI', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        ref.read(navigationIndexProvider.notifier).state = 4; // AI Concierge tab
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Text(
                  'Discover Belgian Callebaut chocolate, Anchor dairy, French flour, artisan tools, and flagship smartphones backed by multi-agent AI.',
                  style: TextStyle(color: NexusTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('CATEGORIES', style: TextStyle(color: NexusTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                final cat = categories[i];
                final isSel = catalogState.selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    catalogNotifier.setCategory(cat);
                    ref.read(navigationIndexProvider.notifier).state = 1; // Catalog tab
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? NexusTheme.primaryGold : NexusTheme.cardGlass,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSel ? NexusTheme.primaryGold : NexusTheme.cardBorder),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('FEATURED INGREDIENTS & TOOLS', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => ref.read(navigationIndexProvider.notifier).state = 1,
                child: Text('${catalogState.featuredProducts.length} items', style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: catalogState.featuredProducts.length,
            itemBuilder: (ctx, i) => ProductCard(product: catalogState.featuredProducts[i]),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('FLAGSHIP MOBILE PHONES', style: TextStyle(color: NexusTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => ref.read(navigationIndexProvider.notifier).state = 2,
                child: const Text('View All', style: TextStyle(color: NexusTheme.accentCyan, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: phoneState.phones.length,
              itemBuilder: (ctx, i) {
                return SizedBox(
                  width: 170,
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: MobilePhoneCard(phone: phoneState.phones[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

