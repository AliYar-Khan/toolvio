import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:toolivo/models/material_data.dart';
import 'package:toolivo/models/task_data.dart';
import 'package:toolivo/repo/appwrite_repo.dart';
import 'package:toolivo/res/constants.dart';
import 'package:toolivo/view_model/login_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskViewModel extends ChangeNotifier {
  AppwriteRepository repository = AppwriteRepository.instance;
  List<bool> customTileExpanded = [];

  List<MaterialItem> material = [];
  List<TaskData> tasks = [];
  String startTime = '';
  String endTime = '';
  String duration = '';
  late TimeOfDay? pickedTime;

  bool loading = false;

  TaskViewModel() {
    if (kDebugMode) {
      print("Initing Task view model");
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (kDebugMode) {
      print(pickedTime!.hour);
      print(pickedTime!.minute);
    }
    if (pickedTime != null) {
      int hour = pickedTime!.hour % 12;
      String minutes = pickedTime!.minute < 10
          ? '0${pickedTime!.minute}'
          : '${pickedTime!.minute}';
      String amPM = pickedTime!.hour < 12 ? 'am' : 'pm';
      startTime = '$hour:$minutes $amPM';
      notifyListeners();
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (kDebugMode) {
      print(pickedTime!.hour);
      print(pickedTime!.minute);
    }
    if (pickedTime != null) {
      int hour = pickedTime!.hour % 12;
      String minutes = pickedTime!.minute < 10
          ? '0${pickedTime!.minute}'
          : '${pickedTime!.minute}';
      String amPM = pickedTime!.hour < 12 ? 'am' : 'pm';
      endTime = '$hour:$minutes $amPM';
      notifyListeners();
      getDuration();
    }
  }

  void getDuration() {
    if (startTime == '' || endTime == '') {
      return;
    } else {
      final startTimeParts = startTime.split(" ");
      final endTimeParts = endTime.split(" ");

      final startTimeAMPM = startTimeParts[1].toLowerCase();
      final endTimeAMPM = endTimeParts[1].toLowerCase();

      final startTimeNumbers = startTimeParts[0].split(":");
      final endTimeNumbers = endTimeParts[0].split(":");

      // Convert string parts into integers
      final startHour = int.parse(startTimeNumbers[0]);
      final startMinute = int.parse(startTimeNumbers[1]);
      final endHour = int.parse(endTimeNumbers[0]);
      final endMinute = int.parse(endTimeNumbers[1]);

      // Adjust hours for AM/PM
      final adjustedStartHour =
          startTimeAMPM == "pm" ? startHour + 12 : startHour;
      final adjustedEndHour = endTimeAMPM == "pm" ? endHour + 12 : endHour;

      // Create DateTime objects for start and end times
      final startDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, adjustedStartHour, startMinute);
      final endDate = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, adjustedEndHour, endMinute);

      // Calculate duration
      final durationTime = endDate.difference(startDate);
      final hours = durationTime.inHours;
      final minutes = durationTime.inMinutes.remainder(60);
      duration = '$hours hrs $minutes mints';
      notifyListeners();
    }
  }

  Future<void> addTask(String title, String location, String customerId,
      String customerName, String description, BuildContext context) async {
    loading = true;
    notifyListeners();
    TaskData taskData = TaskData(
        id: ID.unique(),
        title: title,
        location: location,
        startTime: startTime,
        endTime: endTime,
        duration: duration,
        customerId: customerId,
        customerName: customerName,
        description: description,
        material: material);
    // List<String> materialListString =
    //     material.map((e) => (e.toJson()).toString()).toList();
    // Map<String, dynamic> data = {
    //   "id": ID.unique(),
    //   "title": title,
    //   "location": location,
    //   "startTime": startTime,
    //   "endTime": endTime,
    //   "duration": duration,
    //   "customerId": customerId,
    //   "customerName": customerName,
    //   "description": description,
    //   "material": materialListString,
    // };
    Map<String, dynamic> data = taskData.toJson();
    data["accountId"] = Provider.of<LoginViewModel>(context, listen: false)
        .user
        ?.$id
        .toString();
    await repository.createDocument(AppConstants.taskCollectionID, data);
    startTime = '';
    endTime = '';
    duration = '';
    material.clear();
    loading = false;
    notifyListeners();
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
      tasks = docs.documents.map((e) {
        if (kDebugMode) {
          print("e.data --> ${e.data}");
        }
        return TaskData.fromJson(e.data);
      }).toList();
      // ignore: unused_local_variable
      for (var element in tasks) {
        customTileExpanded.add(false);
      }
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

  Future<void> getInvoice() async {
    var htmlString =
        await repository.getFile(AppConstants.bucketId, "6649b31c003159334266");
    if (kDebugMode) {
      print("html -> $htmlString");
    }
  }

  void isExpanded(int index, bool value) {
    customTileExpanded[index] = value;
    notifyListeners();
  }
}
