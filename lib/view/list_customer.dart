import 'package:flutter/foundation.dart';
import 'package:toolivo/models/customer_data.dart';
import 'package:toolivo/utils/routes/routes_name.dart';
import 'package:toolivo/view_model/customer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({super.key});

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  bool _customTileExpanded = false;

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
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    CustomerViewModel customerViewModel =
        Provider.of<CustomerViewModel>(context);
    if (kDebugMode) {
      print(customerViewModel.customers.first.docId);
    }
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
                            Navigator.pushNamed(
                                context, RoutesName.addcustomer);
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
                    child: customerViewModel.customers.isNotEmpty
                        ? ListView.builder(
                            itemCount: customerViewModel.customers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return customerListItem(
                                  customerViewModel.customers, index);
                            },
                          )
                        : Center(
                            child: Text(AppLocalizations.of(context)!
                                .noCustomersAddSome), //"No customers, Add some"),
                          ),
                  )
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
                              .allCustomers, //"All Customers",
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

  Padding customerListItem(List<CustomerData> data, index) {
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
                data[index].name,
                style: GoogleFonts.spaceGrotesk(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                data[index].companyName,
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
            setState(() {
              _customTileExpanded = expanded;
            });
          },
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              _customTileExpanded
                  ? const Image(
                      image: AssetImage("assets/icons/right_arrow_icon.png"),
                      width: 15,
                      height: 15,
                    )
                  : const Image(
                      image: AssetImage("assets/icons/arrow_down_icon.png"),
                      width: 15,
                      height: 15,
                    ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.customer,
                    arguments: data[index],
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Image(
                    image: AssetImage("assets/icons/edit.png"),
                    width: 20,
                    height: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data[index].email,
                          style: GoogleFonts.spaceGrotesk(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ),
                        Text(
                          data[index].phone,
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
                      left: 10,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          data[index].address,
                          textAlign: TextAlign.left,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
