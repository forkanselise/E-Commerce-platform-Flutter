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
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Showing ${catalogState.products.length} Products',
            style: const TextStyle(color: NexusTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: catalogState.products.isEmpty
                ? const Center(
                    child: Text('No products matching query', style: TextStyle(color: NexusTheme.textMuted)),
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
