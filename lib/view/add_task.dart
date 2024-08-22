import 'package:toolivo/models/customer_data.dart';
import 'package:toolivo/models/material_data.dart';
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

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController assigneeNameController = TextEditingController();
  TextEditingController assigneeIdController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController materialNameController = TextEditingController();
  TextEditingController materialQuantityController = TextEditingController();

  String assignee = '';

  // List of items in our dropdown menu
  List<String> assignees = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CustomerViewModel customerViewModel =
          Provider.of<CustomerViewModel>(context, listen: false);
      customerViewModel.getCustomers(context);
    });
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
                      value: taskViewModel.startTime,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.plannedStarttime,
                      maxLines: 1,
                      onPress: () async {
                        await taskViewModel.selectStartTime(context);
                      },
                    ),
                    ContainedTextField(
                      controller: null,
                      value: taskViewModel.endTime,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.plannedEndtime,
                      maxLines: 1,
                      onPress: () async {
                        await taskViewModel.selectEndTime(context);
                      },
                    ),
                    ContainedTextField(
                      controller: durationController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.plannedDuration,
                      maxLines: 1,
                      onPress: () {},
                      value: taskViewModel.duration,
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
                          taskViewModel.material.add(MaterialItem(
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
                        itemCount: taskViewModel.material.length,
                        itemBuilder: (context, index) {
                          return MaterialListItem(
                            name: taskViewModel.material[index].name,
                            quantiy: taskViewModel.material[index].quantity,
                            showWhiteLine:
                                index != taskViewModel.material.length - 1,
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
                              .addTask(
                                  titleController.text,
                                  locationController.text,
                                  assigneeIdController.text,
                                  assigneeNameController.text,
                                  descriptionController.text,
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
                              .addNewTask, // "Add New Task",
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
