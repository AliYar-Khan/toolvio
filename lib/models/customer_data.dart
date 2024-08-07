class CustomerData {
  String id;
  String name;
  String companyName;
  String phone;
  String email;
  String address;

  CustomerData({
    required this.id,
    required this.name,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        id: json['id'] as String,
        name: json['name'] as String,
        companyName: json['companyName'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        address: json['address'] as String,
      );

  /// Connect the generated [_$CustomerDataToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'companyName': companyName,
        'phone': phone,
        'email': email,
        'address': address,
      };
}
