
class Item {
  final int id;
  final String title;
  final String body;
  
  Item({
    required this.id,
    required this.title,
    required this.body,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

}
