class DataModel {
  int? id; // Change to int to match Sembast record key type
  String? title;
  String? caption;
  String? image;

  DataModel({this.id, this.title, this.caption, this.image});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      id: json['id'], // Use 'id' if that's what you store
      title: json['title'],
      caption: json['caption'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'caption': caption,
    'image': image,
  };
}