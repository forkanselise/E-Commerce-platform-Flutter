import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../theme/nexus_theme.dart';
import 'glass_container.dart';

class CartDrawerSheet extends ConsumerStatefulWidget {
  const CartDrawerSheet({super.key});

  @override
  ConsumerState<CartDrawerSheet> createState() => _CartDrawerSheetState();
}

class _CartDrawerSheetState extends ConsumerState<CartDrawerSheet> {
  final TextEditingController _promoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: NexusTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag, color: NexusTheme.primaryGold),
                  const SizedBox(width: 8),
                  Text(
                    'Your Shopping Cart (${cartState.totalItemCount})',
                    style: const TextStyle(color: NexusTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: NexusTheme.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: Colors.white10),
          Expanded(
            child: cartState.items.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.remove_shopping_cart, color: NexusTheme.textMuted, size: 48),
                        SizedBox(height: 12),
                        Text('Your cart is empty', style: TextStyle(color: NexusTheme.textMuted, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartState.items.length,
                    itemBuilder: (ctx, i) {
                      final item = cartState.items[i];
                      return GlassContainer(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.thumbnail, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: const TextStyle(color: NexusTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1),
                                  const SizedBox(height: 2),
                                  Text('৳${item.price.toStringAsFixed(0)}', style: const TextStyle(color: NexusTheme.accentCyan, fontSize: 12)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: NexusTheme.textMuted, size: 20),
                                  onPressed: () => cartNotifier.updateQuantity(item.productId, -1),
                                ),
                                Text('${item.quantity}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: NexusTheme.primaryGold, size: 20),
                                  onPressed: () => cartNotifier.updateQuantity(item.productId, 1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (cartState.items.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCtrl,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Enter Promo Code (e.g. NEXUS10)',
                      hintStyle: const TextStyle(color: NexusTheme.textMuted, fontSize: 12),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final ok = cartNotifier.applyCoupon(_promoCtrl.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ok ? '10% Discount Applied!' : 'Invalid Promo Code')),
                    );
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GlassContainer(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Subtotal', style: TextStyle(color: NexusTheme.textMuted)),
                    Text('৳${cartState.subtotal.toStringAsFixed(0)} BDT', style: const TextStyle(color: Colors.white)),
                  ]),
                  if (cartState.discountPercent > 0)
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Discount (10%)', style: TextStyle(color: NexusTheme.accentGreen)),
                      Text('-৳${cartState.discountAmount.toStringAsFixed(0)} BDT', style: const TextStyle(color: NexusTheme.accentGreen)),
                    ]),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Shipping', style: TextStyle(color: NexusTheme.textMuted)),
                    Text(cartState.shippingCost == 0 ? 'FREE' : '৳120 BDT', style: TextStyle(color: cartState.shippingCost == 0 ? NexusTheme.accentGreen : Colors.white)),
                  ]),
                  const Divider(color: Colors.white10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('৳${cartState.total.toStringAsFixed(0)} BDT', style: const TextStyle(color: NexusTheme.primaryGold, fontWeight: FontWeight.bold, fontSize: 18)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  cartNotifier.clearCart();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🎉 Order Placed Successfully! Order #NEXUS-889102')),
                  );
                },
                child: const Text('PROCEED TO CHECKOUT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
