import '../models/product.dart';
import 'api_service.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final res = await ApiService.get('/Products');
    if (res != null && res is List && res.isNotEmpty) {
      return res.map((p) => Product.fromJson(p)).toList();
    }
    return INITIAL_PRODUCTS;
  }
}
