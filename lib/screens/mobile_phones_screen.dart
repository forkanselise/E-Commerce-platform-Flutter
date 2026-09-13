import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mobile_phone_provider.dart';
import '../theme/nexus_theme.dart';
import '../widgets/mobile_phone_card.dart';

class MobilePhonesScreen extends ConsumerWidget {
  const MobilePhonesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneState = ref.watch(mobilePhoneProvider);
    final phoneNotifier = ref.read(mobilePhoneProvider.notifier);
    final brands = ref.watch(phoneBrandsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MOBILE PHONES & TECH GEAR HUB',
            style: TextStyle(color: NexusTheme.accentCyan, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              itemBuilder: (ctx, i) {
                final brand = brands[i];
                final isSel = phoneState.selectedBrand == brand;
                return GestureDetector(
                  onTap: () => phoneNotifier.setBrand(brand),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSel ? NexusTheme.accentCyan : NexusTheme.cardGlass,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSel ? NexusTheme.accentCyan : NexusTheme.cardBorder),
                    ),
                    child: Text(
                      brand,
                      style: TextStyle(color: isSel ? Colors.black : Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: phoneState.phones.length,
              itemBuilder: (ctx, i) => MobilePhoneCard(phone: phoneState.phones[i]),
            ),
          ),
        ],
      ),
    );
  }
}
