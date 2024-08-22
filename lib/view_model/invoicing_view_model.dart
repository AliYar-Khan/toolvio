import 'dart:io' as dartio;
import 'dart:math';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:toolivo/models/invoices.dart';
import 'package:toolivo/models/chart_data.dart';
import 'package:toolivo/models/customer_data.dart';
import 'package:toolivo/models/invoice_data.dart';
import 'package:toolivo/models/material_data.dart';
import 'package:toolivo/models/task_data.dart';
import 'package:toolivo/models/task_invoice.dart';
import 'package:toolivo/repo/appwrite_repo.dart';
import 'package:toolivo/res/constants.dart';
import 'package:toolivo/utils/utils.dart';
import 'package:toolivo/view_model/customer_view_model.dart';
import 'package:toolivo/view_model/login_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

enum InvoiceBy { year, month, week }

class InvoicingViewModel extends ChangeNotifier {
  InvoiceBy invoiceBy = InvoiceBy.month;
  List<bool> customTileExpanded = [];
  List<String> checked = [];
  List<TaskInvoice> data = [];
  late DateTime reportForDate = DateTime.now();
  CustomerData? invoiceCustomer;
  List<TaskData> invoicedTasks = [];
  AppwriteRepository repository = AppwriteRepository.instance;
  String invoiceTotal = "\$0.00";
  bool loading = false;
  List<Invoices> invoices = [];
  List<Invoices?> filteredInvoices = [];
  String revenue = '';
  List<ChartData> chartData = [];
  bool filterDropDownOpen = false;

  InvoicingViewModel() {
    if (kDebugMode) {
      print("Init Invoicing model");
    }
    invoicedTasks.clear();
    if (invoicedTasks.isEmpty) {
      invoicedTasks = [];
    }
    checked.clear();
    if (checked.isEmpty) {
      checked = [];
    }
    customTileExpanded.clear();
    if (customTileExpanded.isEmpty) {
      customTileExpanded = [];
    }
    data.clear();
    if (data.isEmpty) {
      data = [];
    }
    invoiceCustomer = null;
    notifyListeners();
  }

  void toggleFilterDropDownOpen() {
    filterDropDownOpen = !filterDropDownOpen;
    notifyListeners();
  }

  void filterHomeData(String by) {
    if (by == "monthly" && invoiceBy != InvoiceBy.month) {
      invoiceBy = InvoiceBy.month;
      notifyListeners();
    } else if (by == "weekly" && invoiceBy != InvoiceBy.week) {
      invoiceBy = InvoiceBy.week;
      notifyListeners();
    }
    getFilteredInvoices();
  }

  void clearDataTasks() {
    invoiceTotal = '';
  }

  Future<void> getTasks(BuildContext context) async {
    loading = true;
    notifyListeners();
    try {
      String? userId = Provider.of<LoginViewModel>(context, listen: false)
          .user
          ?.$id
          .toString();
      DocumentList docs = await repository.database.listDocuments(
          databaseId: AppConstants.databaseId,
          collectionId: AppConstants.taskCollectionID,
          queries: [Query.equal('accountId', userId)]);
      data = docs.documents.map((e) => TaskInvoice.fromJson(e.data)).toList();
      // ignore: unused_local_variable
      for (var element in data) {
        customTileExpanded.add(false);
      }
      loading = false;
      notifyListeners();
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addChecked(int index, BuildContext context) async {
    data[index].isChecked = true;
    invoiceCustomer =
        await Provider.of<CustomerViewModel>(context, listen: false)
            .getCustomer(context, data[index].customerId);

    invoicedTasks.add(TaskData(
      id: data[index].id,
      title: data[index].title,
      location: data[index].location,
      startTime: data[index].startTime,
      endTime: data[index].endTime,
      duration: data[index].duration,
      customerId: data[index].customerId,
      customerName: data[index].customerName,
      description: data[index].description,
      material: data[index].material,
    ));

    notifyListeners();
  }

  void removeChecked(int index) {
    data[index].isChecked = false;
    invoicedTasks.removeWhere((e) => e.id == data[index].id);
    notifyListeners();
  }

  void setTotal(String value) {
    invoiceTotal = value;
    notifyListeners();
  }

  void isExpanded(int index, bool value) {
    customTileExpanded[index] = value;
    notifyListeners();
  }

  void invoiceData() {
    for (var task in data) {
      if (checked.contains(task.id)) {
        invoicedTasks.add(TaskData(
          id: task.id,
          title: task.title,
          location: task.location,
          startTime: task.startTime,
          endTime: task.endTime,
          duration: task.duration,
          customerId: task.customerId,
          customerName: task.customerName,
          description: task.description,
          material: task.material,
        ));
      }
    }
    notifyListeners();
  }

  Future<void> selectReportDate(BuildContext context) async {
    var pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      reportForDate = pickedDate;
      notifyListeners();
    }
  }

  Future<bool> printPDF(BuildContext context) async {
    loading = true;
    notifyListeners();
    if (invoicedTasks.isEmpty) {
      return false;
    } else if (invoiceTotal == '') {
      return false;
    } else {
      String? userId = Provider.of<LoginViewModel>(context, listen: false)
          .user
          ?.$id
          .toString();
      InvoiceData invoiceData = InvoiceData(
        invoiceId: ID.unique(),
        accountId: userId!,
        customerId: invoiceCustomer!.id,
        customerName: invoiceCustomer!.name,
        invoiceDate:
            "${reportForDate.day.toString()}.${reportForDate.month.toString()}.${reportForDate.year.toString()}",
        customerAddress: invoiceCustomer!.address,
        invoiceStatus: "Processing",
        invoiceNumber: Random().nextInt(10000),
        tasks: invoicedTasks,
        totalSum: double.parse(invoiceTotal.replaceFirst("\$", "")),
      );
      Map<String, dynamic> data = invoiceData.toJson();
      if (kDebugMode) {
        print("invoice data ---> $data");
      }
      await repository.createDocument(AppConstants.invoiceCollectionId, data);
      String html = await repository.getFile(
          AppConstants.bucketId, '665f53de0025097b191d');
      html = html.replaceAll("%CUSTOMERADRESS%", invoiceCustomer!.address);
      html = html.replaceAll("%CURRENYSIGN%", "\$");
      html =
          html.replaceAll("%INVOICENR%", invoiceData.invoiceNumber.toString());
      html = html.replaceAll("%INVOICEDESCRIPTION%",
          "Invoice for data ${invoiceData.invoiceDate}");
      String tasks = "";
      String materials = "";
      int length = invoiceData.tasks.length;
      for (int index = 0; index < length; index++) {
        List<MaterialItem> mts = invoiceData.tasks[index].material;
        materials = mts.map((e) {
          return """
    <tr>
      <td>${e.name}</td>
      <td>${e.quantity}</td>
    </tr>
    """;
        }).join();
        tasks =
            "$tasks <tr><td>$index</td><td><tr>${invoiceData.tasks[index].title}</tr>$materials</td></tr>";
        materials = "";
      }
      html = html.replaceAll("%INVOICE%", tasks);
      html = html.replaceAll("%INVOICESUM%", invoiceTotal);
      html = html.replaceAll("%INVOICESUM%", invoiceTotal);
      await generateDocument(html, invoiceData.invoiceNumber);
      loading = false;
      notifyListeners();
      return true;
    }
  }

  Future<void> generateDocument(String htmlContent, int invoiceNumber) async {
    dartio.Directory appDocDir = await getApplicationDocumentsDirectory();
    final targetPath = appDocDir.path;
    final targetFileName = "invoice_$invoiceNumber";
    if (kDebugMode) {
      print("html --> $htmlContent");
    }
    var headers = {
      'Content-Type': 'application/json',
      'auth': convert.jsonEncode({
        'username': 'api',
        'password': AppConstants.pdfshiftapikey,
      })
    };
    var request = http.Request(
        'POST', Uri.parse('https://api.pdfshift.io/v3/convert/pdf'));
    request.body = convert.jsonEncode({"source": htmlContent});
    // Await the http get response, then decode the json-formatted response.
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      try {
        var file = await response.stream.toBytes();
        dartio.File filePDF =
            await dartio.File('$targetPath/$targetFileName.pdf').create();
        filePDF.writeAsBytesSync(file);
        if (kDebugMode) {
          print('$targetPath/$targetFileName.pdf');
        }
      } on dartio.FileSystemException catch (e) {
        if (kDebugMode) {
          print("exception -> ${e.message}");
        }
      } on FormatException catch (e) {
        debugPrint("exception $e");
      }
    } else {
      if (kDebugMode) {
        print(
            "Request failed with status code ${response.statusCode}: ${response.reasonPhrase}");
      }
      Utils.toastMessage(response.reasonPhrase!);
    }
  }

  Future<void> getAllInvoices(BuildContext context) async {
    loading = true;
    String? userId = Provider.of<LoginViewModel>(context, listen: false)
        .user
        ?.$id
        .toString();
    DocumentList docs = await repository.database.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.invoiceCollectionId,
        queries: [Query.equal('accountId', userId)]);

    invoices = docs.documents.map((e) => Invoices.fromJson(e.data)).toList();
    loading = false;
    notifyListeners();
  }

  void getFilteredInvoices() {
    if (invoices.isNotEmpty) {
      chartData.clear();
      filteredInvoices.clear();
      revenue = '';
      loading = true;
      notifyListeners();
      if (invoiceBy == InvoiceBy.month) {
        String currentYear =
            DateTime.now().toString().split(" ")[0].split("-")[0];
        String currentMonth =
            DateTime.now().toString().split(" ")[0].split("-")[1];
        List<Invoices> sameMonth = [];
        var lengthInvoice = invoices.length;
        for (int i = 0; i < lengthInvoice; i++) {
          if (int.parse(invoices[i].invoiceDate.split(".")[2]) ==
                  int.parse(currentYear) &&
              int.parse(invoices[i].invoiceDate.split(".")[1]) ==
                  int.parse(currentMonth)) {
            sameMonth.add(invoices[i]);
          }
        }
        filteredInvoices = sameMonth;
        revenue = sameMonth
            .fold(0.0, (v, e) => v + double.parse(e.totalSum))
            .toStringAsFixed(2)
            .toString();
        debugPrint("revenue --> $revenue");

        var invoiceChart = sameMonth;

        for (int i = 0; i < invoiceChart.length; i++) {
          var customer = invoiceChart[i].customerName;
          var totalSumCustomer = double.parse(invoiceChart[i].totalSum);
          for (int j = i + 1; j < invoiceChart.length; j++) {
            if (invoiceChart[j].customerName == customer) {
              totalSumCustomer += double.parse(invoiceChart[j].totalSum);
            }
          }
          chartData.add(ChartData(
              customer.split(" ")[0][0] + customer.split(" ")[0][1],
              totalSumCustomer));
          invoiceChart.removeWhere((item) => item.customerName == customer);
        }
        loading = false;
        notifyListeners();
      } else if (invoiceBy == InvoiceBy.week) {
        String dateToday = DateTime.now().toString().split(" ")[0];
        String dateWeekAgo = DateTime.parse(dateToday)
            .subtract(const Duration(days: 7))
            .toString()
            .split(" ")[0];
        List<Invoices> sameWeek = [];
        var lengthInvoice = invoices.length;
        for (int i = 0; i < lengthInvoice; i++) {
          List<String> formattedDate =
              invoices[i].invoiceDate.split(".").reversed.toList();
          for (int i = 0; i < formattedDate.length; i++) {
            if (formattedDate[i].length == 1) {
              formattedDate[i] = "0${formattedDate[i]}";
            }
          }
          if (DateTime.parse(formattedDate.join("-"))
                  .isAfter(DateTime.parse(dateWeekAgo)) &&
              DateTime.parse(formattedDate.join("-")).isBefore(
                  DateTime.parse(dateToday)
                      .add(const Duration(hours: 23, minutes: 59)))) {
            sameWeek.add(invoices[i]);
          }
        }
        filteredInvoices = sameWeek;
        revenue = sameWeek
            .fold(0.0, (v, e) => v + double.parse(e.totalSum))
            .toStringAsFixed(2)
            .toString();
        var invoiceChart = sameWeek;

        for (int i = 0; i < invoiceChart.length; i++) {
          var customer = invoiceChart[i].customerName;
          var totalSumCustomer = double.parse(invoiceChart[i].totalSum);
          for (int j = i + 1; j < invoiceChart.length; j++) {
            if (invoiceChart[j].customerName == customer) {
              totalSumCustomer += double.parse(invoiceChart[j].totalSum);
            }
          }
          chartData.add(ChartData(
              customer.split(" ")[0][0] + customer.split(" ")[0][1],
              totalSumCustomer));
          invoiceChart.removeWhere((item) => item.customerName == customer);
        }

        debugPrint("revenue --> $revenue");
        loading = false;
        notifyListeners();
      }
    }
  }
}
