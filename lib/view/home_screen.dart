import 'package:toolvio/utils/routes/routes_name.dart';
import 'package:toolvio/res/widgets/button_primary.dart';
import 'package:toolvio/view_model/customer_view_model.dart';
import 'package:toolvio/view_model/invoicing_view_model.dart';
import 'package:toolvio/view_model/language_view_model.dart';
import 'package:toolvio/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toolvio/res/widgets/revenue_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Language { english, german }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CustomerViewModel customerViewModel =
          Provider.of<CustomerViewModel>(context, listen: false);
      customerViewModel.getCustomers(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    InvoicingViewModel invoicingViewModel =
        Provider.of<InvoicingViewModel>(context);
    debugPrint(
        "chartData ---> ${invoicingViewModel.chartData.map((e) => e.toJson())}");
    return Scaffold(
      backgroundColor: const Color(0xFFEDF9FF),
      appBar: AppBar(
        actions: [
          Consumer<LanguageViewModel>(
            builder: (context, provider, child) {
              return PopupMenuButton(
                onSelected: (Language item) {
                  if (Language.english.name == item.name) {
                    provider.changeLocale("en");
                  } else {
                    provider.changeLocale("de");
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<Language>>[
                  const PopupMenuItem(
                    value: Language.english,
                    child: Text("English"),
                  ),
                  const PopupMenuItem(
                    value: Language.german,
                    child: Text("German"),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 25, bottom: 5, left: 35, right: 35),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.hello, //"Hello",
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          loginViewModel.user!.name,
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              color: Color(0xFF00B3FF),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 35),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.revenue, //"Revenue",
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
              ),
              RevenueChart(
                screenWidth: screenWidth,
                data: invoicingViewModel.chartData,
                showDropDown: invoicingViewModel.filterDropDownOpen,
                invoiceBy: invoicingViewModel.invoiceBy == InvoiceBy.month
                    ? AppLocalizations.of(context)!.month //'month'
                    : AppLocalizations.of(context)!.week, //'week',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 35, right: 35),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.inTotal, //"In total",
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          "  ${invoicingViewModel.invoiceBy == InvoiceBy.month ? AppLocalizations.of(context)!.thisMonth : AppLocalizations.of(context)!.thisWeek}:",
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${invoicingViewModel.revenue} \$",
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ButtonPrimary(
                  screenWidth: screenWidth,
                  loading: false,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.addtask);
                  },
                  text: AppLocalizations.of(context)!.addNewTask, //'Add Task',
                  image: const AssetImage("assets/icons/add_icon.png"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  color: const Color(0xFF2D75B6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ButtonPrimary(
                  loading: false,
                  screenWidth: screenWidth,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.tasklist);
                  },
                  text: AppLocalizations.of(context)!.tasks, //'Tasks',
                  image: const AssetImage("assets/icons/right_arrow_icon.png"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  color: const Color(0xFF2D75B6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ButtonPrimary(
                  screenWidth: screenWidth,
                  loading: false,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.customerlist);
                  },
                  text: AppLocalizations.of(context)!.customers, //'Customers',
                  image: const AssetImage("assets/icons/right_arrow_icon.png"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  color: const Color(0xFF2D75B6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: ButtonPrimary(
                  screenWidth: screenWidth,
                  loading: false,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.createInvoice);
                  },
                  text: AppLocalizations.of(context)!
                      .createInvoice, //'Create Invoice',
                  image: const AssetImage("assets/icons/add_icon.png"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  color: const Color(0xFF2D75B6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
