import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mobile_phone.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/nexus_theme.dart';
import 'glass_container.dart';

class MobilePhoneCard extends ConsumerWidget {
  final MobilePhone phone;
  const MobilePhoneCard({super.key, required this.phone});

  void _showPhoneDetail(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: NexusTheme.bgCocoaDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                phone.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(height: 200, color: Colors.white10, child: const Icon(Icons.phone_iphone, size: 64, color: NexusTheme.accentCyan)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: NexusTheme.accentCyan.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text(phone.brand.toUpperCase(), style: const TextStyle(color: NexusTheme.accentCyan, fontWeight: FontWeight.bold, fontSize: 11)),
                ),
                const Spacer(),
                Text('৳${phone.price.toStringAsFixed(0)} BDT', style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 20, fontWeight: FontWeight.extrabold)),
              ],
            ),
            const SizedBox(height: 10),
            Text(phone.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(phone.description, style: const TextStyle(color: NexusTheme.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            const Text('TECH SPECIFICATIONS', style: TextStyle(color: NexusTheme.accentCyan, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: phone.specs.entries.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: NexusTheme.surfaceDark, borderRadius: BorderRadius.circular(10), border: Border.all(color: NexusTheme.cardBorder)),
                  child: Text('${e.key.toUpperCase()}: ${e.value}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NexusTheme.rosePrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.shopping_bag, size: 18),
                label: const Text('ADD FLAGSHIP PHONE TO CART', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  final prod = Product(
                    id: phone.id,
                    title: phone.name,
                    slug: phone.slug,
                    category: 'Mobile Phones',
                    subCategory: phone.brand,
                    description: phone.description,
                    shortDescription: phone.description,
                    price: phone.price,
                    compareAtPrice: phone.price * 1.1,
                    sku: 'PHONE-${phone.brand}-${phone.id}',
                    warehouseStock: phone.stock,
                    isAvailable: phone.stock > 0,
                    isFeatured: true,
                    averageRating: phone.rating,
                    reviewCount: 150,
                    imageUrl: phone.imageUrl,
                    tags: [phone.brand, 'smartphone', 'tech-gear'],
                  );
                  ref.read(cartProvider.notifier).addItem(prod);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(backgroundColor: NexusTheme.bgCocoaDark, content: Text('Added ${phone.name} to cart!')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showPhoneDetail(context, ref),
      child: GlassContainer(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  phone.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    color: Colors.white10,
                    child: const Center(child: Icon(Icons.phone_iphone, color: NexusTheme.accentCyan, size: 40)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: NexusTheme.accentCyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                phone.brand.toUpperCase(),
                style: const TextStyle(color: NexusTheme.accentCyan, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              phone.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: NexusTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              phone.specs['screen'] ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: NexusTheme.textMuted, fontSize: 10),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '৳${phone.price.toStringAsFixed(0)}',
                  style: const TextStyle(color: NexusTheme.primaryGold, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_forward_ios, color: NexusTheme.textSecondary, size: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

