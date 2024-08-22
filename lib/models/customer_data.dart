import 'package:appwrite/models.dart';

class CustomerData {
  String id;
  String? docId;
  String name;
  String companyName;
  String phone;
  String email;
  String address;

  CustomerData({
    required this.id,
    this.docId,
    required this.name,
    required this.companyName,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory CustomerData.fromJson(Document d) => CustomerData(
        id: d.data['id'] as String,
        docId: d.$id,
        name: d.data['name'] as String,
        companyName: d.data['companyName'] as String,
        phone: d.data['phone'] as String,
        email: d.data['email'] as String,
        address: d.data['address'] as String,
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
