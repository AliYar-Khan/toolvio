class Invoices {
  String invoiceId;
  String accountId;
  String customerId;
  String customerName;
  String invoiceDate;
  String customerAddress;
  String invoiceStatus;
  String totalSum;
  String invoiceNumber;

  Invoices({
    required this.invoiceId,
    required this.accountId,
    required this.customerId,
    required this.customerName,
    required this.invoiceDate,
    required this.customerAddress,
    required this.invoiceStatus,
    required this.totalSum,
    required this.invoiceNumber,
  });

  factory Invoices.fromJson(Map<String, dynamic> json) => Invoices(
        invoiceId: json['invoice_id'],
        accountId: json['accountId'],
        customerId: json['customerId'],
        customerName: json['customerName'],
        invoiceDate: json['invoice_date'],
        customerAddress: json['customerAddress'],
        invoiceStatus: json['invoice_status'],
        totalSum: json['totalSum'].toString(),
        invoiceNumber: json['invoice_number'].toString(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'invoice_id': invoiceId,
        'accountId': accountId,
        'customerId': customerId,
        'customerName': customerName,
        'invoice_date': invoiceDate,
        'customerAddress': customerAddress,
        'invoice_status': invoiceStatus,
        'totalSum': double.parse(totalSum),
        'invoice_number': int.parse(invoiceNumber),
      };
}
