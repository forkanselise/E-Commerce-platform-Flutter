class Product {
  final String id;
  final String title;
  final String slug;
  final String category;
  final String subCategory;
  final String description;
  final String shortDescription;
  final double price;
  final double compareAtPrice;
  final String sku;
  final int warehouseStock;
  final bool isAvailable;
  final bool isFeatured;
  final double averageRating;
  final int reviewCount;
  final String imageUrl;
  final List<String> tags;

  Product({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    required this.subCategory,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.compareAtPrice,
    required this.sku,
    required this.warehouseStock,
    required this.isAvailable,
    required this.isFeatured,
    required this.averageRating,
    required this.reviewCount,
    required this.imageUrl,
    required this.tags,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String img = 'https://images.unsplash.com/photo-1548907040-4baa42d10919?w=800';
    if (json['images'] != null && json['images'] is List && (json['images'] as List).isNotEmpty) {
      var first = json['images'][0];
      if (first is Map && first['url'] != null) {
        img = first['url'];
      } else if (first is String) {
        img = first;
      }
    } else if (json['imageUrl'] != null) {
      img = json['imageUrl'];
    }

    return Product(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? json['name'] ?? '',
      slug: json['slug'] ?? '',
      category: json['category'] ?? 'General',
      subCategory: json['subCategory'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['shortDescription'] ?? json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      compareAtPrice: (json['compareAtPrice'] ?? 0.0).toDouble(),
      sku: json['sku'] ?? 'SKU-000',
      warehouseStock: json['warehouseStock'] ?? json['stock'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      averageRating: (json['averageRating'] ?? 4.8).toDouble(),
      reviewCount: json['reviewCount'] ?? 100,
      imageUrl: img,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'category': category,
    'subCategory': subCategory,
    'description': description,
    'shortDescription': shortDescription,
    'price': price,
    'compareAtPrice': compareAtPrice,
    'sku': sku,
    'warehouseStock': warehouseStock,
    'isAvailable': isAvailable,
    'isFeatured': isFeatured,
    'averageRating': averageRating,
    'reviewCount': reviewCount,
    'imageUrl': imageUrl,
    'tags': tags,
  };
}

final List<Product> INITIAL_PRODUCTS = [
  Product(
    id: 'prod_1',
    title: 'Callebaut Dark Chocolate 1kg (54.5% Cocoa)',
    slug: 'callebaut-dark-chocolate-1kg',
    category: 'Ingredients',
    subCategory: 'Chocolate',
    description: 'Rich and balanced dark Belgian chocolate callets (54.5% cocoa) ideal for baking, ganache, mousse, and desserts.',
    shortDescription: 'Balanced 54.5% Belgian dark chocolate callets with rich cocoa body.',
    price: 1250.0,
    compareAtPrice: 1500.0,
    sku: 'ING-CHOC-001',
    warehouseStock: 85,
    isAvailable: true,
    isFeatured: true,
    averageRating: 4.9,
    reviewCount: 320,
    imageUrl: 'https://images.unsplash.com/photo-1548907040-4baa42d10919?w=800',
    tags: ['chocolate', 'ingredients', 'callebaut', 'belgian'],
  ),
  Product(
    id: 'prod_2',
    title: 'Callebaut Milk Chocolate 1kg (33.6% Cocoa)',
    slug: 'callebaut-milk-chocolate-1kg',
    category: 'Ingredients',
    subCategory: 'Chocolate',
    description: 'Creamy Belgian milk chocolate callets with deep caramel and cocoa undertones. Perfect for pralines and cakes.',
    shortDescription: 'Creamy 33.6% Belgian milk chocolate callets with caramel notes.',
    price: 1255.0,
    compareAtPrice: 1480.0,
    sku: 'ING-CHOC-002',
    warehouseStock: 60,
    isAvailable: true,
    isFeatured: true,
    averageRating: 4.8,
    reviewCount: 210,
    imageUrl: 'https://images.unsplash.com/photo-1582293041079-7814c2f12063?w=800',
    tags: ['chocolate', 'ingredients', 'milk-chocolate'],
  ),
  Product(
    id: 'prod_4',
    title: 'Anchor Whipping Cream 1L (Pure Dairy)',
    slug: 'anchor-whipping-cream-1l',
    category: 'Ingredients',
    subCategory: 'Dairy',
    description: 'Ultra-stable 35.5% fat pure New Zealand dairy whipping cream. Yields magnificent whipped peaks for pastries.',
    shortDescription: 'Pure New Zealand whipping cream with 35.5% milk fat.',
    price: 780.0,
    compareAtPrice: 900.0,
    sku: 'ING-DAIRY-004',
    warehouseStock: 140,
    isAvailable: true,
    isFeatured: true,
    averageRating: 4.9,
    reviewCount: 450,
    imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800',
    tags: ['dairy', 'whipping-cream', 'anchor'],
  ),
  Product(
    id: 'prod_5',
    title: 'Anchor Unsalted Butter 450g',
    slug: 'anchor-unsalted-butter-450g',
    category: 'Ingredients',
    subCategory: 'Dairy',
    description: 'Made from 100% pure New Zealand pasture-fed cow milk. Essential for flaky croissants and rich cakes.',
    shortDescription: '100% Pure grass-fed New Zealand unsalted butter.',
    price: 450.0,
    compareAtPrice: 520.0,
    sku: 'ING-DAIRY-005',
    warehouseStock: 110,
    isAvailable: true,
    isFeatured: false,
    averageRating: 4.8,
    reviewCount: 290,
    imageUrl: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=800',
    tags: ['butter', 'dairy', 'anchor'],
  ),
  Product(
    id: 'prod_10',
    title: 'Premium Silicone Spatula Set (Set of 2)',
    slug: 'premium-silicone-spatula-set-of-2',
    category: 'Tools',
    subCategory: 'Baking Tools',
    description: 'Heat-resistant up to 260°C seamless food-grade silicone spatulas for macaron folding and chocolate melting.',
    shortDescription: 'Heat-resistant seamless silicone spatulas.',
    price: 450.0,
    compareAtPrice: 600.0,
    sku: 'TOOL-SPT-010',
    warehouseStock: 180,
    isAvailable: true,
    isFeatured: true,
    averageRating: 4.9,
    reviewCount: 280,
    imageUrl: 'https://images.unsplash.com/photo-1590794056226-79ef3a8147e1?w=800',
    tags: ['spatula', 'silicone', 'tools'],
  ),
];
