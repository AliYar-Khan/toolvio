import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:toolivo/res/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AppwriteRepository {
  static AppwriteRepository? _instance;
  late Client client;
  late Account account;
  late Databases database;
  late Storage storage;
  late Functions functions;
  // Private constructor to prevent instantiation from outside
  AppwriteRepository._() {
    client = Client();
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);

    account = Account(client);
    database = Databases(client);
    storage = Storage(client);
    functions = Functions(client);
  }

  // Singleton instance getter
  static AppwriteRepository get instance {
    _instance ??= AppwriteRepository._();
    return _instance!;
  }

  // Example method to get a list of documents from a collection
  Future<List<dynamic>> getDocuments(String collectionId) async {
    try {
      DocumentList response = await database.listDocuments(
          databaseId: AppConstants.databaseId, collectionId: collectionId);
      return response.documents;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching documents: $e');
      }
      return [];
    }
  }

  // Example method to create a new document in a collection
  Future<String> createDocument(
      String collectionId, Map<String, dynamic> data) async {
    try {
      var response = await database.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: collectionId,
        data: data,
        documentId: ID.unique(),
      );
      return response.data['\$id'];
    } catch (e) {
      if (kDebugMode) {
        print('Error creating document: $e');
      }
      return '';
    }
  }

  Future<String> getFile(String bucketId, String fileId) async {
    Uint8List result =
        await storage.getFileDownload(bucketId: bucketId, fileId: fileId);
    return String.fromCharCodes(result);
  }

  Future<dynamic> exectuteFunction(
      String functionID, Map<String, dynamic> body, ExecutionMethod method) {
    Future<Execution> result = functions.createExecution(
      functionId: functionID,
      body: jsonEncode(body), // optional
      xasync: false, // optional
      path: '/', // optional
      method: method, // optional
      headers: {}, // optional
    );
    return result.then((data) {
      if (kDebugMode) {
        print("data ===> ${data.responseBody}");
        print("data type ===> ${data.responseBody.runtimeType}");
      }
      return data.responseBody;
    });
  }
}
