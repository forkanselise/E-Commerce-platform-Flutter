import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class CatalogState {
  final List<Product> allProducts;
  final String selectedCategory;
  final String searchQuery;
  final bool isLoading;

  CatalogState({
    required this.allProducts,
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<Product> get products {
    return allProducts.where((p) {
      final matchesCat = selectedCategory == 'All' || p.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesSearch = searchQuery.isEmpty || p.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();
  }

  List<Product> get featuredProducts => allProducts.where((p) => p.isFeatured).toList();

  CatalogState copyWith({
    List<Product>? allProducts,
    String? selectedCategory,
    String? searchQuery,
    bool? isLoading,
  }) {
    return CatalogState(
      allProducts: allProducts ?? this.allProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CatalogNotifier extends StateNotifier<CatalogState> {
  CatalogNotifier() : super(CatalogState(allProducts: INITIAL_PRODUCTS)) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);
    final prods = await ProductService.fetchProducts();
    state = state.copyWith(allProducts: prods, isLoading: false);
  }

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateStock(String productId, int newStock) {
    final prods = List<Product>.from(state.allProducts);
    final idx = prods.indexWhere((p) => p.id == productId);
    if (idx > -1) {
      final old = prods[idx];
      prods[idx] = Product(
        id: old.id,
        title: old.title,
        slug: old.slug,
        category: old.category,
        subCategory: old.subCategory,
        description: old.description,
        shortDescription: old.shortDescription,
        price: old.price,
        compareAtPrice: old.compareAtPrice,
        sku: old.sku,
        warehouseStock: newStock,
        isAvailable: newStock > 0,
        isFeatured: old.isFeatured,
        averageRating: old.averageRating,
        reviewCount: old.reviewCount,
        imageUrl: old.imageUrl,
        tags: old.tags,
      );
      state = state.copyWith(allProducts: prods);
    }
  }
}

final catalogProvider = StateNotifierProvider<CatalogNotifier, CatalogState>((ref) => CatalogNotifier());
final categoriesProvider = Provider<List<String>>((ref) => ['All', 'Ingredients', 'Tools', 'Dairy', 'Chocolate', 'Flavours']);
