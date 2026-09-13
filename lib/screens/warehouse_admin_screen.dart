import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/catalog_provider.dart';
import '../theme/nexus_theme.dart';
import '../widgets/glass_container.dart';

class WarehouseAdminScreen extends ConsumerWidget {
  const WarehouseAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogProvider);
    final catalogNotifier = ref.read(catalogProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('WAREHOUSE & INVENTORY OPS', style: TextStyle(color: NexusTheme.primaryGold, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: catalogState.allProducts.length,
              itemBuilder: (ctx, i) {
                final p = catalogState.allProducts[i];
                return GlassContainer(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('SKU: ${p.sku}', style: const TextStyle(color: NexusTheme.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: NexusTheme.textMuted),
                            onPressed: () => catalogNotifier.updateStock(p.id, p.warehouseStock - 5),
                          ),
                          Text('${p.warehouseStock}', style: const TextStyle(color: NexusTheme.accentCyan, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add, color: NexusTheme.primaryGold),
                            onPressed: () => catalogNotifier.updateStock(p.id, p.warehouseStock + 10),
                          ),
                        ],
                      ),
                    ],
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
