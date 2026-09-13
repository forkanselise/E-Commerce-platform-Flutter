import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/nexus_theme.dart';
import 'glass_container.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.white10,
                      child: const Center(child: Icon(Icons.cake, color: NexusTheme.primaryGold, size: 40)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: NexusTheme.accentAmber, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${product.averageRating}',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.category.toUpperCase(),
            style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 10, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: NexusTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '৳${product.price.toStringAsFixed(0)}',
                style: const TextStyle(color: NexusTheme.accentCyan, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  ref.read(cartProvider.notifier).addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${product.title} to cart!'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: NexusTheme.surfaceDark,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: NexusTheme.goldGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add_shopping_cart, color: Colors.black, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
