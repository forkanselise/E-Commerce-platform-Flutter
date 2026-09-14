class MobilePhone {
  final String id;
  final String name;
  final String brand;
  final String model;
  final double price;
  final String imageUrl;
  final Map<String, String> specs;
  final bool inStock;
  final bool isFeatured;

  final String? _description;
  final String? _slug;
  final int? _stock;
  final double? _rating;

  MobilePhone({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.price,
    required this.imageUrl,
    required this.specs,
    required this.inStock,
    required this.isFeatured,
    String? description,
    String? slug,
    int? stock,
    double? rating,
  })  : _description = description,
        _slug = slug,
        _stock = stock,
        _rating = rating;

  String get description =>
      _description ??
      (specs.isNotEmpty
          ? '$name ($brand $model) equipped with ${specs.values.take(2).join(', ')}.'
          : '$brand $model premium smartphone.');

  String get slug =>
      _slug ??
      '${brand.toLowerCase()}-${model.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}-$id';

  int get stock => _stock ?? (inStock ? 15 : 0);

  double get rating => _rating ?? 4.8;

  factory MobilePhone.fromJson(Map<String, dynamic> json) {
    Map<String, String> sp = {};
    if (json['specs'] is Map) {
      json['specs'].forEach((k, v) {
        sp[k.toString()] = v.toString();
      });
    }

    return MobilePhone(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? json['title'] ?? '',
      brand: json['brand'] ?? 'Apple',
      model: json['model'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800',
      specs: sp,
      inStock: json['inStock'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'] is num ? (json['stock'] as num).toInt() : null,
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : null,
    );
  }
}

final List<MobilePhone> INITIAL_PHONES = [
  MobilePhone(
    id: 'ph_1',
    name: 'iPhone 15 Pro Max',
    brand: 'Apple',
    model: 'Pro Max 256GB',
    price: 145000.0,
    imageUrl: 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=800',
    specs: {
      'screen': '6.7" Super Retina XDR OLED 120Hz',
      'processor': 'Apple A17 Pro (3nm)',
      'ram': '8 GB',
      'storage': '256 GB NVMe',
      'camera': '48 MP + 12 MP + 12 MP Telephoto',
      'battery': '4422 mAh (20W Fast Charging)',
    },
    inStock: true,
    isFeatured: true,
  ),
  MobilePhone(
    id: 'ph_2',
    name: 'Samsung Galaxy S24 Ultra',
    brand: 'Samsung',
    model: 'Ultra 512GB',
    price: 138000.0,
    imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=800',
    specs: {
      'screen': '6.8" Dynamic LTPO AMOLED 2X 120Hz',
      'processor': 'Snapdragon 8 Gen 3 for Galaxy',
      'ram': '12 GB',
      'storage': '512 GB UFS 4.0',
      'camera': '200 MP + 50 MP + 10 MP + 12 MP',
      'battery': '5000 mAh (45W Fast Charging)',
    },
    inStock: true,
    isFeatured: true,
  ),
  MobilePhone(
    id: 'ph_3',
    name: 'Google Pixel 8 Pro',
    brand: 'Google',
    model: '128GB Obsidian',
    price: 98000.0,
    imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
    specs: {
      'screen': '6.7" LTPO OLED 120Hz 2400 nits',
      'processor': 'Google Tensor G3 (4nm)',
      'ram': '12 GB',
      'storage': '128 GB UFS 3.1',
      'camera': '50 MP + 48 MP + 48 MP Ultrawide',
      'battery': '5050 mAh (30W Fast Charging)',
    },
    inStock: true,
    isFeatured: false,
  ),
  MobilePhone(
    id: 'ph_4',
    name: 'Xiaomi 14 Ultra',
    brand: 'Xiaomi',
    model: 'Leica Quad Camera Edition',
    price: 115000.0,
    imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    specs: {
      'screen': '6.73" LTPO AMOLED 120Hz Dolby Vision',
      'processor': 'Snapdragon 8 Gen 3',
      'ram': '16 GB',
      'storage': '512 GB UFS 4.0',
      'camera': '50 MP Leica 1-inch + 50 MP + 50 MP + 50 MP',
      'battery': '5000 mAh (90W HyperCharge)',
    },
    inStock: true,
    isFeatured: true,
  ),
];
