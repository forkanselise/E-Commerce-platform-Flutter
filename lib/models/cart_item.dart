class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final String thumbnail;
  int quantity;
  final String sku;

  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.quantity,
    required this.sku,
  });

  double get totalPrice => price * quantity;
}
