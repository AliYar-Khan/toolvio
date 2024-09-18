import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:toolivo/models/customer_data.dart';
import 'package:toolivo/res/widgets/button_primary.dart';
import 'package:toolivo/res/widgets/contained_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:toolivo/view_model/customer_view_model.dart';

class Customer extends StatefulWidget {
  const Customer({super.key});

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  String docId = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as CustomerData;
      if (kDebugMode) {
        print(arguments.name);
      }
      setState(() {
        docId = arguments.docId!;
        nameController.text = arguments.name;
        companyNameController.text = arguments.companyName;
        emailController.text = arguments.email;
        phoneController.text = arguments.phone;
        addressController.text = arguments.address;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    CustomerViewModel customerViewModel =
        Provider.of<CustomerViewModel>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFB2B8BA),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
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
                      controller: nameController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.name,
                      maxLines: 1,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextField(
                      controller: companyNameController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.companyName,
                      maxLines: 1,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextField(
                      controller: phoneController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.phoneNumber,
                      maxLines: 1,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextField(
                      controller: emailController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.email,
                      maxLines: 1,
                      onPress: () {},
                      value: '',
                    ),
                    ContainedTextField(
                      controller: addressController,
                      widthScreen: widthScreen,
                      title: AppLocalizations.of(context)!.address,
                      maxLines: 8,
                      onPress: () {},
                      value: '',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: ButtonPrimary(
                        screenWidth: widthScreen,
                        loading: false,
                        onTap: () async {
                          await customerViewModel
                              .editCustomer(
                                  docId,
                                  nameController.text,
                                  companyNameController.text,
                                  emailController.text,
                                  phoneController.text,
                                  addressController.text,
                                  context)
                              .then((value) {
                            customerViewModel.getCustomers(context);
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
                              .editCustomer, //"Add New Customer",
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
