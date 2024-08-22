import 'dart:convert';
import 'package:toolivo/models/task_data.dart';

class InvoiceData {
  String invoiceId;
  String accountId;
  String customerId;
  String customerName;
  String invoiceDate;
  String customerAddress;
  String invoiceStatus;
  int invoiceNumber;
  List<TaskData> tasks;
  double totalSum;
  InvoiceData({
    required this.invoiceId,
    required this.accountId,
    required this.customerId,
    required this.customerName,
    required this.invoiceDate,
    required this.customerAddress,
    required this.invoiceStatus,
    required this.invoiceNumber,
    required this.tasks,
    required this.totalSum,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) => InvoiceData(
        invoiceId: json['invoice_id'] as String,
        accountId: json['accountId'] as String,
        customerId: json['customerId'] as String,
        customerName: json['customerName'] as String,
        invoiceDate: json['invoice_date'] as String,
        customerAddress: json['customerAddress'] as String,
        invoiceStatus: json['invoice_status'] as String,
        invoiceNumber: json['invoice_number'] as int,
        tasks: (jsonDecode(json["tasks"]) as List<dynamic>)
            .map((e) => TaskData.fromJson(e))
            .toList(),
        totalSum: json['totalSum'] as double,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'invoice_id': invoiceId,
        'accountId': accountId,
        'customerId': customerId,
        'customerName': customerName,
        'invoice_date': invoiceDate,
        'customerAddress': customerAddress,
        'invoice_status': invoiceStatus,
        'invoice_number': invoiceNumber,
        'tasks': jsonEncode(tasks),
        'totalSum': totalSum,
      };
}
