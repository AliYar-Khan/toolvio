import 'dart:convert';

import 'package:toolivo/models/material_data.dart';

class TaskData {
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

  factory TaskData.fromJson(Map<String, dynamic> json) => TaskData(
        id: json['id'] as String,
        title: json['title'] as String,
        location: json['location'] as String,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        duration: json['duration'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        description: json['description'] as String,
        material: (jsonDecode(json["material"]) as List<dynamic>)
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
