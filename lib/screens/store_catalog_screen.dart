import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_provider.dart';
import '../theme/nexus_theme.dart';
import '../widgets/product_card.dart';

class StoreCatalogScreen extends ConsumerWidget {
  const StoreCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogProvider);
    final catalogNotifier = ref.read(catalogProvider.notifier);
    final categories = ref.watch(categoriesProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (val) => catalogNotifier.setSearchQuery(val),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search ingredients, chocolate, butter, spatulas...',
              hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: NexusTheme.primaryGold),
              filled: true,
              fillColor: NexusTheme.cardGlass,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: NexusTheme.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: NexusTheme.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: NexusTheme.rosePrimary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (ctx, i) {
                final cat = categories[i];
                final isSel = catalogState.selectedCategory == cat;
                return GestureDetector(
                  onTap: () => catalogNotifier.setCategory(cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSel ? NexusTheme.primaryGold : NexusTheme.cardGlass,
                      borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing ${catalogState.products.length} Products',
                style: const TextStyle(color: NexusTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              if (catalogState.selectedCategory != 'All' || catalogState.searchQuery.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    catalogNotifier.setCategory('All');
                    catalogNotifier.setSearchQuery('');
                  },
                  child: const Text('Reset Filters', style: TextStyle(color: NexusTheme.roseLight, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: catalogState.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, color: NexusTheme.textMuted, size: 48),
                        SizedBox(height: 12),
                        Text('No products matching query', style: TextStyle(color: NexusTheme.textMuted, fontSize: 14)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: catalogState.products.length,
                    itemBuilder: (ctx, i) => ProductCard(product: catalogState.products[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

