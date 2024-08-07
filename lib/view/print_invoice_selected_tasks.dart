import 'package:toolvio/models/material_data.dart';
import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/utils/utils.dart';
import 'package:toolvio/res/widgets/button_primary.dart';
import 'package:toolvio/res/widgets/material_list_item.dart';
import 'package:toolvio/view_model/invoicing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrintInvoiceSelectedTasks extends StatefulWidget {
  const PrintInvoiceSelectedTasks({super.key});

  @override
  State<PrintInvoiceSelectedTasks> createState() =>
      _PrintInvoiceSelectedTasksState();
}

class _PrintInvoiceSelectedTasksState extends State<PrintInvoiceSelectedTasks> {
  TextEditingController invoiceTotalController = TextEditingController();
  List<MaterialItem> data = [
    MaterialItem(name: "Hammer", quantity: 2),
    MaterialItem(name: "Screw Driver", quantity: 4),
  ];

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    // double heightScreen = MediaQuery.of(context).size.height;
    InvoicingViewModel invoicingViewModel =
        Provider.of<InvoicingViewModel>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEEFAFF),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: widthScreen * 0.8,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!
                              .createInvoice, //"Create Invoice",
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: widthScreen * 0.8,
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  invoicingViewModel
                                      .invoiceCustomer!.name, //customername
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
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
                                height: 95,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDEDED),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //address on three rows
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                      ),
                                      child: Text(invoicingViewModel
                                          .invoiceCustomer!.address
                                          .split(",")[0]),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                      ),
                                      child: Text(invoicingViewModel
                                          .invoiceCustomer!.address
                                          .split(",")[1]),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 10,
                                      ),
                                      child: Text(invoicingViewModel
                                          .invoiceCustomer!.address
                                          .split(",")[2]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: widthScreen * 0.8,
                            child: invoicingViewModel.invoicedTasks.isNotEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount:
                                        invoicingViewModel.invoicedTasks.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return invoiceTaskListItem(
                                          invoicingViewModel,
                                          index,
                                          widthScreen);
                                    },
                                  )
                                : Center(
                                    child: Text(AppLocalizations.of(context)!
                                        .noTasksAddSome),
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: widthScreen * 0.8,
                                height: 45,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0EB7FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .worked, // "Worked",
                                          style: GoogleFonts.spaceGrotesk(
                                            textStyle: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      invoicingViewModel
                                          .invoicedTasks[0].duration,
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
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: widthScreen * 0.8,
                                height: 1,
                                color: Colors.black,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: widthScreen * 0.1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .invoiceAmount, // "Rechnungssumme:",
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: (widthScreen * 0.80) / 4,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: invoiceTotalController,
                                    onSubmitted: (String? value) {
                                      invoicingViewModel.setTotal(
                                          invoiceTotalController.text);
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: invoicingViewModel.invoiceTotal,
                                      hintStyle: GoogleFonts.spaceGrotesk(
                                        textStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: widthScreen * 0.8,
                                height: 1,
                                color: Colors.black,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: widthScreen * 0.8,
                                height: 1,
                                color: Colors.black,
                                margin: const EdgeInsets.only(bottom: 20),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ButtonPrimary(
                                screenWidth: widthScreen,
                                loading: invoicingViewModel.loading,
                                color: const Color(0xFF00B3FF),
                                onTap: () {
                                  Utils.toastMessage(
                                      AppLocalizations.of(context)!.printing);
                                  invoicingViewModel
                                      .printPDF(context)
                                      .then((value) {
                                    if (value) {
                                      invoicingViewModel.clearDataTasks();
                                      Utils.toastMessage(
                                          AppLocalizations.of(context)!
                                              .invoiceSaved);
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        Navigator.pushNamed(
                                            context, RoutesName.home);
                                      });
                                    }
                                  });
                                },
                                text: AppLocalizations.of(context)!.print,
                                image: null,
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonPrimary(
                                  screenWidth: widthScreen,
                                  loading: false,
                                  color: const Color(0xFF1E5C94),
                                  onTap: () {
                                    Utils.toastMessage(
                                        AppLocalizations.of(context)!
                                            .commingSoon);
                                  },
                                  text:
                                      AppLocalizations.of(context)!.sendByEmail,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget invoiceTaskListItem(
      InvoicingViewModel invoicingViewModel, int index, double widthScreen) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: widthScreen * 0.8,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                invoicingViewModel.invoicedTasks[index].title, //task
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 20,
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
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                "${AppLocalizations.of(context)!.description}: ",
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
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
              height: 110,
              alignment: Alignment.centerLeft,
              padding:
                  const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(4),
              ),
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Text(
                invoicingViewModel.invoicedTasks[index].description, //task
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
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
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(
                top: 10,
              ),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.reportForDate,
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${invoicingViewModel.reportForDate.day.toString()}.${invoicingViewModel.reportForDate.month.toString()}.${invoicingViewModel.reportForDate.year.toString()}",
                    style: GoogleFonts.spaceGrotesk(
                      textStyle: const TextStyle(
                        color: Color(0xFF00B3FF),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF00B3FF),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await invoicingViewModel.selectReportDate(context);
                    },
                    child: Image.asset(
                      "assets/icons/edit.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
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
                itemCount:
                    invoicingViewModel.invoicedTasks[index].material.length,
                itemBuilder: (context, index) {
                  return MaterialListItem(
                    name: invoicingViewModel
                        .invoicedTasks[index].material[index].name,
                    quantiy: invoicingViewModel
                        .invoicedTasks[index].material[index].quantity,
                    showWhiteLine: index !=
                        invoicingViewModel
                                .invoicedTasks[index].material.length -
                            1,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
