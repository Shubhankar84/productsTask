// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  String id;
  String name;
  Map<String, dynamic>? data;

  Product({
    required this.id,
    required this.name,
    this.data,
  });

  static Product fromSnap(Map<String, dynamic> data) {
    return Product(
        id: data['id'],
        name: data['name'],
        data: data['data'] != null
            ? Map<String, dynamic>.from(data['data'])
            : null);
  }
}
