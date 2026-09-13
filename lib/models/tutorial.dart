class TutorialChapter {
  final String title;
  final String timestampDisplay;

  TutorialChapter({required this.title, required this.timestampDisplay});

  factory TutorialChapter.fromJson(Map<String, dynamic> json) => TutorialChapter(
    title: json['title'] ?? '',
    timestampDisplay: json['timestampDisplay'] ?? json['timestamp'] ?? '00:00',
  );
}

class Tutorial {
  final String id;
  final String title;
  final String slug;
  final String category;
  final String skillLevel;
  final int durationMinutes;
  final double price;
  final String description;
  final String instructorName;
  final String instructorAvatar;
  final String thumbnail;
  final String videoUrl;
  final int viewCount;
  final double averageRating;
  final List<TutorialChapter> chapters;

  Tutorial({
    required this.id,
    required this.title,
    required this.slug,
    required this.category,
    required this.skillLevel,
    required this.durationMinutes,
    required this.price,
    required this.description,
    required this.instructorName,
    required this.instructorAvatar,
    required this.thumbnail,
    required this.videoUrl,
    required this.viewCount,
    required this.averageRating,
    required this.chapters,
  });

  factory Tutorial.fromJson(Map<String, dynamic> json) {
    List<TutorialChapter> ch = [];
    if (json['chapters'] is List) {
      ch = (json['chapters'] as List).map((c) => TutorialChapter.fromJson(c)).toList();
    }

    String instName = 'Chef Aminul Haque';
    String instAvatar = 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=150';
    if (json['instructor'] is Map) {
      instName = json['instructor']['name'] ?? instName;
      instAvatar = json['instructor']['avatarUrl'] ?? instAvatar;
    }

    return Tutorial(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      category: json['category'] ?? 'Cakes & Pastry',
      skillLevel: json['skillLevel'] ?? 'Beginner',
      durationMinutes: json['durationMinutes'] ?? 90,
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      instructorName: instName,
      instructorAvatar: instAvatar,
      thumbnail: json['thumbnail'] ?? 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
      videoUrl: json['videoUrl'] ?? 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      viewCount: json['viewCount'] ?? 500,
      averageRating: (json['averageRating'] ?? 4.9).toDouble(),
      chapters: ch,
    );
  }
}

final List<Tutorial> INITIAL_TUTORIALS = [
  Tutorial(
    id: 'tut_1',
    title: 'Basic Baking & Cake Decorating Foundation',
    slug: 'basic-baking-cake-decorating-foundation',
    category: 'Cakes & Pastry',
    skillLevel: 'Beginner',
    durationMinutes: 90,
    price: 3400.0,
    description: 'Master sponge cake science, even baking temperatures, crumb coating, and classic buttercream smoothing techniques.',
    instructorName: 'Chef Aminul Haque',
    instructorAvatar: 'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=150',
    thumbnail: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
    videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    viewCount: 8420,
    averageRating: 4.9,
    chapters: [
      TutorialChapter(title: 'Ingredients Prep & Flour Aeration', timestampDisplay: '02:15'),
      TutorialChapter(title: 'Baking Temp & Crumb Structure', timestampDisplay: '24:10'),
      TutorialChapter(title: 'Swiss Buttercream Smoothing', timestampDisplay: '52:40'),
    ],
  ),
  Tutorial(
    id: 'tut_2',
    title: 'Artisan French Macarons Masterclass',
    slug: 'artisan-french-macarons-masterclass',
    category: 'Patisserie',
    skillLevel: 'Advanced',
    durationMinutes: 120,
    price: 4500.0,
    description: 'Learn Italian vs French meringue method, macaronage technique, feet formation, and chocolate ganache filling.',
    instructorName: 'Chef Amelie Laurent',
    instructorAvatar: 'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=150',
    thumbnail: 'https://images.unsplash.com/photo-1569864358642-9d1684040f43?w=800',
    videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    viewCount: 12300,
    averageRating: 5.0,
    chapters: [
      TutorialChapter(title: 'Meringue Stiff Peaks Science', timestampDisplay: '05:30'),
      TutorialChapter(title: 'Macaronage Folding Technique', timestampDisplay: '35:15'),
      TutorialChapter(title: 'Callebaut Ganache Piping', timestampDisplay: '78:00'),
    ],
  ),
];
