class Activity {
  final List<String> imageUrls;
  final String activityTitle;
  final String location;
  final String distance;
  final List<String> tags;

  Activity({
    required this.imageUrls,
    required this.activityTitle,
    required this.location,
    required this.distance,
    required this.tags,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      imageUrls: List<String>.from(json['image_urls']),
      activityTitle: json['activity_title'],
      location: json['location'],
      distance: json['distance'],
      tags: List<String>.from(json['tags']),
    );
  }
}
