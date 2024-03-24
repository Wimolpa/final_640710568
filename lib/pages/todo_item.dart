class TodoItem {
  
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;

  TodoItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['image']
    );
  }
}
