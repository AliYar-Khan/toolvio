import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:toolivo/models/material_data.dart';

class TaskData {
  String? docId;
  String id;
  String title;
  String location;
  String startTime;
  String endTime;
  String duration;
  String customerId;
  String customerName;
  String description;
  List<MaterialItem> material;
  TaskData({
    this.docId,
    required this.id,
    required this.title,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.customerId,
    required this.customerName,
    required this.description,
    required this.material,
  });

  factory TaskData.fromJson(Document d) => TaskData(
        docId: d.$id,
        id: d.data['id'] as String,
        title: d.data['title'] as String,
        location: d.data['location'] as String,
        startTime: d.data['startTime'] as String,
        endTime: d.data['endTime'] as String,
        duration: d.data['duration'] as String,
        customerId: d.data['customerId'] as String,
        customerName: d.data['customerName'] as String,
        description: d.data['description'] as String,
        material: (jsonDecode(d.data["material"]) as List<dynamic>)
            .map((e) => MaterialItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'location': location,
        'startTime': startTime,
        'endTime': endTime,
        'duration': duration,
        'customerId': customerId,
        'customerName': customerName,
        'description': description,
        'material': jsonEncode(material),
      };
}
