import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/res/widgets/button_primary.dart';
import 'package:toolvio/view_model/invoicing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateInvoiceSelectTasks extends StatefulWidget {
  const CreateInvoiceSelectTasks({super.key});

  @override
  State<CreateInvoiceSelectTasks> createState() =>
      _CreateInvoiceSelectTasksState();
}

class _CreateInvoiceSelectTasksState extends State<CreateInvoiceSelectTasks> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      InvoicingViewModel invoicingViewModel =
          Provider.of<InvoicingViewModel>(context, listen: false);
      invoicingViewModel.getTasks(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    InvoicingViewModel invoicingViewModel =
        Provider.of<InvoicingViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEEFAFF),
        body: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.printInvoice);
                        },
                        child: Container(
                          width: widthScreen * 0.8,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!
                                .createInvoice, // "Create Invoice",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: widthScreen * 0.8,
                        height: 2,
                        color: const Color(0xFF868686),
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .createInvoiceFromLastTasks, // "Create Invoice from last tasks",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(
                        width: widthScreen * 0.8,
                        height: heightScreen - 170,
                        child: ListView.builder(
                          itemCount: invoicingViewModel.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return taskListItem(index, invoicingViewModel);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                left: widthScreen * 0.1,
                right: widthScreen * 0.1,
                bottom: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonPrimary(
                      screenWidth: widthScreen,
                      loading: false,
                      color: const Color(0xFF1E5C94),
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.printInvoice);
                      },
                      text: AppLocalizations.of(context)!
                          .createInvoice, // "Create Invoice",
                      image: null,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding taskListItem(int index, InvoicingViewModel viewModel) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      return const Color(0xFF2D75B6);
                    }),
                    value: viewModel.data[index].isChecked ?? false,
                    onChanged: (bool? value) {
                      if (value != null && value == true) {
                        viewModel.addChecked(index, context);
                      } else {
                        viewModel.removeChecked(index);
                      }
                    },
                    side: const BorderSide(
                      color: Colors.white,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  Text(
                    viewModel.data[index].title,
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
              Text(
                viewModel.data[index].location,
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
            // _customTileExpanded = expanded;
          },
          trailing: viewModel.customTileExpanded[index]
              ? const Image(
                  image: AssetImage("assets/icons/right_arrow_icon.png"))
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
                          '${viewModel.data[index].startTime} to ${viewModel.data[index].endTime}',
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          viewModel.data[index].duration,
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          viewModel.data[index].customerName,
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
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                    ),
                    child: Text(
                      viewModel.data[index].description,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
