class Ad {
  final String adId;
  final String title;
  final String description;
  final String? imageUrl;
  final String targetCountry;
  final String? linkUrl;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Ad({
    required this.adId,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.targetCountry,
    this.linkUrl,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      adId: json['ad_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
      targetCountry: json['target_country'] ?? '',
      linkUrl: json['link_url'],
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad_id': adId,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'target_country': targetCountry,
      'link_url': linkUrl,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
