import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartState {
  final List<CartItem> items;
  final String couponCode;
  final double discountPercent;

  CartState({
    required this.items,
    this.couponCode = '',
    this.discountPercent = 0,
  });

  int get totalItemCount => items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => items.fold(0.0, (sum, i) => sum + i.totalPrice);
  double get discountAmount => (subtotal * discountPercent) / 100;
  double get shippingCost => subtotal == 0 ? 0 : (subtotal > 2500 ? 0 : 120);
  double get total => (subtotal - discountAmount + shippingCost).clamp(0, double.infinity);

  CartState copyWith({
    List<CartItem>? items,
    String? couponCode,
    double? discountPercent,
  }) {
    return CartState(
      items: items ?? this.items,
      couponCode: couponCode ?? this.couponCode,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  void addItem(Product product, {int quantity = 1}) {
    final currentItems = List<CartItem>.from(state.items);
    final idx = currentItems.indexWhere((i) => i.productId == product.id);
    if (idx > -1) {
      currentItems[idx].quantity += quantity;
    } else {
      currentItems.add(CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        productId: product.id,
        title: product.title,
        price: product.price,
        thumbnail: product.imageUrl,
        quantity: quantity,
        sku: product.sku,
      ));
    }
    state = state.copyWith(items: currentItems);
  }

  void removeItem(String productId) {
    final currentItems = state.items.where((i) => i.productId != productId).toList();
    state = state.copyWith(items: currentItems);
  }

  void updateQuantity(String productId, int delta) {
    final currentItems = List<CartItem>.from(state.items);
    final idx = currentItems.indexWhere((i) => i.productId == productId);
    if (idx > -1) {
      currentItems[idx].quantity += delta;
      if (currentItems[idx].quantity <= 0) {
        currentItems.removeAt(idx);
      }
      state = state.copyWith(items: currentItems);
    }
  }

  void clearCart() {
    state = CartState(items: []);
  }

  bool applyCoupon(String code) {
    if (code.trim().toUpperCase() == 'NEXUS10') {
      state = state.copyWith(couponCode: 'NEXUS10', discountPercent: 10);
      return true;
    }
    return false;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) => CartNotifier());
