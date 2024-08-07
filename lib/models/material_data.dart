class MaterialItem {
  final String name;
  final int quantity;

  MaterialItem({required this.name, required this.quantity});
  factory MaterialItem.fromJson(Map<String, dynamic> json) => MaterialItem(
        name: json['name'] as String,
        quantity: (json['quantity'] as num).toInt(),
      );
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'quantity': quantity,
      };
}
