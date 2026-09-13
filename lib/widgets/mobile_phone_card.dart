import 'package:flutter/material.dart';
import '../models/mobile_phone.dart';
import '../theme/nexus_theme.dart';
import 'glass_container.dart';

class MobilePhoneCard extends StatelessWidget {
  final MobilePhone phone;
  const MobilePhoneCard({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
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
    );
  }
}
