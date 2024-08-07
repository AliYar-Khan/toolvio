import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:toolvio/models/customer_data.dart';
import 'package:toolvio/repo/appwrite_repo.dart';
import 'package:toolvio/res/constants.dart';
import 'package:toolvio/view_model/login_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerViewModel extends ChangeNotifier {
  List<CustomerData> customers = [];
  AppwriteRepository repository = AppwriteRepository.instance;

  bool loading = false;

  CustomerViewModel() {
    if (kDebugMode) {
      print("Initing Customer view model");
    }
  }

  Future<void> addCustomer(String name, String company, String email,
      String phone, String address, BuildContext context) async {
    loading = true;
    notifyListeners();
    Map<String, dynamic> data = {
      "id": ID.unique(),
      "name": name,
      "companyName": company,
      "email": email,
      "phone": phone,
      "address": address
    };
    data["accountId"] = Provider.of<LoginViewModel>(context, listen: false)
        .user
        ?.$id
        .toString();
    await repository.createDocument(AppConstants.customerCollectionID, data);
    loading = false;
    notifyListeners();
  }

  Future<void> getCustomers(BuildContext context) async {
    loading = true;
    notifyListeners();
    try {
      String? userId = Provider.of<LoginViewModel>(context, listen: false)
          .user
          ?.$id
          .toString();
      DocumentList docs = await repository.database.listDocuments(
          databaseId: AppConstants.databaseId,
          collectionId: AppConstants.customerCollectionID,
          queries: [Query.equal('accountId', userId)]);
      customers =
          docs.documents.map((e) => CustomerData.fromJson(e.data)).toList();
      loading = false;
      notifyListeners();
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      loading = false;
      notifyListeners();
    }
  }

  Future<CustomerData?> getCustomer(
      BuildContext context, String customerId) async {
    loading = true;
    notifyListeners();
    CustomerData? customer;
    try {
      if (kDebugMode) {
        print("customerId ---> $customerId");
      }
      if (customers.isNotEmpty) {
        for (var element in customers) {
          if (kDebugMode) {
            print("customer ---> ${element.toJson()}");
          }
          if (element.id == customerId) {
            customer = element;
          }
        }
        loading = false;
        notifyListeners();
        if (kDebugMode) {
          print("invoice customer --> ${customer?.toJson()}");
        }
        return customer;
      } else {
        String? userId = Provider.of<LoginViewModel>(context, listen: false)
            .user
            ?.$id
            .toString();
        DocumentList docs = await repository.database.listDocuments(
            databaseId: AppConstants.databaseId,
            collectionId: AppConstants.customerCollectionID,
            queries: [Query.equal('accountId', userId)]);
        customers =
            docs.documents.map((e) => CustomerData.fromJson(e.data)).toList();
        CustomerData? customer;

        customer = customers.firstWhere((element) => element.id == customerId);
        if (kDebugMode) {
          print("invoice customer --> ${customer.toJson()}");
        }
        loading = false;
        notifyListeners();
        return customer;
      }
    } on AppwriteException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      loading = false;
      notifyListeners();
      return null;
    }
  }
}
