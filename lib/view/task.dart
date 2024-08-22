import 'package:flutter/foundation.dart';
import 'package:toolivo/models/customer_data.dart';
import 'package:toolivo/models/material_data.dart';
import 'package:toolivo/models/task_data.dart';
import 'package:toolivo/utils/routes/routes_name.dart';
import 'package:toolivo/res/widgets/button_primary.dart';
import 'package:toolivo/res/widgets/contained_text_field.dart';
import 'package:toolivo/res/widgets/contained_text_fields_with_button.dart';
import 'package:toolivo/res/widgets/dropdown_field.dart';
import 'package:toolivo/res/widgets/material_list_item.dart';
import 'package:toolivo/view_model/customer_view_model.dart';
import 'package:toolivo/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  String docId = '';
  List<MaterialItem> materials = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController plannedStarttime = TextEditingController();
  TextEditingController plannedEndtime = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController assigneeNameController = TextEditingController();
  TextEditingController assigneeIdController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController materialNameController = TextEditingController();
  TextEditingController materialQuantityController = TextEditingController();

  String assignee = '';

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final arguments = ModalRoute.of(context)?.settings.arguments as TaskData;
      if (kDebugMode) {
        print(arguments.title);
      }
      setState(() {
        docId = arguments.docId!;
        titleController.text = arguments.title;
        locationController.text = arguments.location;
        plannedStarttime.text = arguments.startTime;
        plannedEndtime.text = arguments.endTime;
        durationController.text = arguments.duration;
        assigneeIdController.text = arguments.customerId;
        assigneeNameController.text = arguments.customerName;
        descriptionController.text = arguments.description;
        materials = arguments.material;
      });
    });
    super.initState();
  }

  void selectStartTime(BuildContext context) async {
    var pickedTime = await showTimePicker(
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
      print(pickedTime.minute);
    }
    if (pickedTime != null) {
      int hour = pickedTime.hour % 12;
      String minutes = pickedTime.minute < 10
          ? '0${pickedTime.minute}'
          : '${pickedTime.minute}';
      String amPM = pickedTime.hour < 12 ? 'am' : 'pm';
      setState(() {
        plannedStarttime.text = '$hour:$minutes $amPM';
      });
    }
  }

  void selectEndTime(BuildContext context) async {
    var pickedTime = await showTimePicker(
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
      print(pickedTime.minute);
    }
    if (pickedTime != null) {
      int hour = pickedTime.hour % 12;
      String minutes = pickedTime.minute < 10
          ? '0${pickedTime.minute}'
          : '${pickedTime.minute}';
      String amPM = pickedTime.hour < 12 ? 'am' : 'pm';
      setState(() {
        plannedEndtime.text = '$hour:$minutes $amPM';
      });
      getDuration();
    }
  }

  void getDuration() {
    if (plannedStarttime.text == '' || plannedEndtime.text == '') {
      return;
    } else {
      final startTimeParts = plannedStarttime.text.split(" ");
      final endTimeParts = plannedEndtime.text.split(" ");

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
      setState(() {
        durationController.text = '$hours hrs $minutes mints';
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();

    durationController.dispose();
    assigneeNameController.dispose();
    assigneeIdController.dispose();
    descriptionController.dispose();
    materialNameController.dispose();
    materialQuantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    TaskViewModel taskViewModel = Provider.of<TaskViewModel>(context);
    CustomerViewModel customerViewModel =
        Provider.of<CustomerViewModel>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFB2B8BA),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 55),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 96,
                          height: 2,
                          color: const Color(0xFF868686),
                          margin: const EdgeInsets.only(top: 20),
                        )
                      ],
                    ),
                    ContainedTextField(
                      controller: titleController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.title,
                      maxLines: 1,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextField(
                      controller: locationController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.location,
                      maxLines: 1,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextField(
                      controller: null,
                      value: plannedStarttime.text,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.plannedStarttime,
                      maxLines: 1,
                      onPress: () {
                        selectStartTime(context);
                      },
                    ),
                    ContainedTextField(
                      controller: null,
                      value: plannedEndtime.text,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.plannedEndtime,
                      maxLines: 1,
                      onPress: () {
                        selectEndTime(context);
                      },
                    ),
                    ContainedTextField(
                      controller: durationController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.plannedDuration,
                      maxLines: 1,
                      onPress: () {},
                      value: durationController.text,
                    ),
                    DropDownField(
                      value: assigneeIdController.text,
                      widthScreen: widthScreen,
                      dropDownMenu: DropdownMenu<CustomerData>(
                        width: widthScreen * 0.65,
                        enableFilter: true,
                        requestFocusOnTap: true,
                        leadingIcon: const Icon(Icons.search),
                        menuStyle: MenuStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                            (Set<WidgetState> states) {
                              return const Color(
                                  0xFFFFFFFF); // Use the component's default.
                            },
                          ),
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: true,
                          fillColor: Color(0xFFD9D9D9),
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSelected: (CustomerData? data) {
                          if (data == null) {
                            return;
                          }
                          setState(() {
                            assigneeNameController.text = data.name;
                            assigneeIdController.text = data.id;
                          });
                        },
                        dropdownMenuEntries: customerViewModel.customers
                            .map<DropdownMenuEntry<CustomerData>>(
                          (CustomerData assignee) {
                            return DropdownMenuEntry<CustomerData>(
                                value: assignee,
                                label: assignee.name,
                                style: const ButtonStyle());
                          },
                        ).toList(),
                      ),
                      label: AppLocalizations.of(context)!.assignee,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RoutesName.addcustomer,
                          arguments: <String, String>{
                            'goBackToScreen': RoutesName.addtask
                          },
                        );
                      },
                    ),
                    ContainedTextField(
                      controller: descriptionController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.description,
                      maxLines: 10,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextFieldWithButton(
                      c1: materialNameController,
                      c2: materialQuantityController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.materials,
                      maxLines: 1,
                      hintText: AppLocalizations.of(context)!.materials,
                      onTap: () {
                        setState(() {
                          materials.add(MaterialItem(
                              name: materialNameController.text,
                              quantity:
                                  int.parse(materialQuantityController.text)));
                        });
                        materialNameController.clear();
                        materialQuantityController.clear();
                      },
                    ),
                    Container(
                      width: widthScreen * 0.8,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D75B6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          return MaterialListItem(
                            name: materials[index].name,
                            quantiy: materials[index].quantity,
                            showWhiteLine: index != materials.length - 1,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ButtonPrimary(
                        screenWidth: widthScreen,
                        loading: taskViewModel.loading,
                        onTap: () async {
                          await taskViewModel
                              .editTask(
                                  docId,
                                  titleController.text,
                                  locationController.text,
                                  plannedStarttime.text,
                                  plannedEndtime.text,
                                  durationController.text,
                                  assigneeIdController.text,
                                  assigneeNameController.text,
                                  descriptionController.text,
                                  materials,
                                  context)
                              .then((value) {
                            taskViewModel.getTasks(context);
                            Navigator.pop(context);
                          });
                        },
                        text: AppLocalizations.of(context)!.save,
                        image: null,
                        mainAxisAlignment: MainAxisAlignment.center,
                        color: const Color(0xFF00B3FF),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB2B8BA),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 5, left: 35, right: 35),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .editTask, // "Add New Task",
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Image.asset(
                      'assets/icons/sidebar_icon.png',
                      // width: 147,
                      // height: 112,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
