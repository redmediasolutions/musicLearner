class CourseModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String instructorName;
  final String instructorSubtitle;
  final String instructorImage;
  final double rating;
  final String students;
  final double price;
  final double oldPrice;
  final bool bestseller;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.instructorName,
    required this.instructorSubtitle,
    required this.instructorImage,
    required this.rating,
    required this.students,
    required this.price,
    required this.oldPrice,
    required this.bestseller,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      videoUrl: map['video_url'],
      thumbnailUrl: map['thumbnail_url'],
      instructorName: map['instructor_name'],
      instructorSubtitle: map['instructor_subtitle'],
      instructorImage: map['instructor_image'],
      rating: (map['rating'] as num).toDouble(),
      students: map['students'],
      price: (map['price'] as num).toDouble(),
      oldPrice: (map['old_price'] as num).toDouble(),
      bestseller: map['bestseller'] ?? false,
    );
  }
}
