class User {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String phone;
  final String address;
  final String avatarUrl;
  final String subscriptionTier;
  final int loyaltyPoints;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.phone,
    required this.address,
    this.avatarUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    this.subscriptionTier = 'Free Learner',
    required this.loyaltyPoints,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] ?? json['_id'] ?? 'u_${DateTime.now().millisecondsSinceEpoch}',
    fullName: json['fullName'] ?? json['name'] ?? 'Artisan Baker',
    email: json['email'] ?? '',
    role: json['role'] ?? 'Member',
    phone: json['phone'] ?? '+880 1700-000000',
    address: json['address'] ?? 'Dhaka, Bangladesh',
    avatarUrl: json['avatarUrl'] ?? json['avatar'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
    subscriptionTier: (json['subscription'] is Map) ? (json['subscription']['tier'] ?? 'Free Learner') : (json['subscriptionTier'] ?? 'Free Learner'),
    loyaltyPoints: json['loyaltyPoints'] ?? 250,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'role': role,
    'phone': phone,
    'address': address,
    'avatarUrl': avatarUrl,
    'subscriptionTier': subscriptionTier,
    'loyaltyPoints': loyaltyPoints,
  };

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? role,
    String? phone,
    String? address,
    String? avatarUrl,
    String? subscriptionTier,
    int? loyaltyPoints,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    );
  }
}
