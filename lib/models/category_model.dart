class CategoryModel {
  String image, name;
  int id;

  CategoryModel({required this.id, required this.image, required this.name});
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'].toInt(),
        image: json['image'],
        name: json['name']);
  }
}
