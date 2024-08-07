import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/view_model/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TaskViewModel taskViewModel =
          Provider.of<TaskViewModel>(context, listen: false);
      taskViewModel.getTasks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    TaskViewModel taskViewModel = Provider.of<TaskViewModel>(context);
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
              child: Column(
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      right: 35,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(RoutesName.addtask);
                          },
                          child: Text(
                            "+ ${AppLocalizations.of(context)!.addNew}",
                            style: GoogleFonts.spaceGrotesk(
                              textStyle: const TextStyle(
                                color: Color(0xFF00B3FF),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: widthScreen * 0.8,
                    height: heightScreen - 170,
                    child: taskViewModel.tasks.isNotEmpty
                        ? ListView.builder(
                            itemCount: taskViewModel.tasks.length,
                            itemBuilder: (BuildContext context, int index) {
                              return taskListItem(taskViewModel, index);
                            },
                          )
                        : Center(
                            child: Text(
                                AppLocalizations.of(context)!.noTasksAddSome),
                          ),
                  ),
                ],
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
                              .allTasks, // "All Tasks",
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

  Padding taskListItem(TaskViewModel viewModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: ExpansionTile(
          backgroundColor: const Color(0xFF2D75B6),
          collapsedBackgroundColor: const Color(0xFF2D75B6),
          title: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewModel.tasks[index].title,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                viewModel.tasks[index].location,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          // subtitle: const Text('Custom expansion arrow icon'),
          onExpansionChanged: (bool expanded) {
            viewModel.isExpanded(index, expanded);
          },
          trailing: viewModel.customTileExpanded.isNotEmpty
              ? viewModel.customTileExpanded[index]
                  ? const Image(
                      image: AssetImage("assets/icons/right_arrow_icon.png"))
                  : const Image(
                      image: AssetImage("assets/icons/arrow_down_icon.png"))
              : const Image(
                  image: AssetImage("assets/icons/arrow_down_icon.png")),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 140,
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${viewModel.tasks[index].startTime} to ${viewModel.tasks[index].endTime}',
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          viewModel.tasks[index].duration,
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          viewModel.tasks[index].customerName,
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                    ),
                    child: Text(
                      viewModel.tasks[index].description,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
